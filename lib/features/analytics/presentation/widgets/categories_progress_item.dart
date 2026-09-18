import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/analytics/presentation/providers/analytics_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class CategoryListSection extends ConsumerWidget {
  const CategoryListSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final result = ref.watch(spendingCategoryProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Spending by Category',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        result.when(
          loading: () => const CircularProgressIndicator(),
          error: (e, _) => Text('Error: $e'),
          data: (categories) {
            final total = categories.fold<double>(
              0,
              (sum, item) => sum + item.totalAmount,
            );

            if (categories.isEmpty) {
              return const Text('No spending data');
            }

            return Column(
              children: categories.map((item) {
                final percent = total == 0
                    ? 0.0
                    : item.totalAmount / total;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _CategoryTile(
                    title: item.category,
                    amount: '₹${item.totalAmount.toStringAsFixed(2)}',
                    percent: percent,
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.title,
    required this.amount,
    required this.percent,
  });

  final String title;
  final String amount;
  final double percent;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            Text(
              '${(percent * 100).toStringAsFixed(1)}%  $amount',
            ),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(value: percent),
      ],
    );
  }
}