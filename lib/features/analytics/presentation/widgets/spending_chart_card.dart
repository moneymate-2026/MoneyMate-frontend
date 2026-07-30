import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/colors.dart';
import 'package:flutter_application_1/core/theme/theme_controller.dart';
import 'package:flutter_application_1/features/analytics/presentation/widgets/period_bill.dart';
import 'package:flutter_application_1/features/analytics/presentation/widgets/spending_bar_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class SpendingSummaryCard extends ConsumerWidget {
  const SpendingSummaryCard({super.key});

  static const _totalAmount = '₹25,450.00';
  static const _comparisonLabel = 'vs April 2024';
  static const _percentChange = '↓ 12.5%';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    final cardColor = isDark ? Bkcolors.surfacecolor : Bkcolors.lightbordercolor;
    final textColor = isDark ?Bkcolors.lightbordercolor: Bkcolors.darkcardcolor;
    final mutedColor = isDark ? Bkcolors.logocolor[400] : Colors.grey;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text('Total Spending', style: TextStyle(color: mutedColor)),
                  const SizedBox(width: 4),
                  Icon(Icons.visibility_outlined, size: 16, color: mutedColor),
                ],
              ),
              PeriodPill(isDark: isDark),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _totalAmount,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textColor),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(_comparisonLabel, style: TextStyle(color: mutedColor, fontSize: 13)),
              const SizedBox(width: 8),
              const Text(
                _percentChange,
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const SpendingBarChart(),
        ],
      ),
    );
  }
}

