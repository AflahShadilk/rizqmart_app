import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/error_handler.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/auth/data/data_source/main/address_data_source.dart';
import 'package:rizqmart/features/auth/domain/entities/main/address_entities.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/address_repository.dart';
class AddressRepositoryImpl implements AddressRepository {
  final AddressRemoteDataSource remoteDataSource;

  AddressRepositoryImpl({
    required this. remoteDataSource,
  }) ;

  @override
  Future<Either<Failure, List<AddressEntities>>> getAddresses(String userId) {
    return ErrorHandler.executeApiCall(() async {
      return await remoteDataSource.getAddresses(userId);
    });
  }

  @override
  Future<Either<Failure, AddressEntities>> addAddress(AddressEntities addAddress) {
    return ErrorHandler.executeApiCall(() async {
      return await remoteDataSource.addAddress(addAddress);
    });
  }

  @override
  Future<Either<Failure, AddressEntities>> updateAdress(AddressEntities updateAddress) {
    return ErrorHandler.executeApiCall(() async {
      return await remoteDataSource.updateAddress(updateAddress);
    });
  }

  @override
  Future<Either<Failure, void>> deleteAddress(String userId, String addressId) {
    return ErrorHandler.executeApiCall(() async {
      await remoteDataSource.deleteAddress(userId, addressId);
    });
  }

  @override
  Future<Either<Failure, void>> setDefaultAddress(String userId, String addressId) {
    return ErrorHandler.executeApiCall(() async {
      await remoteDataSource.setDefaultAddress(userId, addressId);
    });
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getCurrentLocation() {
    return ErrorHandler.executeApiCall(() async {
      return await remoteDataSource.getCurrentLocation();
    });
  }
}