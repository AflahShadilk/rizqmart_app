 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizqmart/features/domain/entities/main/user_profile_entities.dart';

/// Comprehensive data model representing a user's profile, adapted for Firestore storage.
class UserProfileFirestoreModel extends UserProfileEntities{
  const UserProfileFirestoreModel({
    required super.userId,
    required super.name,
    required super.email,
    super.phoneNumber,
    super.photoUrl,
    super.bio,
    super.dateOfBirth,
    super.gender,
    required super.updatedAt,
    super.walletBalance,
  });

  factory UserProfileFirestoreModel.fromFirestore(DocumentSnapshot doc){
    final data=doc.data() as Map<String,dynamic>;
    return UserProfileFirestoreModel(
      userId: data['userId']??'', 
      name: data['name']??'',
      email: data['email']??'',
      phoneNumber: data['phoneNumber']??'',
      photoUrl: data['photoUrl']??'',
      bio: data['bio']??'',
      dateOfBirth: data['dateOfBirth']!=null?DateTime.parse(data['dateOfBirth']):null,
      gender: data['gender']??'',
      updatedAt: data['updatedAt']!=null?DateTime.parse(data['updatedAt']):DateTime.now(),
      walletBalance: (data['walletBalance'] ?? 0.0).toDouble(),
    );
  }

    Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name':name,
      'email':email,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'bio': bio,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'updatedAt': updatedAt.toIso8601String(),
      'walletBalance': walletBalance,
    };
  }

    factory UserProfileFirestoreModel.fromEntity(UserProfileEntities entity) {
    return UserProfileFirestoreModel(
      userId: entity.userId,
      name: entity.name,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      photoUrl: entity.photoUrl,
      bio: entity.bio,
      dateOfBirth: entity.dateOfBirth,
      gender: entity.gender,
      updatedAt: entity.updatedAt,
      walletBalance: entity.walletBalance,
    );
  }
}