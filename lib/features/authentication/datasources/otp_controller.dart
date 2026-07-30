import 'package:dio/dio.dart';

final dio = Dio(BaseOptions(baseUrl: "https://api-gateway-dtvx.onrender.com"));

class OtpController {
  Future<void> sendOtp(String email) async {
    try {
      await dio.post(
        "/api/v1/auth/otp/send",
        data: {"email": email},
      );
    } catch (e) {
      throw Exception('Failed to send OTP: $e');
    }
  }

  Future<void> verifyOtp(String email, String code) async {
    try {
      await dio.post(
        "/api/v1/auth/otp/verify",
        data: {"email": email, "code": code},
      );
    } catch (e) {
      throw Exception('Failed to verify OTP: $e');
    }
  }
}