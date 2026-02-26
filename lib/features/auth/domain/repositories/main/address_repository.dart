import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/auth/domain/entities/main/address_entities.dart';

/// Abstract repository for managing user delivery addresses.
abstract class AddressRepository {
  Future<Either<Failure, List<AddressEntities>>> getAddresses(String userId);
  Future<Either<Failure, AddressEntities>> addAddress(AddressEntities addAddress);
  Future<Either<Failure, AddressEntities>> updateAdress(AddressEntities updateAddress);

  Future<Either<Failure, void>> deleteAddress(String userId, String addressId);
  Future<Either<Failure, void>> setDefaultAddress(String userId, String addressId);
  Future<Either<Failure, Map<String, dynamic>>> getCurrentLocation();
}