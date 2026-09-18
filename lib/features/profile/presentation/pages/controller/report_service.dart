import 'package:dio/dio.dart';
import 'package:flutter_application_1/features/authentication/datasources/dio_interceptor.dart';

Future<void> postReport({
  required String handle,
  required String title,
  required String description,
}) async {
  try {
    await dio.post(
      "/api/v1/support/reports",
      data: {
        "Handle": handle,
        "title": title,
        "description": description,
      },
    );
  } on DioException catch (e) {
    throw Exception(
      e.response?.data['message'] ?? 'Failed to submit report',
    );
  } catch (e) {
    throw Exception('Something went wrong: $e');
  }
}