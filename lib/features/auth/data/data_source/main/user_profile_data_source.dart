import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:rizqmart/core/services/cloudinary.dart';
import 'package:rizqmart/features/auth/data/model/main/user_profile_firestore_model.dart';
import 'package:rizqmart/features/auth/domain/entities/main/user_profile_entities.dart';

class UserProfileDataSource {
  final FirebaseFirestore firestore;
 UserProfileDataSource({required this.firestore});
  
  CollectionReference get userCollection=>firestore.collection('users');

  Future<UserProfileFirestoreModel>getUserProfile(String userId)async{
    try{
      final documnetSnap= await userCollection.doc(userId).get();

      if(!documnetSnap.exists){
        throw Exception('User Profile not found');

      }
      return UserProfileFirestoreModel.fromFirestore(documnetSnap);
    }on FirebaseException catch (e) {
      throw Exception('Failed to fetch user profile: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch user profile: $e');
    }
  }

  Future<UserProfileFirestoreModel>updateProfile(UserProfileEntities profile)async{
    try{
      final model=UserProfileFirestoreModel.fromEntity(profile);

      await userCollection.doc(profile.userId).set(
       model.toJson(),
       SetOptions(merge: true)
      );
      final updatedDoc=await userCollection.doc(profile.userId).get();
      return UserProfileFirestoreModel.fromFirestore(updatedDoc);
    }on FirebaseException catch (e) {
      throw Exception('Failed to update profile: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }
  
  Future<String>uploadProfilePhoto(String userId, FilePickerResult file)async{
    try{
      final photoUrl=await uploadToCloudinary(  file);
      if (photoUrl == null || photoUrl.isEmpty) {
        throw Exception('Failed to upload photo to Cloudinary');
      }
      await userCollection.doc(userId).update({
        'photoUrl':photoUrl,
        'updatedAt':DateTime.now().toIso8601String()
      });
      return photoUrl;
    }on FirebaseException catch (e) {
      throw Exception('Failed to update profile photo in Firestore: ${e.message}');
    } catch (e) {
      throw Exception('Failed to upload profile photo: $e');
    }
  }
  
  Future<void>deleteProfilePhoto(String userId)async{
    try{
      await userCollection.doc(userId).update({
        'photoUrl':FieldValue.delete(),
        'updatedAt':DateTime.now().toIso8601String()
      });
    } on FirebaseException catch (e) {
      throw Exception('Failed to delete profile photo: ${e.message}');
    } catch (e) {
      throw Exception('Failed to delete profile photo: $e');
    }
  }

}