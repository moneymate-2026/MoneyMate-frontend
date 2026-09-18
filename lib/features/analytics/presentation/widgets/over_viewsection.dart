import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/analytics/presentation/providers/analytics_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Spendingoverview extends ConsumerWidget {
  const Spendingoverview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(spendingCategoryProvider);

    return result.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) => const Text(
        'Unable to load spending overview',
      ),
      data: (categories) {
        if (categories.isEmpty) {
          return const Text('No spending data available');
        }

        final highest = categories.reduce(
          (a, b) => a.totalAmount > b.totalAmount ? a : b,
        );

        final total = categories.fold<double>(
          0,
          (sum, item) => sum + item.totalAmount,
        );

        final averageDailySpend = total / DateTime.now().day;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Spending Overview',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _OverviewCard(
                    title: 'Highest Spending',
                    value: '₹${highest.totalAmount.toStringAsFixed(0)}',
                    subtitle: highest.category,
                    bgColor: const Color(0xFFF3E8FF),
                    valueColor: const Color(0xFF7C3AED),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _OverviewCard(
                    title: 'Average Daily Spend',
                    value: '₹${averageDailySpend.toStringAsFixed(0)}',
                    subtitle: 'This Month',
                    bgColor: const Color(0xFFE7F9EF),
                    valueColor: const Color(0xFF16A34A),
                    trailingIcon: Icons.trending_up,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _OverviewCard extends StatelessWidget {
  const _OverviewCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.bgColor,
    required this.valueColor,
    this.trailingIcon,
  });

  final String title;
  final String value;
  final String subtitle;
  final Color bgColor;
  final Color valueColor;
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: valueColor,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: valueColor,
                  ),
                ),
              ),
              if (trailingIcon != null)
                Icon(
                  trailingIcon,
                  color: valueColor,
                  size: 18,
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}