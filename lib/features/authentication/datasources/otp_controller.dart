import 'package:dio/dio.dart';

final dio = Dio(
  BaseOptions(
    baseUrl: "https://auth-service-z1hg.onrender.com",
  ),
)..interceptors.add(
    LogInterceptor(
      requestBody: true,
      responseBody: true,
      requestHeader: true,
    ),
  );

class OtpController {
  Future<void> sendOtp(String email) async {
    try {
      await dio.post(
        "/auth/otp/send",
        data: {
          "email": email,
        },
      );
    } catch (e) {
      throw Exception('Failed to send OTP: $e');
    }
  }

  Future<bool> verifyOtp(String email, String code) async {
  try {
    final response = await dio.post(
      "/auth/otp/verify",
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

    throw Exception(
      e.response?.data?['message'] ?? 'Failed to verify OTP',
    );
  }
}
}