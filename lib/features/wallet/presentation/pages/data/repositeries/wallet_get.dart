import 'package:dio/dio.dart';
import 'package:flutter_application_1/features/authentication/datasources/dio_interceptor.dart';
import 'package:flutter_application_1/features/wallet/presentation/pages/models/wallet_model.dart';

Future<Walletmodels> getWallet({required String transactionToken}) async {
  try {
    final response = await dio.get(
      "/api/v1/payment/wallets/me",
      options: Options(
        headers: {"X-Transaction-Token": transactionToken},
      ),
    );
    return Walletmodels.fromJson(response.data);
  } catch (e) {
    rethrow;
  }
}