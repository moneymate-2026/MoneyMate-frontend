import 'package:flutter_application_1/features/analytics/presentation/Model/period_spending.dart';
import 'package:flutter_application_1/features/analytics/presentation/repositeries/spend_category_get.dart';
import 'package:flutter_application_1/features/analytics/presentation/Model/category_spend.dart';
import 'package:flutter_application_1/features/wallet/presentation/pages/data/repositeries/transaction_getting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final analyticsServiceProvider = Provider(
  (ref) => Analyticsservice(),
);

final spendingCategoryProvider =
    FutureProvider.autoDispose<List<CategorySpending>>((ref) {
  return ref
      .watch(analyticsServiceProvider)
      .getcategoryspending();
});

 final periodspendingProvider = FutureProvider.autoDispose<List<PeriodSpending>>((ref) async {

  return  ref.watch(analyticsServiceProvider).getperiodspending();
 });



final transactionsProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) {
  return Gettransinfo().getMyTransactions();
});