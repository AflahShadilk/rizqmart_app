import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/address_repository.dart';
class DeleteAddressUsecase {
  final AddressRepository repository;
  const DeleteAddressUsecase(this.repository);
  Future<Either<Failure, void>> call(String userId,String addressId) async {
    return await repository.deleteAddress(userId,addressId);
  }
 }