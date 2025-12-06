import 'package:rizqmart/features/auth/domain/repositories/main/address_repository.dart';

class DeleteAddressUsecase {
  final AddressRepository repository;
  const DeleteAddressUsecase(this.repository);
  Future<void>call(String userId,String addressId)async{
    return repository.deleteAddress(userId,addressId);
  }
 }