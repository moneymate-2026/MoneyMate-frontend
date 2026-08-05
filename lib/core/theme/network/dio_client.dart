import 'package:dio/dio.dart';
import 'package:flutter_application_1/features/authentication/datasources/dio_interceptor.dart';

import 'package:flutter_application_1/features/authentication/models/register_request.dart';

class Authpost {
  Future<String> postauth(
  String fullName,
  String phone,
  String email,
  String password,
) async {
  final request = RegisterRequest(
    fullname: fullName,
    phone: phone,
    email: email,
    password: password,
  );

  try {
    print("REGISTER DATA: ${request.toJson()}");

    final response = await dio.post(
      "/api/v1/auth/register",
      data: request.toJson(),
    );

    print("REGISTER STATUS: ${response.statusCode}");
    print("REGISTER RESPONSE: ${response.data}");

    return response.data.toString();
  } on DioException catch (e) {
    print("REGISTER STATUS: ${e.response?.statusCode}");
    print("REGISTER RESPONSE: ${e.response?.data}");

    throw Exception(e.response?.data.toString() ?? "Registration failed");
  }
}
}