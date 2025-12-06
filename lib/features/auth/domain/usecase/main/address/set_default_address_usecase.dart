 import 'package:rizqmart/features/auth/domain/repositories/main/address_repository.dart';

class SetDefaultAddressUsecase  {
  final AddressRepository repository;
   const SetDefaultAddressUsecase(this.repository);
  Future<void>call(String userId,String addressId)async{
    return await repository.setDefaultAddress(userId, addressId);
  }
 }