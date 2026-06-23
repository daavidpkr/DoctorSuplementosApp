import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class CloudinaryService {
  static const String _cloudName = 'dyopany6o';
  static const String _uploadPreset = 'diagnosticos_preset';

  Future<String?> uploadPdf(File pdfFile) async {
    final uri = Uri.parse(
      'https://api.cloudinary.com/v1_1/$_cloudName/raw/upload',
    );
    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = _uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', pdfFile.path));

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        debugCloudinaryError(response.statusCode, response.body);
        return null;
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final secureUrl = data['secure_url']?.toString();
      if (secureUrl == null || secureUrl.trim().isEmpty) return null;
      return secureUrl.replaceAll(r'\/', '/');
    } catch (error) {
      debugCloudinaryException(error);
      return null;
    }
  }

  void debugCloudinaryError(int statusCode, String body) {
    // ignore: avoid_print
    print('Cloudinary upload error $statusCode: $body');
  }

  void debugCloudinaryException(Object error) {
    // ignore: avoid_print
    print('Cloudinary upload exception: $error');
  }
}
