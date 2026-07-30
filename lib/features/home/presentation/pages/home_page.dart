import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/home/presentation/pages/widgets/balance_card.dart';
import 'package:flutter_application_1/features/home/presentation/pages/widgets/coins_card.dart';
import 'package:flutter_application_1/features/home/presentation/pages/widgets/greeting_header.dart';
import 'package:flutter_application_1/features/home/presentation/pages/widgets/transaction_tile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/theme_controller.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.dark_mode : Icons.light_mode,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: () {
              ref.read(themeModeProvider.notifier).state =
                  isDark ? ThemeMode.light : ThemeMode.dark;
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
           
              const GreetingHeader (userName: 'Muhammed'),
              const SizedBox(height: 24),

              const BalanceCard(balance: 25450.00),
              const SizedBox(height: 16),

              
              const CoinsCard(coinBalance: 2450),
              const SizedBox(height: 24),

              _buildTransactionsHeader(context),
              const SizedBox(height: 12),

              ..._buildTransactionList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionsHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Recent Transactions',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        Text(
          'View All',
          style: TextStyle(color: Colors.deepPurple.shade300),
        ),
      ],
    );
  }

  
  List<Widget> _buildTransactionList() {
    return [
      const TransactionTile(
        icon: Icons.wallet,
        iconColor: Colors.green,
        title: 'Salary',
        subtitle: 'Today, 09:30 AM',
        amount: '+₹45,000',
        isCredit: true,
      ),
      const TransactionTile(
        icon: Icons.play_arrow,
        iconColor: Colors.black,
        title: 'Netflix',
        subtitle: 'Yesterday, 08:15 PM',
        amount: '-₹649',
        isCredit: false,
      ),
      const TransactionTile(
        icon: Icons.shopping_cart,
        iconColor: Colors.purple,
        title: 'Grocery',
        subtitle: 'Yesterday, 06:20 PM',
        amount: '-₹1,250',
        isCredit: false,
      ),
      const TransactionTile(
        icon: Icons.check_circle,
        iconColor: Colors.green,
        title: 'Cashback Received',
        subtitle: '2 May 2024, 11:45 AM',
        amount: '+₹200',
        isCredit: true,
      ),
    ];
  }
}