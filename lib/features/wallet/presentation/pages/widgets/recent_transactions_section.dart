import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/home/presentation/pages/widgets/transaction_tile.dart';
import 'package:flutter_application_1/features/wallet/presentation/pages/data/repositeries/transaction_getting.dart';

class RecentTransactionsSection extends StatelessWidget {
  const RecentTransactionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Transactions',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
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
                  iconColor: isCredit
                      ? Colors.green
                      : Colors.red,
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
    );
  }
}