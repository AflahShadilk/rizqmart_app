import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/address_repository.dart';

/// Use case for marking a specific saved address as the primary delivery location.
class SetDefaultAddressUsecase  {
  final AddressRepository repository;
   const SetDefaultAddressUsecase(this.repository);
  Future<Either<Failure, void>> call(String userId,String addressId) async {
    return await repository.setDefaultAddress(userId, addressId);
  }
}