import 'package:rizqmart/features/auth/domain/entities/main/address_entities.dart';

abstract class AddressRepository {
  Future<List<AddressEntities>>getAddresses(String userId);
  Future<AddressEntities> addAddress(AddressEntities addAddress);
  Future<AddressEntities >updateAdress(AddressEntities updateAddress);

  Future<void>deleteAddress(String userId,String addressId);
  Future<void>setDefaultAddress(String userId,String addressId);
  Future<Map<String,dynamic>>getCurrentLocation();
}