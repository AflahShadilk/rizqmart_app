import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/domain/entities/main/address_entities.dart';
import 'package:rizqmart/features/domain/repositories/main/address_repository.dart';

/// Use case for adding a new delivery address to the user's profile.
class AddAddressUsecase {
  final AddressRepository repository;
  const AddAddressUsecase(this.repository);
  Future<Either<Failure, AddressEntities>> call(AddressEntities addAddress) async {
    return await repository.addAddress(addAddress);  
  }
}