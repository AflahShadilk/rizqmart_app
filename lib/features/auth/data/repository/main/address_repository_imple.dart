import 'package:rizqmart/features/auth/data/data_source/main/address_data_source.dart';
import 'package:rizqmart/features/auth/domain/entities/main/address_entities.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/address_repository.dart';

class AddressRepositoryImpl implements AddressRepository {
  final AddressRemoteDataSource remoteDataSource;

  AddressRepositoryImpl({
    required this. remoteDataSource,
  }) ;

  @override
  Future<List<AddressEntities>> getAddresses(String userId) async {
    try {
      return await remoteDataSource.getAddresses(userId);
    } catch (e) {
      throw Exception('Repository: Failed to get addresses - $e');
    }
  }

  @override
  Future<AddressEntities> addAddress(AddressEntities addAddress) async {
    try {
      return await remoteDataSource.addAddress(addAddress);
    } catch (e) {
      throw Exception('Repository: Failed to add address - $e');
    }
  }

  @override
  Future<AddressEntities> updateAdress(AddressEntities updateAddress) async {
    try {
      return await remoteDataSource.updateAddress(updateAddress);
    } catch (e) {
      throw Exception('Repository: Failed to update address - $e');
    }
  }

  @override
  Future<void> deleteAddress(String userId, String addressId) async {
    try {
      await remoteDataSource.deleteAddress(userId, addressId);
    } catch (e) {
      throw Exception('Repository: Failed to delete address - $e');
    }
  }

  @override
  Future<void> setDefaultAddress(String userId, String addressId) async {
    try {
      await remoteDataSource.setDefaultAddress(userId, addressId);
    } catch (e) {
      throw Exception('Repository: Failed to set default address - $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getCurrentLocation() async {
    try {
      return await remoteDataSource.getCurrentLocation();
    } catch (e) {
      throw Exception('Repository: Failed to get current location - $e');
    }
  }
}