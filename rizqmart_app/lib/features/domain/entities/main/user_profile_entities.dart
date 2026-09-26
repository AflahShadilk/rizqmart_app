import 'package:equatable/equatable.dart';

/// Entity representing detailed user profile information, including demographics and wallet balance.
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
  final double walletBalance;
  
  const UserProfileEntities({
    required this.userId,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.photoUrl,
    this.bio,
    this.dateOfBirth,
    this.gender,
    required this.updatedAt,
    this.walletBalance = 0.0,
  });

  @override
  
  List<Object?> get props => [userId,name,email,phoneNumber,photoUrl,bio,dateOfBirth,gender,updatedAt,walletBalance];

}