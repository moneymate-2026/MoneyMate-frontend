import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
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
      backgroundColor: Colors.transparent,
      color: isDark ? const Color(0xFF1A0B2E) : Colors.white,
      buttonBackgroundColor: const Color(
        0xFF6C4AB6,
      ), // stays same in both, it's your brand accent
      animationDuration: const Duration(milliseconds: 400),
      items: [
        Icon(
          Icons.home_rounded,
          color: isDark ? Colors.white : const Color(0xFF1A0B2E),
        ),
        Icon(
          Icons.pie_chart_rounded,
          color: isDark ? Colors.white : const Color(0xFF1A0B2E),
        ),
        Icon(
          Icons.account_balance_wallet_rounded,
          color: isDark ? Colors.white : const Color(0xFF1A0B2E),
        ),
        Icon(
          Icons.person_rounded,
          color: isDark ? Colors.white : const Color(0xFF1A0B2E),
        ),
      ],
      onTap: (index) => ref.read(navIndexProvider.notifier).state = index,
    );
  }
}
