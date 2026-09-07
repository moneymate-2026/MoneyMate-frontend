import 'package:dio/dio.dart';
import 'package:flutter_application_1/features/authentication/datasources/dio_interceptor.dart';
import 'package:flutter_application_1/features/qr_scanner/presentation/pages/models/paymentcat.dart';
import 'package:flutter_application_1/features/qr_scanner/presentation/pages/models/paymentresolve_model.dart';
import 'package:flutter_application_1/features/qr_scanner/presentation/pages/models/transfer_razo_model.dart';

Future<List<PaymentCategoryModel>> getPaymentCategories() async {
  try {
    final response = await dio.get('/api/v1/payment/categories');

    final List data = response.data['data'] ?? [];

    return data.map((json) => PaymentCategoryModel.fromJson(json)).toList();                                                                                                                                                                                                                                                                                                  
  } on DioException catch (e) {
    throw Exception(
      e.response?.data['message'] ?? e.message ?? 'Failed to get categories',
    );
  }
}


Future<void> createPaymentCategory(String name) async {
  try {
    final response = await dio.post(
      '/api/v1/payment/categories',
      data: {
        'name': name,
      },
    );

    if (response.statusCode == 201 &&
        response.data['success'] == true) {
      return;
    }

    throw Exception(
      response.data['message'] ?? 'Failed to create category',
    );
  } on DioException catch (e) {
    throw Exception(
      e.response?.data['message'] ??
          e.message ??
          'Failed to create category',
    );
  }
}
Future<Resolveaccount> resolveaccnt(String handle) async {
  try {
    final response = await dio.get(
      '/api/v1/payment/resolve',
      queryParameters: {
        'handle': handle,
      },
    );

    return Resolveaccount.fromJson(
      response.data['data'],
    );
  } on DioException catch (e) {
    throw Exception(
      e.response?.data['message'] ??
          e.message ??
          'Failed to resolve account',
    );
  }
}
Future<void> createtransfer(Transferrazomodel transfer) async {
  try {
    final response = await dio.post(
      "/api/v1/payment/transfers",
      data: transfer.toJson(),
      options: Options(
        headers: {
          "X-Transaction-Token": transfer.transactionToken,
        },
      ),
    );
  } on DioException catch (e) {
    throw Exception(
      e.response?.data['message'] ??
          e.message ??
          'Payment failed',
    );
  }

  }