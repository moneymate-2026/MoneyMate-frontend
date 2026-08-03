 import 'package:dio/dio.dart';
 import 'package:flutter_application_1/features/authentication/models/verify_otp.dart';
 import '../models/send_otp_request.dart';


 final dio = Dio(BaseOptions(baseUrl: "https://auth-service-z1hg.onrender.com"));

class OtpRemoteDataSource {
   Future<String> sendOtp(Sendotprequest request) async {
     try {
      final response = await dio.post(
         '/auth/otp/send',
         data: request.toJson(),
       );

      return response.data['message'] ?? 'OTP sent successfully';
     } catch (e) {
       throw Exception('Failed to send OTP: $e');
     }
   }

  Future<bool> verifyOtp(Verifyotprequest request) async {
   try {
      final response = await dio.post(
        '/auth/otp/verify',
        data: request.toJson(),
      );

      return response.data['message'] ?? 'OTP verified successfully';
    } catch (e) {
      throw Exception('Failed to verify OTP: $e');
    }
  }
 }