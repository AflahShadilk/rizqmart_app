import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/auth/domain/entities/main/address_entities.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/address_repository.dart';

class GetAddressUsecase {
  final AddressRepository repository;
  const GetAddressUsecase(this.repository);
  Future<Either<Failure, List<AddressEntities>>> call(String userId) async {
    return await repository.getAddresses(userId);
  }
}