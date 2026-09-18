import 'package:dio/dio.dart';
import 'package:flutter_application_1/features/authentication/datasources/dio_interceptor.dart';


 //used to send backend email
class OtpController {
  Future<void> sendOtp(String email) async {
    try {
      await dio.post(
        "/api/v1/auth/otp/send",
        data: {
          "email": email,
        },
      );
    }on DioException  catch (e) {
     print("OTP SEND STATUS: ${e.response?.statusCode}");
    print("OTP SEND RESPONSE: ${e.response?.data}");

    final statusCode = e.response?.statusCode;

    if (statusCode == 409) {
      throw Exception(
        "This email is already registered. Please login.",
      );
    } else if (statusCode == 500) {
      throw Exception(
        "Server error. Please try again later.",
      );
    } else if (statusCode == 400) {
      throw Exception(
        "Invalid email address.",
      );
    } else if (e.response == null) {
      throw Exception(
        "Unable to connect to the server. Please check your internet connection.",
      );
    } else {
      throw Exception(
        "Something went wrong. Please try again.",
      );
    }
    }

  }


             //verfying the code recieved and email
  Future<bool> verifyOtp(String email, String code) async {
  try {
    final response = await dio.post(
      "/api/v1/auth/otp/verify",
      data: {
        "email": email,
        "code": code,
      },
    );

    print("STATUS: ${response.statusCode}");
    print("RESPONSE: ${response.data}");

    return true;
  } on DioException catch (e) {
    print("STATUS: ${e.response?.statusCode}");
    print("RESPONSE: ${e.response?.data}");

    final data = e.response?.data;

    if (data is Map<String, dynamic>) {
      throw Exception(
        data['message']?.toString() ?? 'Failed to verify OTP',
      );
    } else {
      throw Exception(
        data?.toString() ?? 'Failed to verify OTP',
      );
    }
  }
}
}