

import 'package:equatable/equatable.dart';

class AddressFormState extends Equatable {
  final String label;
  final String fullName;
  final String phoneNumber;
  final String address1;
  final String address2;
  final String city;
  final String state;
  final String country;
  final String pincode;
  final double? latitude;
  final double? longitude;
  final bool isDefault;

  const AddressFormState({
    this.label = 'Home',
    this.fullName = '',
    this.phoneNumber = '',
    this.address1 = '',
    this.address2 = '',
    this.city = '',
    this.state = '',
    this.country = '',
    this.pincode = '',
    this.latitude,
    this.longitude,
    this.isDefault = false,
  });

  AddressFormState copyWith({
    String? label,
    String? fullName,
    String? phoneNumber,
    String? address1,
    String? address2,
    String? city,
    String? state,
    String? country,
    String? pincode,
    double? latitude,
    double? longitude,
    bool? isDefault,
  }) {
    return AddressFormState(
      label: label ?? this.label,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address1: address1 ?? this.address1,
      address2: address2 ?? this.address2,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      pincode: pincode ?? this.pincode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  @override
  List<Object?> get props => [
    label,
    fullName,
    phoneNumber,
    address1,
    address2,
    city,
    state,
    country,
    pincode,
    latitude,
    longitude,
    isDefault,
  ];
}