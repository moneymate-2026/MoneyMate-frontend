import 'package:dio/dio.dart';
import 'package:flutter_application_1/features/authentication/models/verify_otp.dart';
import '../models/send_otp_request.dart';


final dio = Dio(BaseOptions(baseUrl: "https://api-gateway-dtvx.onrender.com"));

class OtpRemoteDataSource {
  Future<String> sendOtp(Sendotprequest request) async {
    try {
      final response = await dio.post(
        '/api/v1/auth/otp/send',
        data: request.toJson(),
      );

      return response.data['message'] ?? 'OTP sent successfully';
    } catch (e) {
      throw Exception('Failed to send OTP: $e');
    }
  }

  Future<String> verifyOtp(Verifyotprequest request) async {
    try {
      final response = await dio.post(
        '/api/v1/auth/otp/verify',
        data: request.toJson(),
      );

      return response.data['message'] ?? 'OTP verified successfully';
    } catch (e) {
      throw Exception('Failed to verify OTP: $e');
    }
  }
}