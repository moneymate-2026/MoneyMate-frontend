
import 'package:flutter_application_1/features/authentication/datasources/dio_interceptor.dart';
 import 'package:flutter_application_1/features/authentication/models/verify_otp.dart';
 import '../models/send_otp_request.dart';



class OtpRemoteDataSource {

   Future<String> sendOtp(Sendotprequest request) async {
   try {
      final response = await dio.post(
        '/api/v1/auth/otp/send',
        data: request.toJson(),
      );
      return response.data.toString();
     } catch (e) {
       throw Exception('Failed to send OTP: $e');
     }
   }

 Future<bool> verifyOtp(Verifyotprequest request) async {
   try {
      final response = await dio.post(
        '/api/v1/auth/otp/verify',
        data: request.toJson(),
      );

      print("RESPONSE: ${response.data}");
      return true; 
    } catch (e) {
      throw Exception('Failed to verify OTP: $e');
    }
  }
 }