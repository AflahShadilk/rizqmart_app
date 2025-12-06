import 'package:rizqmart/features/auth/domain/entities/main/address_entities.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/address_repository.dart';

class UpdateAddressUsecase {
  final AddressRepository repository;
  const UpdateAddressUsecase(this.repository);
  Future<AddressEntities>call(AddressEntities updateAddress)async{
    return await repository.updateAdress(updateAddress);
  }
}