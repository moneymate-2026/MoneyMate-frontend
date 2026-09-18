import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/analytics/presentation/providers/analytics_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class SpendingBarChart extends ConsumerWidget {
  const SpendingBarChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(periodspendingProvider);

    return result.when(
      loading: () => const SizedBox(
        height: 130,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Text('Error: $e'),
      data: (items) {
        if (items.isEmpty) {
          return const Text('No period data');
        }

        final maxAmount = items
            .map((e) => e.totalAmount)
            .reduce((a, b) => a > b ? a : b);

        return SizedBox(
          height: 130,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: items.map((item) {
              final height = maxAmount == 0
                  ? 0.0
                  : (item.totalAmount / maxAmount) * 100;

              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 24,
                    height: height,
                    decoration: BoxDecoration(
                      color: const Color(0xFF7C3AED),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.period.substring(5),
                    style: const TextStyle(fontSize: 11),
                  ),
                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }
}