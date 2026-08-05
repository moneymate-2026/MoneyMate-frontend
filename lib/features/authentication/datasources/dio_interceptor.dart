import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

final dio = Dio(BaseOptions(baseUrl: "https://money-mate.duckdns.org",headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },));

void setupInterceptors() {
  dio.interceptors.add(
    LogInterceptor(requestBody: true, responseBody: true, requestHeader: true),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        try {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('access_token');

          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
        } catch (e) {
          print('Error attaching token: $e');
        }

        return handler.next(options);
      },
    ),
  );
}
