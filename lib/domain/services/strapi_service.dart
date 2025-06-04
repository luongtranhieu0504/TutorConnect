import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:tutorconnect/data/manager/account.dart'; // Import the http_parser package

class StrapiService {
  String baseUrl = 'https://tutorconnectbackend.onrender.com';

  Future<List<dynamic>> getMediaFiles() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/upload/files'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData;
      } else {
        throw Exception('Failed to load media files');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<dynamic> uploadMediaFile(File file) async {
    final token = await Account.instance.getToken();

    final uri = Uri.parse('$baseUrl/api/upload');

    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token';

    final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
    final mimeParts = mimeType.split('/');

    final stream = http.ByteStream(file.openRead());
    final length = await file.length();

    final multipartFile = http.MultipartFile(
      'files',
      stream,
      length,
      filename: file.path.split('/').last,
      contentType: MediaType(mimeParts[0], mimeParts[1]),
    );

    request.files.add(multipartFile);
    var response = await request.send();
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response.stream.bytesToString();
    } else {
      throw Exception('Failed to upload media file');
    }
  }
}