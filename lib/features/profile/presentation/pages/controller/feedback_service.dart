import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/features/authentication/datasources/dio_interceptor.dart';
import 'package:flutter_application_1/features/profile/presentation/pages/models/feedback_model.dart';

Future<Feedbackmodel> postfeed(Feedbackmodel feedback) async {
  try {
    final response = await dio.post(
      "/api/v1/support/feedbacks",
      data: feedback.toJson(),
    );
  return Feedbackmodel.fromJson(response.data['data']);
      
  } on DioException catch (e) {
     
       String errorMessage = "Failed to submit feedback.";

    final data = e.response?.data;

    if (data is Map<String, dynamic>) {
      errorMessage =
          data['message']?.toString() ??
          data['error']?.toString() ??
          data['detail']?.toString() ??
          errorMessage;
    } else if (data != null) {
      errorMessage = data.toString();
    }

    if (e.response?.statusCode == 500) {
      errorMessage = "Server error. Please try again later.";
    } else if (e.response?.statusCode == 400) {
      errorMessage = "Invalid feedback. Please check your details.";
    } else if (e.response == null) {
      errorMessage =
          "Unable to connect to the server. Please check your internet connection.";
    }

    throw Exception(errorMessage);
  } catch (e) { 
    debugPrint("FEEDBACK UNKNOWN ERROR: $e");
    throw Exception("Something went wrong. Please try again.");
  }
}
  
