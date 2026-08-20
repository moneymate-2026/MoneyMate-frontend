import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
       //using headers for details sending
final dio = Dio(BaseOptions(baseUrl: "https://money-mate.duckdns.org",headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
        
    },));
        


        // to idenitfy the request,response,reqheader

void setupInterceptors() {
  dio.interceptors.add(
    LogInterceptor(requestBody: true, responseBody: true, requestHeader: true),
  );
              
              //dio  handling, and calling sharepereferences and geting the accesstoken,and also iclude headers authorization,with bearer token
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        try {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('access_token');
            print('INTERCEPTOR ACCESS TOKEN: $token'); // 

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
