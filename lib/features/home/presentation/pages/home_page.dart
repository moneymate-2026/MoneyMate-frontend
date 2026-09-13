
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/analytics/presentation/providers/analytics_providers.dart';
import 'package:flutter_application_1/features/home/presentation/pages/widgets/balance_card.dart';
import 'package:flutter_application_1/features/home/presentation/pages/widgets/greeting_header.dart';
import 'package:flutter_application_1/features/home/presentation/pages/widgets/transaction_tile.dart';
import 'package:flutter_application_1/features/wallet/presentation/pages/data/repositeries/transaction_getting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/theme_controller.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(transactionsProvider);
    ref.watch(themeModeProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const GreetingHeader(),
              const SizedBox(height: 24),
              const BalanceCard(balance: 0),
              const SizedBox(height: 24),
              _buildTransactionsHeader(context),
              const SizedBox(height: 12),

              FutureBuilder<List<Map<String, dynamic>>>(
                future: Gettransinfo().getMyTransactions(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return const Text('Failed to load transactions');
                  }

                  final transactions = snapshot.data ?? [];

                  if (transactions.isEmpty) {
                    return const Text('No transactions yet');
                  }

                  return Column(
                    children: transactions.map((transaction) {
                      final isCredit =
                          transaction['direction'] == 'credit';

                      return TransactionTile(
                        icon: isCredit
                            ? Icons.arrow_downward
                            : Icons.arrow_upward,
                        iconColor:
                            isCredit ? Colors.green : Colors.red,
                        title: transaction['description'] ?? 'Transaction',
                        subtitle: transaction['category']?.toString().isEmpty == true
                            ? transaction['created_at'] ?? ''
                            : transaction['category'] ?? '',
                        amount:
                            '${isCredit ? '+' : '-'}₹${transaction['amount'] ?? '0'}',
                        isCredit: isCredit,
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionsHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Recent Transactions',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        Text(
          'View All',
          style: TextStyle(color: Colors.deepPurple.shade300),
        ),
      ],
    );
  }
}

