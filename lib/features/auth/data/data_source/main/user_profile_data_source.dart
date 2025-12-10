import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:rizqmart/core/services/cloudinary.dart';
import 'package:rizqmart/features/auth/data/model/main/user_profile_firestore_model.dart';
import 'package:rizqmart/features/auth/domain/entities/main/user_profile_entities.dart';

class UserProfileDataSource {
  // Firestore database instance for handling user profile data operations
  final FirebaseFirestore firestore;
  
  UserProfileDataSource({required this.firestore});

  // Reference to the users collection in Firestore
  CollectionReference get userCollection => firestore.collection('users');

  // Retrieves the user profile document from Firestore based on user ID
  Future<UserProfileFirestoreModel> getUserProfile(String userId) async {
    try {
      // Validate user ID before querying the database
      if (userId.isEmpty) {
        throw Exception('User ID cannot be empty');
      }

      // Fetch the user document from Firestore
      final documentSnap = await userCollection.doc(userId).get();

      // Check if the user profile document exists
      if (!documentSnap.exists) {
        throw Exception('User Profile not found');
      }

      // Convert Firestore document to user profile model
      return UserProfileFirestoreModel.fromFirestore(documentSnap);
    } on FirebaseException catch (e) {
      throw Exception('Failed to fetch user profile: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch user profile: $e');
    }
  }

  // Updates the user profile information in Firestore with merge option to preserve existing data
  Future<UserProfileFirestoreModel> updateProfile(
      UserProfileEntities profile) async {
    try {
      // Validate user ID before performing update operation
      if (profile.userId.isEmpty) {
        throw Exception('User ID cannot be empty when updating profile');
      }

      // Convert entity to Firestore model format
      final model = UserProfileFirestoreModel.fromEntity(profile);

      // Update the user document using merge to keep existing fields intact
      await userCollection.doc(profile.userId).set(
        model.toJson(),
        SetOptions(merge: true),
      );

      // Fetch and return the updated user profile document
      final updatedDoc = await userCollection.doc(profile.userId).get();
      return UserProfileFirestoreModel.fromFirestore(updatedDoc);
    } on FirebaseException catch (e) {
      throw Exception('Failed to update profile: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  // Uploads a profile photo to Cloudinary and updates the user document with the photo URL
  Future<String> uploadProfilePhoto(
    String userId, FilePickerResult file) async {
  try {
    // Validate user ID is not empty
    if (userId.isEmpty) {
      throw Exception('User ID cannot be empty');
    }

    // Check if file was selected
    if (file.files.isEmpty) {
      throw Exception('No file selected');
    }

    // Upload file to Cloudinary and get the photo URL
    final photoUrl = await uploadToCloudinary(file);

    // Validate that Cloudinary returned a valid URL
    if (photoUrl == null) {
      throw Exception('uploadToCloudinary returned null');
    }

    // Validate that the returned URL is not empty
    if (photoUrl.isEmpty) {
      throw Exception('uploadToCloudinary returned empty string');
    }

    // Update the user document with the new photo URL and timestamp
    await userCollection.doc(userId).update({
      'photoUrl': photoUrl,
      'updatedAt': DateTime.now().toIso8601String(),
    });

    // Return the uploaded photo URL
    return photoUrl;
  } on FirebaseException catch (e) {
    throw Exception('Failed to update profile photo in Firestore: ${e.message}');
  } catch (e) {
    throw Exception('Failed to upload profile photo: $e');
  }
}

  // Deletes the user profile photo by removing the photoUrl field from the user document
  Future<void> deleteProfilePhoto(String userId) async {
    try {
      // Validate user ID before performing delete operation
      if (userId.isEmpty) {
        throw Exception('User ID cannot be empty');
      }

      // Remove the photoUrl field from the user document and update timestamp
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