

import 'package:dio/dio.dart';
import 'package:flutter_application_1/features/authentication/datasources/dio_interceptor.dart';
import 'package:flutter_application_1/features/authentication/models/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
      // giving email and password to backend,and saving token with share and  access tkn and also refresh token, and to see the  what happening msee the terminal

class Loginservice {
  Future<bool> loginpost(Loginmodel model) async {
    try {
       print("LOGIN REQUEST V2: ${model.toJson()}");

      final response = await dio.post(
        "/api/v1/auth/login",
        data: model.toJson(),
      );

      print("LOGIN STATUS: ${response.statusCode}");
      print("LOGIN RESPONSE: ${response.data}");

      if (response.statusCode != 200) {
        return false;
      }
final prefs = await SharedPreferences.getInstance();

final data = response.data["data"];

final accessToken = data?["AccessToken"];
final refreshToken = data?["RefreshToken"];
final userName = data?["User"]?["FullName"]; 

print("ACCESS TOKEN: $accessToken");
print("REFRESH TOKEN: $refreshToken");
      print("USER NAME: $userName");  

if (accessToken == null) {
  print("Login failed: access token is missing");
  return false;
}

await prefs.setString("access_token", accessToken.toString());

if (refreshToken != null) {
  await prefs.setString("refresh_token", refreshToken.toString());
}
if (userName != null) {
  await prefs.setString(
    "user_name",
    userName.toString(),
  );
}

final userEmail = data?["User"]?["Email"];

if (userEmail != null) {
  await prefs.setString(
    "user_email",
    userEmail.toString(),
  );
}
 
return true;
     
} on  DioException catch (e) {
      print("LOGIN ERROR STATUS: ${e.response?.statusCode}");
      print("LOGIN ERROR RESPONSE: ${e.response?.data}");
      print("LOGIN ERROR MESSAGE: ${e.message}");

      return false;
    } catch (e) {
      print("LOGIN OTHER ERROR: $e");
      return false;
    }
  }
}



  //logouting acnts,callrefkon, then reming the tokens

  class Logoutservice {
    Future<bool> logoutpost() async {
      try {
        final prefs = await SharedPreferences.getInstance();
        final refreshToken = prefs.getString("refresh_token");

        print("LOGOUT REQUEST TOKEN: $refreshToken");

        final response = await dio.post(
          "/api/v1/auth/logout",
          data: {
            "refresh_token": refreshToken,
            "all_devices": true,
          },
        );

        print("LOGOUT STATUS: ${response.statusCode}");
        print("LOGOUT RESPONSE: ${response.data}");

        await prefs.remove("access_token");
        await prefs.remove("refresh_token");
    
        return true;
      } on DioException catch (e) {
        print("LOGOUT ERROR STATUS: ${e.response?.statusCode}");
        print("LOGOUT ERROR RESPONSE: ${e.response?.data}");

        final prefs = await SharedPreferences.getInstance();
        await prefs.remove("access_token");
        await prefs.remove("refresh_token");
        await prefs.remove("user_name");
  await prefs.remove("user_email");

        return false;
      } catch (e) {
        print("LOGOUT OTHER ERROR: $e");
        return false;
      }
    }
  }