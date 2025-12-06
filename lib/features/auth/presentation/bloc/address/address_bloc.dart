import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/address/add_address_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/address/delete_address_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/address/get_address_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/address/get_current_location_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/address/set_default_address_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/address/update_address_usecase.dart';
import 'package:rizqmart/features/auth/presentation/bloc/address/address_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/address/address_state.dart';

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
  required this.getCurrentLocationUsecase
  }) : super(AddressInitialState()) {
    on<LoadAddressesEvent>(onLoadAddresses);
    on<AddAddressEvent>(onAddAddress);
    on<UpdateAddressEvent>(onUpdateAddress);
    on<DeleteAddressEvent>(onDeleteAddress);
    on<SetDefaultAddressEvent>(onSetDefaultAddress);
    on<GetCurrentLocationEvent>(onGetCurrentLocation);
  }

  Future<void> onLoadAddresses(
    LoadAddressesEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoadingState());

    try {
      final addresses = await getAddressUsecase.call(event.userId);
      emit(AddressesLoadedState(addresses: addresses));
    } catch (e) {
      emit(AddressErrorState(message: e.toString()));
    }
  }

  Future<void> onAddAddress(
    AddAddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoadingState());

    try {
      final newAddress = await addAddressUsecase.call(event.address);
      emit(AddressAddedState(address: newAddress));
      
      add(LoadAddressesEvent(userId: event.address.userId));
    } catch (e) {
      emit(AddressErrorState(message: e.toString()));
    }
  }

  Future<void> onUpdateAddress(
    UpdateAddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoadingState());

    try {
      final updatedAddress = await updateAddressUsecase.call(event.address);
      emit(AddressUpdatedState(address: updatedAddress));
      
      add(LoadAddressesEvent(userId: event.address.userId));
    } catch (e) {
      emit(AddressErrorState(message: e.toString()));
    }
  }

  Future<void> onDeleteAddress(
    DeleteAddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoadingState());

    try {
      await deleteAddressUsecase.call(event.userId, event.addressId);
      emit(AddressDeletedState(message: 'Address deleted successfully'));
      
      add(LoadAddressesEvent(userId: event.userId));
    } catch (e) {
      emit(AddressErrorState(message: e.toString()));
    }
  }

  Future<void> onSetDefaultAddress(
    SetDefaultAddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoadingState());

    try {
      await setDefaultAddressUsecase.call(event.userId, event.addressId);
      emit(DefaultAddressSetState(message: 'Default address updated'));
      
      add(LoadAddressesEvent(userId: event.userId));
    } catch (e) {
      emit(AddressErrorState(message: e.toString()));
    }
  }

  Future<void> onGetCurrentLocation(
    GetCurrentLocationEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoadingState());

    try {
      final location = await getCurrentLocationUsecase.call();
      
      emit(LocationLoadedState(
        latitude: location['latitude'] as double,
        longitude: location['longitude'] as double,
        accuracy: location['accuracy'] as double,
      ));
    } catch (e) {
      emit(AddressErrorState(message: e.toString()));
    }
  }
}