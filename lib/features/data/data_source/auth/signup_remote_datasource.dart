/// Interface defining the contract for handling user registration operations.
abstract class SignupRemoteDatasource {
  Future<Map<String,dynamic>>signUp({required String name,required String email,required String password});
}