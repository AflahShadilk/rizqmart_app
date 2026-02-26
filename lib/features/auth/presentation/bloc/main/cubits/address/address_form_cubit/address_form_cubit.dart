import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/auth/domain/entities/main/address_entities.dart';
import 'address_form_state.dart';

/// Cubit holding all temporary inputted data fields when creating or editing an address.
class AddressFormCubit extends Cubit<AddressFormState> {
  AddressFormCubit(AddressEntities? initialAddress)
      : super(
          initialAddress != null
              ? AddressFormState(
                  label: initialAddress.label,
                  fullName: initialAddress.fullName,
                  phoneNumber: initialAddress.phoneNumber,
                  address1: initialAddress.address1,
                  address2: initialAddress.address2,
                  city: initialAddress.city,
                  state: initialAddress.state,
                  pincode: initialAddress.pincode,
                  latitude: initialAddress.latitude,
                  longitude: initialAddress.longitude,
                  isDefault: initialAddress.isDefault,
                )
              : const AddressFormState(),
        );

  void updateLabel(String newLabel) {
    emit(state.copyWith(label: newLabel));
  }

  void updateFullName(String newFullName) {
    emit(state.copyWith(fullName: newFullName));
  }

  void updatePhoneNumber(String newPhoneNumber) {
    emit(state.copyWith(phoneNumber: newPhoneNumber));
  }

  void updateAddress1(String newAddress1) {
    emit(state.copyWith(address1: newAddress1));
  }

  void updateAddress2(String newAddress2) {
    emit(state.copyWith(address2: newAddress2));
  }

  void updateCity(String newCity) {
    emit(state.copyWith(city: newCity));
  }

  void updateState(String newState) {
    emit(state.copyWith(state: newState));
  }

  void updateCountry(String newCountry) {
    emit(state.copyWith(country: newCountry));
  }

  void updatePincode(String newPincode) {
    emit(state.copyWith(pincode: newPincode));
  }

  void updateLocation(double latitude, double longitude) {
    emit(state.copyWith(latitude: latitude, longitude: longitude));
  }

  void toggleDefault() {
    emit(state.copyWith(isDefault: !state.isDefault));
  }

  void clearLocation() {
    emit(AddressFormState(
      label: state.label,
      fullName: state.fullName,
      phoneNumber: state.phoneNumber,
      address1: state.address1,
      address2: state.address2,
      city: state.city,
      state: state.state,
      country: state.country,
      pincode: state.pincode,
      latitude: null,
      longitude: null,
      isDefault: state.isDefault,
    ));
  }
}