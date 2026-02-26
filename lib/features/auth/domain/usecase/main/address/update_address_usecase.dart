import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/auth/domain/entities/main/address_entities.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/address_repository.dart';

/// Use case for modifying details of an existing delivery address.
class UpdateAddressUsecase {
  final AddressRepository repository;
  const UpdateAddressUsecase(this.repository);
  Future<Either<Failure, AddressEntities>> call(AddressEntities updateAddress) async {
    return await repository.updateAdress(updateAddress);
  }
}