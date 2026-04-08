import 'dart:convert';
import 'package:http/http.dart' as http;

/// A utility class providing strict validation rules and methods for delivery address forms.
class AddressValidators {
  /// Validates an Indian phone number: exactly 10 digits, starts with 6-9, no spaces or special characters.
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    if (!RegExp(r'^[6-9][0-9]{9}$').hasMatch(value)) {
      return 'Enter a valid 10-digit Indian mobile number';
    }
    return null;
  }

  /// Validates a name: required, minimum 2 characters, only alphabets and spaces.
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters long';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Name can only contain alphabets and spaces';
    }
    return null;
  }

  /// Validates an address string: required, minimum 5 characters, alphanumeric with comma/dash/spaces.
  static String? validateAddress(String? value, {bool isRequired = true}) {
    if (value == null || value.trim().isEmpty) {
      return isRequired ? 'Address is required' : null;
    }
    if (value.trim().length < 5) {
      return 'Address must be at least 5 characters long';
    }
    if (!RegExp(r'^[a-zA-Z0-9\s,\-\.\/#]+$').hasMatch(value)) {
      return 'Address contains invalid special characters';
    }
    return null;
  }

  /// Validates Indian Pincode format: exactly 6 digits, doesn't start with 0.
  static String? validatePincodeFormat(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Pincode is required';
    }
    if (!RegExp(r'^[1-9][0-9]{5}$').hasMatch(value)) {
      return 'Enter a valid 6-digit Indian pincode';
    }
    return null;
  }

  /// Validates City or State generic fields: required, only alphabets/spaces.
  static String? validateCityState(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    if (value.trim().length < 2) {
      return '$fieldName must be at least 2 characters';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return '$fieldName can only contain alphabets and spaces';
    }
    return null;
  }

  /// Asynchronously validates if the provided City and State logically exist within the given Indian Pincode.
  /// Uses api.postalpincode.in to fetch the real post office mappings.
  static Future<String?> validatePincodeCityStateMatch({
    required String pincode,
    required String city,
    required String state,
  }) async {
    try {
      final response = await http.get(Uri.parse('https://api.postalpincode.in/pincode/$pincode'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        if (data.isNotEmpty && data[0]['Status'] == 'Success') {
          final List<dynamic> postOffices = data[0]['PostOffice'];
          bool cityMatch = false;
          bool stateMatch = false;

          final inputCity = city.trim().toLowerCase();
          final inputState = state.trim().toLowerCase();

          for (var po in postOffices) {
            final poName = (po['Name'] ?? '').toString().toLowerCase();
            final poDistrict = (po['District'] ?? '').toString().toLowerCase();
            final poRegion = (po['Region'] ?? '').toString().toLowerCase();
            final poState = (po['State'] ?? '').toString().toLowerCase();

            if (poState.contains(inputState) || inputState.contains(poState)) {
              stateMatch = true;
            }

            if (poName.contains(inputCity) ||
                poDistrict.contains(inputCity) ||
                poRegion.contains(inputCity) ||
                inputCity.contains(poName) ||
                inputCity.contains(poDistrict)) {
              cityMatch = true;
            }

            if (cityMatch && stateMatch) break;
          }

          if (!stateMatch) return 'The entered State does not match the Pincode';
          if (!cityMatch) return 'The entered City/District does not match the Pincode';

          return null; // All good
        } else {
          return 'Invalid Pincode: Not found in Indian postal records';
        }
      } else {
        return null; // API down, allow fallback to bypass to not block users
      }
    } catch (e) {
      return null; // Network error, allow fallback to bypass
    }
  }
}
