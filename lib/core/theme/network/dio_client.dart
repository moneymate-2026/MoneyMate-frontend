import 'package:dio/dio.dart';
import 'package:flutter_application_1/features/authentication/models/register_request.dart';

final dio = Dio(BaseOptions(baseUrl: "https://api-gateway-dtvx.onrender.com"));

class Authpost {
  Future<String> postauth(String fullName, String phone, String email, String password) async {
    final request = RegisterRequest(
      fullname: fullName,
      phone: phone,
      email: email,
      password: password,
    );

    try {
      final response = await dio.post(
        "/api/v1/auth/register",
        data: request.toJson(),
      );

      return response.data["message"] ?? "Registration successful";
    } catch (e) {
      throw Exception("Registration failed: $e");
    }
  }
}