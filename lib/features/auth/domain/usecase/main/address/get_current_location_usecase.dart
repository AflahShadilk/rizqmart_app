 import 'package:rizqmart/features/auth/domain/repositories/main/address_repository.dart';

class GetCurrentLocationUsecase {
  final AddressRepository repository;
  const GetCurrentLocationUsecase(this.repository);
  Future<Map<String,dynamic>>call()async{
    return await repository.getCurrentLocation();
  }
 }