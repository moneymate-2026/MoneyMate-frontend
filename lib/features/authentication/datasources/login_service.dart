import 'package:dio/dio.dart';
import 'package:flutter_application_1/features/authentication/datasources/dio_interceptor.dart';
import 'package:flutter_application_1/features/authentication/models/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loginservice {
  Future<bool> loginpost(Loginmodel model) async {
    try {
      final response = await dio.post(
        "/api/v1/auth/login",
        data: model.toJson(),
      );

      print("LOGIN STATUS: ${response.statusCode}");
      print("LOGIN RESPONSE: ${response.data}");

      final prefs = await SharedPreferences.getInstance();

      final accessToken = response.data["access_token"];
      final refreshToken = response.data["refresh_token"];

      if (accessToken != null) {
        await prefs.setString(
          "access_token",
          accessToken.toString(),
        );
      }

      if (refreshToken != null) {
        await prefs.setString(
          "refresh_token",
          refreshToken.toString(),
        );
      }

      return true;
    } on DioException catch (e) {
      print("LOGIN ERROR STATUS: ${e.response?.statusCode}");
      print("LOGIN ERROR RESPONSE: ${e.response?.data}");
      return false;
    } catch (e) {
      print("LOGIN OTHER ERROR: $e");
      return false;
    }
  }
}



class LogoutRemoteDataSource {
  Future<bool> logout() async {
    try {
      final response = await dio.post(
        '/api/v1/auth/logout',
      );

      print("LOGOUT STATUS: ${response.statusCode}");
      print("LOGOUT RESPONSE: ${response.data}");

      return response.statusCode == 200;
    } on DioException catch (e) {
      print("LOGOUT STATUS: ${e.response?.statusCode}");
      print("LOGOUT RESPONSE: ${e.response?.data}");

      return false;
    }
  }
}