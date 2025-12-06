import 'package:equatable/equatable.dart';

class AddressEntities extends Equatable {
  final String id;
  final String userId;
  final String label;
  final String fullName;
  final String phoneNumber;
  final String address1;
  final String address2;
  final String city;
  final String state;
  final String pincode;
  final double? latitude;
  final double? longitude;
  final bool isDefault;
  final DateTime createdAt;

  const AddressEntities(
      {required this.id,
      required this.userId,
      required this.label,
      required this.fullName,
      required this.phoneNumber,
      required this.address1,
      required this.address2,
      required this.city,
      required this.state,
      required this.pincode,
      this.latitude,
      this.longitude,
      this.isDefault = false,
      required this.createdAt});

  AddressEntities copyWith({
    String? id,
    String? userId,
    String? label,
    String? fullName,
    String? phoneNumber,
    String? address1,
    String? address2,
    String? city,
    String? state,
    String? pincode,
    double? latitude,
    double? longitude,
    bool? isDefault,
    DateTime? createdAt,
  }) {
    return AddressEntities(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        label: label ?? this.label,
        fullName: fullName ?? this.fullName,
        phoneNumber: phoneNumber??this.phoneNumber,
        address1: address1 ?? this.address1,
        address2: address2 ?? this.address2,
        city: city ?? this.city,
        state: state ?? this.state,
        pincode: pincode ?? this.pincode,
        latitude: latitude??this.latitude,
        longitude: longitude??this.longitude,
        isDefault: isDefault??this.isDefault,
        createdAt: createdAt ?? this.createdAt);
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        label,
        phoneNumber,
        fullName,
        address1,
        address2,
        city,
        state,
        pincode,
        latitude,
        longitude,
        isDefault,
        createdAt
      ];
}
