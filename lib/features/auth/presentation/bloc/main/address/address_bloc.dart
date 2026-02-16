import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/services/location/location_services.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/address/add_address_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/address/delete_address_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/address/get_address_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/address/get_current_location_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/address/set_default_address_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/address/update_address_usecase.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/address/address_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/address/address_state.dart';

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

    try {
      final addresses = await getAddressUsecase.call(event.userId);
      emit(AddressesLoadedState(addresses: addresses));
    } catch (e) {
      emit(AddressErrorState(message: e.toString()));
    }
  }

  Future<void> _onAddAddress(
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

  Future<void> _onUpdateAddress(
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

  Future<void> _onDeleteAddress(
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

  Future<void> _onSetDefaultAddress(
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

  Future<void> _onGetCurrentLocation(
    GetCurrentLocationEvent event,
    Emitter<AddressState> emit,
  ) async {
    try {
      emit(LocationLoadingState());

      
      final locationData = await getCurrentLocationUsecase.call();

      emit(
        LocationLoadedState(
          latitude: locationData['latitude'] as double,
          longitude: locationData['longitude'] as double,
          accuracy: locationData['accuracy'] as double? ?? 0.0,
          addressName: locationData['addressName'] as String?,
        ),
      );
    } on LocationException catch (e) {
      
      emit(
        AddressErrorState(
          message: e.getUserFriendlyMessage(),
        ),
      );
    } catch (e) {
      
      String errorMessage = 'An unexpected error occurred. Please try again.';

      final errorStr = e.toString();

      if (errorStr.contains('Location services are disabled')) {
        errorMessage = 'Please enable location services in Settings > Location';
      } else if (errorStr.contains('Location permission')) {
        errorMessage =
            'Location permission is required. Please grant it in app settings.';
      } else if (errorStr.contains('timed out')) {
        errorMessage = 'Location request timed out. Please try again.';
      } else if (errorStr.contains('No last known location')) {
        errorMessage =
            'No location found. Please check your location settings.';
      }

      emit(
        AddressErrorState(
          message: errorMessage,
        ),
      );
    }
  }
}