import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/domain/repositories/main/address_repository.dart';

/// Use case for permanently removing an address from the user's saved addresses.
class DeleteAddressUsecase {
  final AddressRepository repository;
  const DeleteAddressUsecase(this.repository);
  Future<Either<Failure, void>> call(String userId,String addressId) async {
    return await repository.deleteAddress(userId,addressId);
  }
 }