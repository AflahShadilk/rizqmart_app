import 'package:equatable/equatable.dart';

class UserProfileEntities extends Equatable{
  final String userId;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? photoUrl;
  final String? bio;
  final DateTime? dateOfBirth;
  final String ? gender;
  final DateTime updatedAt;
  
  const UserProfileEntities({
    required this.userId,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.photoUrl,
    this.bio,
    this.dateOfBirth,
    this.gender,
    required this.updatedAt
  });

  @override
  
  List<Object?> get props => [userId,name,email,phoneNumber,photoUrl,bio,dateOfBirth,gender,updatedAt];

}