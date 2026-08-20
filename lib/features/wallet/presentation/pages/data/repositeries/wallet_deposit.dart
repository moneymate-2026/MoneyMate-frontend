import 'package:dio/dio.dart';
import 'package:flutter_application_1/features/authentication/datasources/dio_interceptor.dart';
import 'package:flutter_application_1/features/wallet/presentation/pages/models/deposit_model.dart';

Future<Depositordermodel> createdepoorder(
  int amountInRupees, {
  required String transactionToken,
}) async {
  try {
    final response = await dio.post(
      "/api/v1/payment/deposits",
      data: {"amount": amountInRupees},
      options: Options(
        headers: {"X-Transaction-Token": transactionToken},
      ),
    );
    return Depositordermodel.fromJson(response.data);
  } catch (e) {
    rethrow;
  }
}
