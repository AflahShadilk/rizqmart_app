import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/address/add_address_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/address/delete_address_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/address/get_address_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/address/get_current_location_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/address/set_default_address_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/address/update_address_usecase.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/address/address_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/address/address_state.dart';

/// Business logic handling user addresses and location services (adding, updating, fetching).
class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final GetAddressUsecase getAddressUsecase;
  final AddAddressUsecase addAddressUsecase;
  final UpdateAddressUsecase updateAddressUsecase;
  final DeleteAddressUsecase deleteAddressUsecase;
  final SetDefaultAddressUsecase setDefaultAddressUsecase;
  final GetCurrentLocationUsecase getCurrentLocationUsecase;

  AddressBloc({
    required this.getAddressUsecase,
    required this.addAddressUsecase,
    required this.updateAddressUsecase,
    required this.deleteAddressUsecase,
    required this.setDefaultAddressUsecase,
    required this.getCurrentLocationUsecase,
  }) : super(AddressInitialState()) {
    on<LoadAddressesEvent>(_onLoadAddresses);
    on<AddAddressEvent>(_onAddAddress);
    on<UpdateAddressEvent>(_onUpdateAddress);
    on<DeleteAddressEvent>(_onDeleteAddress);
    on<SetDefaultAddressEvent>(_onSetDefaultAddress);
    on<GetCurrentLocationEvent>(_onGetCurrentLocation);
  }

  Future<void> _onLoadAddresses(
    LoadAddressesEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoadingState());
    final result = await getAddressUsecase.call(event.userId);
    result.fold(
      (failure) => emit(AddressErrorState(message: failure.message)),
      (addresses) => emit(AddressesLoadedState(addresses: addresses)),
    );
  }

  Future<void> _onAddAddress(
    AddAddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoadingState());
    final result = await addAddressUsecase.call(event.address);
    result.fold(
      (failure) => emit(AddressErrorState(message: failure.message)),
      (newAddress) {
        emit(AddressAddedState(address: newAddress));
        add(LoadAddressesEvent(userId: event.address.userId));
      },
    );
  }

  Future<void> _onUpdateAddress(
    UpdateAddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoadingState());
    final result = await updateAddressUsecase.call(event.address);
    result.fold(
      (failure) => emit(AddressErrorState(message: failure.message)),
      (updatedAddress) {
        emit(AddressUpdatedState(address: updatedAddress));
        add(LoadAddressesEvent(userId: event.address.userId));
      },
    );
  }

  Future<void> _onDeleteAddress(
    DeleteAddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoadingState());
    final result = await deleteAddressUsecase.call(event.userId, event.addressId);
    result.fold(
      (failure) => emit(AddressErrorState(message: failure.message)),
      (_) {
        emit(AddressDeletedState(message: 'Address deleted successfully'));
        add(LoadAddressesEvent(userId: event.userId));
      },
    );
  }

  Future<void> _onSetDefaultAddress(
    SetDefaultAddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoadingState());
    final result = await setDefaultAddressUsecase.call(event.userId, event.addressId);
    result.fold(
      (failure) => emit(AddressErrorState(message: failure.message)),
      (_) {
        emit(DefaultAddressSetState(message: 'Default address updated'));
        add(LoadAddressesEvent(userId: event.userId));
      },
    );
  }

  Future<void> _onGetCurrentLocation(
    GetCurrentLocationEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(LocationLoadingState());
    final result = await getCurrentLocationUsecase.call();
    result.fold(
      (failure) => emit(AddressErrorState(message: failure.message)),
      (locationData) {
        emit(
          LocationLoadedState(
            latitude: locationData['latitude'] as double,
            longitude: locationData['longitude'] as double,
            accuracy: locationData['accuracy'] as double? ?? 0.0,
            addressName: locationData['addressName'] as String?,
          ),
        );
      },
    );
  }
}