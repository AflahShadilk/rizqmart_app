import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizqmart/features/auth/domain/entities/main/address_entities.dart';
class AddressFireStoreModel extends AddressEntities {
  const AddressFireStoreModel(
      {required super.id,
      required super.userId,
      required super.label,
      required super.fullName,
      required super.phoneNumber,
      required super.address1,
      required super.address2,
      required super.city,
      required super.state,
      required super.pincode,
      super.latitude,
      super.longitude,
      super.isDefault,
      required super.createdAt});

  factory AddressFireStoreModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AddressFireStoreModel(
        id: doc.id,
        userId: data['userId'] ?? '',
        label: data['label'] ?? '',
        fullName: data['fullName'] ?? '',
        phoneNumber: data['phoneNumber']??'',
        address1: data['address1'] ?? '',
        address2: data['address2'] ?? '',
        city: data['city'] ?? '',
        state: data['state'] ?? '',
        pincode: data['pincode'] ?? '',
        latitude: (data['latitude'] as num?)?.toDouble(),
        longitude: (data['longitude'] as num?)?.toDouble(),
        isDefault: data['isDefault'] ?? false,
        createdAt: data['createdAt'] != null
            ? DateTime.parse(data['createdAt'])
            : DateTime.now());
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'label': label,
      'fullName': fullName,
      'phoneNumber':phoneNumber,
      'address1': address1,
      'address2': address2,
      'city': city,
      'state': state,
      'pincode': pincode,
      'latitude': latitude,
      'longitude': longitude,
      'isDefault': isDefault,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory AddressFireStoreModel.fromEntity(AddressEntities entity) {
    return AddressFireStoreModel(
        id: entity.id,
        userId: entity.userId,
        label: entity.label,
        fullName: entity.fullName,
        phoneNumber: entity.phoneNumber,
        address1: entity.address1,
        address2: entity.address2,
        city: entity.city,
        state: entity.state,
        pincode: entity.pincode,
        latitude: entity.latitude,
        longitude: entity.longitude,
        isDefault: entity.isDefault,
        createdAt: entity.createdAt);
  }
}
