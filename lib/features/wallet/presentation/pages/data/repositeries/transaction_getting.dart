  import 'package:flutter_application_1/features/authentication/datasources/dio_interceptor.dart';
  class Gettransinfo {
    
Future<List<Map<String, dynamic>>> getMyTransactions() async {
    try {
      final response = await dio.get(
        '/api/v1/payment/transactions/me',
      );

      final data = response.data['data'];

      if (data == null) {
        return [];
      }

      final transactions = data['transactions'];

      if (transactions == null) {
        return [];
      }

      return List<Map<String, dynamic>>.from(
        transactions.map(
          (transaction) => Map<String, dynamic>.from(transaction),
        ),
      );
    } catch (e) {
      print('Transaction API Error: $e');
      rethrow;
    }
  }
  }

