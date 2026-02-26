import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:rizqmart/core/services/cloudinary.dart';
import 'package:rizqmart/features/auth/data/model/main/user_profile_firestore_model.dart';
import 'package:rizqmart/features/auth/domain/entities/main/user_profile_entities.dart';

/// Remote data source handling user profile data storage and avatar tracking via Firestore.
class UserProfileDataSource {
  final FirebaseFirestore firestore;
  
  UserProfileDataSource({required this.firestore});

  CollectionReference get userCollection => firestore.collection('users');

  Future<UserProfileFirestoreModel> getUserProfile(String userId) async {
    try {
      if (userId.isEmpty) {
        throw Exception('User ID cannot be empty');
      }

      final documentSnap = await userCollection.doc(userId).get();

      if (!documentSnap.exists) {
        throw Exception('User Profile not found');
      }

      return UserProfileFirestoreModel.fromFirestore(documentSnap);
    } on FirebaseException catch (e) {
      throw Exception('Failed to fetch user profile: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch user profile: $e');
    }
  }

  Future<UserProfileFirestoreModel> updateProfile(
      UserProfileEntities profile) async {
    try {
      if (profile.userId.isEmpty) {
        throw Exception('User ID cannot be empty when updating profile');
      }

      final model = UserProfileFirestoreModel.fromEntity(profile);

      await userCollection.doc(profile.userId).set(
        model.toJson(),
        SetOptions(merge: true),
      );

      final updatedDoc = await userCollection.doc(profile.userId).get();
      return UserProfileFirestoreModel.fromFirestore(updatedDoc);
    } on FirebaseException catch (e) {
      throw Exception('Failed to update profile: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  Future<String> uploadProfilePhoto(
    String userId, FilePickerResult file) async {
  try {
    if (userId.isEmpty) {
      throw Exception('User ID cannot be empty');
    }

    if (file.files.isEmpty) {
      throw Exception('No file selected');
    }

    final photoUrl = await uploadToCloudinary(file);

    if (photoUrl == null) {
      throw Exception('uploadToCloudinary returned null');
    }

    if (photoUrl.isEmpty) {
      throw Exception('uploadToCloudinary returned empty string');
    }

    await userCollection.doc(userId).update({
      'photoUrl': photoUrl,
      'updatedAt': DateTime.now().toIso8601String(),
    });

    return photoUrl;
  } on FirebaseException catch (e) {
    throw Exception('Failed to update profile photo in Firestore: ${e.message}');
  } catch (e) {
    throw Exception('Failed to upload profile photo: $e');
  }
}

  Future<void> deleteProfilePhoto(String userId) async {
    try {
      if (userId.isEmpty) {
        throw Exception('User ID cannot be empty');
      }

      await userCollection.doc(userId).update({
        'photoUrl': FieldValue.delete(),
        'updatedAt': DateTime.now().toIso8601String(),
      });

    } on FirebaseException catch (e) {
      throw Exception('Failed to delete profile photo: ${e.message}');
    } catch (e) {
      throw Exception('Failed to delete profile photo: $e');
    }
  }
}