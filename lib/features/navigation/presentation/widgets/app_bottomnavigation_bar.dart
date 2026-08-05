import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/nav_controller.dart';

class AppBottomNavBar extends ConsumerWidget {
  const AppBottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(navIndexProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CurvedNavigationBar(
      index: selectedIndex,

      // Background behind the curved navbar
      backgroundColor: Bkcolors.trasprntcolor,

      // Navbar background
      color: isDark
          ? Bkcolors.surfacecolor
          : Bkcolors.whitecolor,

      // 🔵 Raised CENTER scanner button
      buttonBackgroundColor: Bkcolors.primarycolor,

      // Animation
      animationDuration: const Duration(milliseconds: 400),

      // Navbar icons
      items: [
        // 0 - HOME
    Icon(
          Icons.home_rounded,
          color: isDark
              ? Bkcolors.whitecolor
              : Bkcolors.surfacecolor,
        ),

        // 1 - ANALYTICS
        Icon(
          Icons.bar_chart_rounded,
          color: isDark
              ? Bkcolors.whitecolor
              : Bkcolors.surfacecolor,
              size: 36,
        ),

        // 2 - SCANNER ⭐ CENTER
         Icon(
          Icons.qr_code_scanner_rounded,
           color: isDark
              ? Bkcolors.whitecolor
              : Bkcolors.surfacecolor,
              size: 36,
        ),

        // 3 - WALLET
        Icon(
          Icons.account_balance_wallet_rounded,
          color: isDark
              ? Bkcolors.whitecolor
              : Bkcolors.surfacecolor,
        ),

        // 4 - PROFILE
        Icon(
          Icons.savings_rounded,
          color: isDark
              ? Bkcolors.whitecolor
              : Bkcolors.surfacecolor,
        ),
      ],

      onTap: (index) {
        ref.read(navIndexProvider.notifier).state = index;
      },
    );
  }
}