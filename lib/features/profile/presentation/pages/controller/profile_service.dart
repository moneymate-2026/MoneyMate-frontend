

  import 'package:dio/dio.dart';
import 'package:flutter_application_1/features/authentication/datasources/dio_interceptor.dart';
import 'package:flutter_application_1/features/profile/presentation/pages/models/presignmodel.dart';

Future<PresignResponse> getPresignedUrl(String contentType) async {
    try {
      final response = await dio.post(
        '/api/v1/profile/presign',
        data: {'content_type': contentType},
      );

      return PresignResponse.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception('Failed to get upload URL: ${e.message}');
    }
  }

  Future<void> uploadToS3({
    required String uploadUrl,
    required List<int> bytes,
    required String contentType,
  }) async {
    try {
      final plainDio = Dio();
      await plainDio.put(
        uploadUrl,
        data: bytes,
        options: Options(headers: {'Content-Type': contentType}),
      );
    } on DioException catch (e) {
      throw Exception('Image upload failed: ${e.message}');
    }
  }

  Future<void> confirmProfilePicture(String publicUrl) async {
    try {
      await dio.post(
        '/api/v1/profile',
        data: {'url': publicUrl},
      );
    } on DioException catch (e) {
      throw Exception('Failed to save profile picture: ${e.message}');
    }
  }
    Future<Map<String, dynamic>> getprofile() async {
  try {
    final response = await dio.get('/api/v1/profile/me');

    final data = response.data['data'];

    if (data is Map<String, dynamic>) {
      return data;
    }

    throw Exception('Invalid profile response format');
  } on DioException catch (e) {
    throw Exception('Failed to get profile: ${e.message}');
  }
}
