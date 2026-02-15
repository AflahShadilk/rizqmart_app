import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rizqmart/features/auth/data/model/main/address_fire_store_model.dart';
import 'package:rizqmart/features/auth/domain/entities/main/address_entities.dart';

class AddressRemoteDataSource {
  final FirebaseFirestore firestore;

  AddressRemoteDataSource({
    required this.firestore,
  });

  CollectionReference addressCollection(String userId) {
    return firestore.collection('users').doc(userId).collection('addresses');
  }

  Future<List<AddressFireStoreModel>> getAddresses(String userId) async {
    try {
      final snapshot = await addressCollection(userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => AddressFireStoreModel.fromFirestore(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to fetch addresses: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch addresses: $e');
    }
  }

  Future<AddressFireStoreModel> addAddress(AddressEntities address) async {
    try {
      final userAddressCollection = addressCollection(address.userId);

      if (address.isDefault) {
        await unsetAllDefaultAddresses(address.userId);
      }

      final model = AddressFireStoreModel.fromEntity(address);
      final dataToAdd = model.toJson();
      dataToAdd.remove('id');

      final docRef = await userAddressCollection.add(dataToAdd);
      final newDoc = await docRef.get();
      return AddressFireStoreModel.fromFirestore(newDoc);
    } on FirebaseException catch (e) {
      throw Exception('Failed to add address: ${e.message}');
    } catch (e) {
      throw Exception('Failed to add address: $e');
    }
  }

  Future<AddressFireStoreModel> updateAddress(AddressEntities address) async {
    try {
      final userAddressCollection = addressCollection(address.userId);

      if (address.isDefault) {
        await unsetAllDefaultAddresses(address.userId, excludeId: address.id);
      }

      final model = AddressFireStoreModel.fromEntity(address);
      final dataToUpdate = model.toJson();
      dataToUpdate.remove('id');

      // Update the address document and return the updated model
      await userAddressCollection.doc(address.id).update(dataToUpdate);
      final updatedDoc = await userAddressCollection.doc(address.id).get();
      return AddressFireStoreModel.fromFirestore(updatedDoc);
    } on FirebaseException catch (e) {
      throw Exception('Failed to update address: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update address: $e');
    }
  }

  // Deletes a specific address document from Firestore
  Future<void> deleteAddress(String userId, String addressId) async {
    try {
      await addressCollection(userId).doc(addressId).delete();
    } on FirebaseException catch (e) {
      throw Exception('Failed to delete address: ${e.message}');
    } catch (e) {
      throw Exception('Failed to delete address: $e');
    }
  }

  // Sets a specific address as the default address for delivery
  Future<void> setDefaultAddress(String userId, String addressId) async {
    try {
      // Unset all previous default addresses
      await unsetAllDefaultAddresses(userId);
      // Set the selected address as default
      await addressCollection(userId).doc(addressId).update({
        'isDefault': true,
      });
    } on FirebaseException catch (e) {
      throw Exception('Failed to set default address: ${e.message}');
    } catch (e) {
      throw Exception('Failed to set default address: $e');
    }
  }

  // Unsets the default status from all addresses, with optional exclusion for a specific address
  Future<void> unsetAllDefaultAddresses(String userId, {String? excludeId}) async {
    try {
      // Query all addresses marked as default for the user
      final snapshot = await addressCollection(userId)
          .where('isDefault', isEqualTo: true)
          .get();

      // Use batch operation to update multiple documents in a single transaction
      final batch = firestore.batch();

      for (var doc in snapshot.docs) {
        if (excludeId != null && doc.id == excludeId) continue;
        batch.update(doc.reference, {'isDefault': false});
      }
      await batch.commit();
    } catch (e) {
      throw Exception('Failed to unset default addresses: $e');
    }
  }

  // Retrieves the current location coordinates from the device using Geolocator service
  Future<Map<String, dynamic>> getCurrentLocation() async {
    try {
      // Check if location services are enabled on the device
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled. Please enable them in settings.');
      }

      // Check the current location permission status
      LocationPermission permission = await Geolocator.checkPermission();

      // Request permission if not already granted
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      // Handle permanently denied permissions
      if (permission == LocationPermission.deniedForever) {
        throw Exception(
          'Location permissions are permanently denied. Please enable them in app settings.'
        );
      }

      // Get the current device position with high accuracy
      Position position = await Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.high,
      );

      String addressName = "Unknown Location";
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          // Construct address string: Locality, SubLocality or Area
          addressName = "${place.subLocality ?? ''} ${place.locality ?? ''}".trim();
          if (addressName.isEmpty) {
            addressName = place.administrativeArea ?? "Unknown Location";
          }
        }
      } catch (e) {
        // Fallback or ignore geocoding error, just return coords
        addressName = "${position.latitude.toStringAsFixed(2)}, ${position.longitude.toStringAsFixed(2)}";
      }

      // Return location data as a map
      return {
        'latitude': position.latitude,
        'longitude': position.longitude,
        'accuracy': position.accuracy,
        'timestamp': position.timestamp.toIso8601String(),
        'addressName': addressName,
      };
    } catch (e) {
      throw Exception('Failed to get current location: $e');
    }
  }
}