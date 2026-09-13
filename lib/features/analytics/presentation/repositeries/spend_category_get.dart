
import 'package:flutter_application_1/features/analytics/presentation/Model/category_spend.dart';
import 'package:flutter_application_1/features/analytics/presentation/Model/period_spending.dart';
import 'package:flutter_application_1/features/authentication/datasources/dio_interceptor.dart';

class Analyticsservice {
 Future<List<CategorySpending>> getcategoryspending() async {
  try {
    final response = await dio.get(
      '/api/v1/payment/analytics/spend-by-category',
    );

    print('CATEGORY API: ${response.data}');

    final List data = response.data['data'] ?? [];

    return data
        .map((e) => CategorySpending.fromJson(e))
        .toList();
  } catch (e) {
    print('CATEGORY ERROR: $e');
    return [];
  }
}


  Future<List<PeriodSpending>>getperiodspending()async{
    try{

      final response=await dio.get("/payment/analytics/spend-by-period");
      final List data= response.data['data'] ?? [];
return data.map((e)=>PeriodSpending.fromJson(e)).toList();
    }catch(e){

      return [];
    }

  }



}