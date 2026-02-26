import 'package:rizqmart/features/auth/domain/entities/auth/signup_page_entities.dart';

/// Data model used specifically during the initial user registration process.
class SignupUserModel extends SignupPageEntities{
  const SignupUserModel({required super.userId,required super.name,required super.email});

  Map<String ,dynamic>toMap(){
    return {'userId':userId,'name':name,'email':email};
  }
  factory SignupUserModel.fromMap(Map<String,dynamic>map){
    return SignupUserModel(userId: map['userId']as String, name: map['name']as String, email: map['email']as String);
  }
}