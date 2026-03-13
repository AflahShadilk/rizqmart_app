abstract class SignupRemoteDatasource {
  Future<Map<String,dynamic>>signUp({required String name,required String email,required String password});
}