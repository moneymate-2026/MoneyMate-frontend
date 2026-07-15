import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/navigation/presentation/widgets/app_bottomnavigation_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/nav_controller.dart';

import '../../../home/presentation/pages/home_page.dart';
import '../../../analytics/presentation/pages/analytics_page.dart';
import '../../../wallet/presentation/pages/wallet_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';

class Bottomnav_page extends ConsumerWidget {
  const Bottomnav_page({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(navIndexProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final pages = const [
      HomePage(),
      AnalyticsPage(),
      WalletPage(),
      ProfilePage(),
    ];

    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [const Color(0xFF0D0014), const Color(0xFF1A0B2E)]
                : [const Color(0xFFF5F3FA), const Color(0xFFEDE7F6)],
          ),
        ),
        child: IndexedStack(
          index: selectedIndex,
          children: pages,
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(),
    );
  }
}