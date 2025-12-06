import 'package:rizqmart/features/auth/domain/entities/main/address_entities.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/address_repository.dart';

class GetAddressUsecase {
  final AddressRepository repository;
  const GetAddressUsecase(this.repository);
  Future<List<AddressEntities>>call(String userId)async{
    return await repository.getAddresses(userId);
  }
}