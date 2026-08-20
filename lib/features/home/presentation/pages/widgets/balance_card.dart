import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/wallet/presentation/pages/addmoney_page.dart';
import 'package:flutter_application_1/features/wallet/presentation/pages/balancedetails_page.dart';
import 'package:flutter_application_1/features/wallet/presentation/pages/sentmoney_page.dart';
import 'package:flutter_application_1/features/wallet/presentation/pages/transaction_page.dart';

class BalanceCard extends StatelessWidget {
  final double balance;

  const BalanceCard({super.key, required this.balance});

  String get _maskedBalance {
    final formatted = balance.toStringAsFixed(2);
    return '•' * formatted.length;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Balance',
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.color?.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '₹$_maskedBalance',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              const SizedBox(height: 8),

              
              TextButton.icon(
                onPressed: () async {
                  final token = await Navigator.push<String>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TransactionPinPage(),
                    ),
                  );
                  if (token == null) return;

                  if (!context.mounted) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          BalanceDetailPage(transactionToken: token),
                    ),
                  );
                },
                icon: const Icon(Icons.visibility_outlined, size: 16),
                label: const Text(
                  'View Balance',
                  style: TextStyle(fontSize: 13),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  alignment: Alignment.centerLeft,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Flexible(
                    child: _buildActionButton(
                      icon: Icons.add_circle_outline,
                      label: 'Add Money',
                      isPrimary: true,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddMoneyPage(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: _buildActionButton(
                      icon: Icons.north_east,
                      label: 'Sent',
                      isPrimary: false,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SendMoneyPage(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: -15,
            right: -15,
            child: Image.asset(
              "assets/balancelogo.png",
              width: 150,
              height: 150,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required bool isPrimary,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isPrimary ? Colors.deepPurple : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isPrimary ? Colors.white : Colors.black87,
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  color: isPrimary ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
