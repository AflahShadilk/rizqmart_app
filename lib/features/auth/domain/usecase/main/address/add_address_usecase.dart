import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/auth/domain/entities/main/address_entities.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/address_repository.dart';
class AddAddressUsecase {
  final AddressRepository repository;
  const AddAddressUsecase(this.repository);
  Future<Either<Failure, AddressEntities>> call(AddressEntities addAddress) async {
    return await repository.addAddress(addAddress);  
  }
}