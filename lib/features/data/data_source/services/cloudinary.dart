import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

/// Uploads an image file to Cloudinary and returns the secure URL of the uploaded asset.
Future<String?> uploadToCloudinary(FilePickerResult? filePickerResult) async {
  try {
    if (filePickerResult == null || filePickerResult.files.isEmpty) {
      return null;
    }

    var file = filePickerResult.files.single;
    var bytes = file.bytes;
    var fileName = file.name;


    
    if (bytes == null) {
      
      if (file.path == null) {
        return null;
      }

      try {
        final fileFromPath = File(file.path!);
        bytes = await fileFromPath.readAsBytes();
      } catch (e) {
        return null;
      }
    } else {
    }

    if (bytes.isEmpty) {
      return null;
    }

    String cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';
    String preset = dotenv.env['PRESET_NAME'] ?? '';


    
    if (cloudName.isEmpty) {
      return null;
    }
    if (preset.isEmpty) {
      return null;
    }

    var uri = Uri.parse(
        "https://api.cloudinary.com/v1_1/$cloudName/image/upload");


    var request = http.MultipartRequest("POST", uri);
    request.fields['upload_preset'] = preset;

    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: fileName,
      ),
    );

    var response = await request.send().timeout(
      const Duration(seconds: 60), 
      onTimeout: () {
        throw TimeoutException('Cloudinary upload timeout');
      },
    );

    var responseBody = await response.stream.bytesToString();


    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(responseBody);
        final secureUrl = data['secure_url'] as String?;

        if (secureUrl != null && secureUrl.isNotEmpty) {
          return secureUrl;
        } else {
          return null;
        }
      } catch (e) {
        return null;
      }
    } else {
      return null;
    }
  } catch (e) {
    return null;
  }
}

class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);

  @override
  String toString() => message;
}