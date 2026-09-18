    import 'package:dio/dio.dart';
    import 'package:flutter_application_1/features/authentication/datasources/dio_interceptor.dart';

    import 'package:flutter_application_1/features/authentication/models/register_request.dart';
    import 'package:shared_preferences/shared_preferences.dart';

    //adding models to call  the email and code only to verify

    class Authpost {
      Future<String> postauth(
      String fullName,
      String phone,
      String email,
      String password,
      String pin,
    ) async {
      final request = RegisterRequest(
        fullname: fullName,
        phone: phone,
        email: email,
        password: password,
        pin: pin
      );

      try {
        print("REGISTER DATA: ${request.toJson()}");

        final response = await dio.post(
          "/api/v1/auth/register",
          data: request.toJson(),
        );

        print("REGISTER STATUS: ${response.statusCode}");
        print("REGISTER RESPONSE: ${response.data}");


        // Save the name locally right after successful register


          
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("user_name", fullName);
    await prefs.setString("user_email", email);

        return response.data.toString();
      } on DioException catch (e) {
        print("REGISTER STATUS: ${e.response?.statusCode}");
        print("REGISTER RESPONSE: ${e.response?.data}");

       String errorMessage = "Failed to send OTP. Please try again.";

  if (e.response?.statusCode == 409) {
    errorMessage = "This account is already registered. Please login.";
  } else if (e.response?.statusCode == 400) {
    errorMessage = "Invalid email address.";
  } else if (e.response?.statusCode == 500) {
    errorMessage = "Server error. Please try again later.";
  }

  throw Exception(errorMessage);
}
     
      }
    }
      
  