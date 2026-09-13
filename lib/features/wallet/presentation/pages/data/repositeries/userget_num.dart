

import 'package:dio/dio.dart';
import 'package:flutter_application_1/features/authentication/datasources/dio_interceptor.dart';

Future<Map<String,dynamic>>lookupuser(String phone)async{

  try{
    final  response=await dio.get("/api/v1/users/lookup",queryParameters:{
      "phone":phone
    });
    final data = response.data['data'];

    if (data is Map<String, dynamic>) {
      return data;
    }

    throw Exception('Invalid user response');
  } on DioException catch (e) {
    throw Exception(
      e.response?.data?['message'] ?? 'Failed to find user',
    );
  }
}
 