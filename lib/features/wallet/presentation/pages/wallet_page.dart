import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/wallet/presentation/pages/widgets/wallet_header.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/theme/theme_controller.dart';
import 'package:flutter_application_1/features/home/presentation/pages/widgets/balance_card.dart';
import 'package:flutter_application_1/features/wallet/presentation/pages/widgets/recent_transactions_section.dart';

class WalletPage extends ConsumerWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WalletHeader(isDark: isDark),
              const SizedBox(height: 20),
       
              const BalanceCard(balance: 25450.00),
              const SizedBox(height: 28),
              const RecentTransactionsSection(),
            ],
          ),
        ),
      ),
    );
  }
}

