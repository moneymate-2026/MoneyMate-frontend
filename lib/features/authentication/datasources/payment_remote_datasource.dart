import 'package:dio/dio.dart';


import 'package:flutter_application_1/features/authentication/datasources/dio_interceptor.dart';
import 'package:uuid/uuid.dart';

  

 //deposit with veriying the trransacation id;
Future<void> submitDeposit({
  required double amount,
  required String transactionToken,
}) async {
  try {
    await dio.post(
      "/api/v1/payment/deposits",
      data: {
        "amount": amount,
        "idempotency_key": const   Uuid().v4(),
      },
      options: Options(
        headers: {"X-Transaction-Token": transactionToken},
      ),
    );
  } on DioException catch (e) {
    throw Exception(e.response?.data['message'] ?? 'Deposit failed');
  } catch (e) {
    throw Exception('Something went wrong: $e');
  }
}

/// POST withdrawal — access_token + transaction_token rണ്ടum venam
Future<void> submitWithdrawal({
  required double amount,
  required String transactionToken,
}) async {
  try {
    await dio.post(
      "/api/v1/payment/withdrawals",
      data: {
        "amount": amount,
        "idempotency_key": const Uuid().v4(),
      },
      options: Options(
        headers: {"X-Transaction-Token": transactionToken},
      ),
    );
  } on DioException catch (e) {
    throw Exception(e.response?.data['message'] ?? 'Withdrawal failed');
  } catch (e) {
    throw Exception('Something went wrong: $e');
  }
}