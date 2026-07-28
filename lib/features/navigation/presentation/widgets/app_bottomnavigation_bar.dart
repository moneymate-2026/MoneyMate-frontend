import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/nav_controller.dart';
// adjust path to where Bkcolors actually lives

class AppBottomNavBar extends ConsumerWidget {
  const AppBottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(navIndexProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CurvedNavigationBar(
      index: selectedIndex,
      backgroundColor: Bkcolors.trasprntcolor,
      color: isDark ? Bkcolors.surfacecolor : Bkcolors.whitecolor,
      buttonBackgroundColor: Bkcolors.primarycolor,
      // stays same in both, it's your brand accent
      animationDuration: const Duration(milliseconds: 400),
      items: [
        Icon(
          Icons.home_rounded,
          color: isDark ? Bkcolors.whitecolor : Bkcolors.surfacecolor,
        ),
        Icon(
          Icons.pie_chart_rounded,
          color: isDark ? Bkcolors.whitecolor : Bkcolors.surfacecolor,
        ),
        Icon(
          Icons.savings_rounded,
          color: isDark ? Bkcolors.whitecolor : Bkcolors.surfacecolor,
        ),
        Icon(
          Icons.account_balance_wallet_rounded,
          color: isDark ? Bkcolors.whitecolor : Bkcolors.surfacecolor,
        ),
        Icon(
          Icons.person_rounded,
          color: isDark ? Bkcolors.whitecolor : Bkcolors.surfacecolor,
        ),
      ],
      onTap: (index) => ref.read(navIndexProvider.notifier).state = index,
    );
  }
}