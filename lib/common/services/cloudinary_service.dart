// uploading files to cloudinary
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import "package:http/http.dart" as http;
import 'package:permission_handler/permission_handler.dart';

Future<Map<String, String>?> uploadToCloudinary(File file, String mediaType) async {
  try {
    String cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME']!;


    String resourceType = 'raw';
    if (mediaType == 'image') {
      resourceType = 'image';
    } else if (mediaType == 'video') {
      resourceType = 'video';
    }

    // Create upload request
    var uri = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/$resourceType/upload');
    var request = http.MultipartRequest('POST', uri);

    var fileByte = await file.readAsBytes();
    var multipartFile = http.MultipartFile.fromBytes(
      'file',
      fileByte,
      filename: file.path.split('/').last,
    );

    request.files.add(multipartFile);
    request.fields['upload_preset'] = "ml_default";

    //send the request
    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(responseBody);
      return {
        'url': jsonResponse['secure_url'],
        'public_id': jsonResponse['public_id'],
        'type': mediaType,
      };
    }
  } catch (e) {
    print("Error uploading file: $e");
    return null;
  }
  return null;
}

// delete specific file from cloudinary
Future<bool> deleteFromCloudinary(String publicId) async {
  // Cloudinary details
  String cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'] ??
      ''; // Replace with your Cloudinary cloud name
  String apiKey = dotenv.env['CLOUDINARY_API_KEY'] ?? '';
  String apiSecret = dotenv.env['CLOUDINARY_SECRET_KEY'] ?? '';

  // Generate the timestamp
  int timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

  // Prepare the string for signature generation
  String toSign = 'public_id=$publicId&timestamp=$timestamp$apiSecret';

  // Generate the signature using SHA1
  var bytes = utf8.encode(toSign);
  var digest = sha1.convert(bytes);
  String signature = digest.toString();
  // Prepare the request URL
  var uri =
  Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/raw/destroy/');

  // Create the request
  var response = await http.post(
    uri,
    body: {
      'public_id': publicId,
      'timestamp': timestamp.toString(),
      'api_key': apiKey,
      'signature': signature,
    },
  );

  if (response.statusCode == 200) {
    var responseBody = jsonDecode(response.body);
    print(responseBody);
    if (responseBody['result'] == 'ok') {
      print("File deleted successfully.");
      return true;
    } else {
      print("Failed to delete the file.");
      return false;
    }
  } else {
    print(
        "Failed to delete the file, status: ${response.statusCode} : ${response.reasonPhrase}");
    return false;
  }
}

// download the user file inside the download folder
Future<bool> downloadFileFromCloudinary(String url, String fileName) async {
  try {
    // Request storage permission
    var status = await Permission.storage.request();
    var manageStatus = await Permission.manageExternalStorage.request();
    if (status == PermissionStatus.granted &&
        manageStatus == PermissionStatus.granted) {
      // The user has granted both permissions, so proceed
      print("Storage permissions granted");
    } else {
      // The user has permanently denied one or both permissions, so open the settings
      await openAppSettings();
    }

    // Get the Downloads directory
    Directory? downloadsDir = Directory('/storage/emulated/0/Download');
    if (!downloadsDir.existsSync()) {
      print("Downloads directory not found");
      return false;
    }

    // Create the file path
    String filePath = '${downloadsDir.path}/$fileName';

    // Make the HTTP GET request
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // Write file to Downloads folder
      File file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      print("File downloaded successfully! Saved at: $filePath");
      return true;
    } else {
      print("Failed to download file. Status code: ${response.statusCode}");
      return false;
    }
  } catch (e) {
    print("Error downloading file: $e");
    return false;
  }
}