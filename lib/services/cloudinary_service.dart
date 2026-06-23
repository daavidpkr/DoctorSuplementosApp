import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

const String _cloudinaryCloudName = 'dyopany6o';
const String _cloudinaryUploadPreset = 'diagnosticos_preset';
const Duration _cloudinaryUploadTimeout = Duration(seconds: 45);

class CloudinaryService {
  Future<String?> uploadPdf(File pdfFile) async {
    return compute(_uploadPdfToCloudinary, pdfFile.path);
  }
}

Future<String?> _uploadPdfToCloudinary(String pdfPath) async {
  final client = http.Client();
  try {
    final uri = Uri.parse(
      'https://api.cloudinary.com/v1_1/$_cloudinaryCloudName/raw/upload',
    );
    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = _cloudinaryUploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', pdfPath));

    final streamedResponse = await client
        .send(request)
        .timeout(_cloudinaryUploadTimeout, onTimeout: () {
      client.close();
      throw TimeoutException(
        'Cloudinary upload timed out',
        _cloudinaryUploadTimeout,
      );
    });

    final response = await http.Response.fromStream(streamedResponse)
        .timeout(_cloudinaryUploadTimeout, onTimeout: () {
      client.close();
      throw TimeoutException(
        'Cloudinary response timed out',
        _cloudinaryUploadTimeout,
      );
    });

    if (response.statusCode < 200 || response.statusCode >= 300) {
      _debugCloudinaryError(response.statusCode, response.body);
      return null;
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final secureUrl = data['secure_url']?.toString();
    if (secureUrl == null || secureUrl.trim().isEmpty) return null;
    return secureUrl.replaceAll(r'\/', '/');
  } on TimeoutException catch (error) {
    _debugCloudinaryException(error);
    return null;
  } on SocketException catch (error) {
    _debugCloudinaryException(error);
    return null;
  } on FormatException catch (error) {
    _debugCloudinaryException(error);
    return null;
  } catch (error) {
    _debugCloudinaryException(error);
    return null;
  } finally {
    client.close();
  }
}

void _debugCloudinaryError(int statusCode, String body) {
  // ignore: avoid_print
  print('Cloudinary upload error $statusCode: $body');
}

void _debugCloudinaryException(Object error) {
  // ignore: avoid_print
  print('Cloudinary upload exception: $error');
}
