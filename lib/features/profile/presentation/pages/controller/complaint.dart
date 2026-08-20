import 'package:dio/dio.dart';
import 'package:flutter_application_1/features/authentication/datasources/dio_interceptor.dart';
import 'package:flutter_application_1/features/profile/presentation/pages/models/complaint_model.dart';



//POSTING THE COMPLAINTS
Future<Complaintmodel> postComplaint({
  required String title,
  required String description,
}) async {
  try {
    final response = await dio.post(
      "/api/v1/support/complaints",
      data: {
        "title": title,
        "description": description,
      },
    );

    return Complaintmodel.fromJson(response.data);
  } on DioException catch (e) {
    throw Exception(e.response?.data['message'] ?? 'Failed to submit complaint');
  } catch (e) {
    throw Exception('Something went wrong: $e');
  }
}