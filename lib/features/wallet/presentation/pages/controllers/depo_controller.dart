import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/authentication/datasources/dio_interceptor.dart';
import 'package:flutter_application_1/features/wallet/presentation/pages/data/repositeries/wallet_deposit.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class DepositController {
  late Razorpay _razorpay;
  final VoidCallback onDepositSuccess;
  final void Function(String message) onDepositError;

  DepositController({
    required this.onDepositSuccess,
    required this.onDepositError,
  }) {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handleSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handleError);
  }
   

      //handling the razorpay
  Future<void> startDeposit(int amountInRupees, {required String transactionToken}) async {
    final order = await createdepoorder(amountInRupees, transactionToken: transactionToken);

    var options = {
      'key': order.keyId,
      'amount': (double.parse(order.amount) * 100).toInt(),
      'order_id': order.orderId,
      'name': 'MoneyMate',
      'description': 'Wallet Deposit',
    };
    _razorpay.open(options);
  }

  void _handleSuccess(PaymentSuccessResponse response) async {
    try {
      await dio.post("/api/v1/payment/deposits/confirm", data: {
        "razorpay_order_id": response.orderId,
        "razorpay_payment_id": response.paymentId,
        "razorpay_signature": response.signature,
      });
      onDepositSuccess();
    } catch (e) {
      onDepositError("Confirm failed: $e");
    }
  }

  void _handleError(PaymentFailureResponse response) {
    onDepositError(response.message ?? "Payment failed");
  }

  void dispose() {
    _razorpay.clear();
  }
}