import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/theme_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class TransferCard extends ConsumerWidget {
  const TransferCard({super.key});

  static const _availableAmount = '₹2,450.00';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    final cardBg = isDark ? const Color(0xFF241A33) : const Color(0xFFEDE9FE);
    final innerBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final chipBg = isDark ? const Color(0xFF2C2242) : const Color(0xFFF0EEFC);
    final textColor = isDark ? Colors.white : Colors.black;
    final mutedColor = isDark ? Colors.grey[400] : Colors.grey;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Move to Personal Account',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: textColor)),
          const SizedBox(height: 4),
          Text(
            'Transfer money from your savings to your personal wallet',
            style: TextStyle(color: mutedColor, fontSize: 13),
          ),
          const SizedBox(height: 16),
          _buildSummaryBox(innerBg, chipBg, textColor, mutedColor),
          const SizedBox(height: 20),
          Text('AMOUNT',
              style: TextStyle(fontSize: 12, color: mutedColor, letterSpacing: 0.5)),
          const SizedBox(height: 8),
          _buildAmountField(innerBg, chipBg, textColor, mutedColor),
          const SizedBox(height: 20),
          _buildTransferButton(),
          const SizedBox(height: 16),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.shield_outlined, size: 14, color: mutedColor),
                const SizedBox(width: 6),
                Text('Your money is safe and secure',
                    style: TextStyle(color: mutedColor, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryBox(Color innerBg, Color chipBg, Color textColor, Color? mutedColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: innerBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _summaryRow(
            chipBg: chipBg,
            textColor: textColor,
            mutedColor: mutedColor,
            label: 'AVAILABLE TO TRANSFER',
            value: _availableAmount,
            valueColor: const Color(0xFF7C3AED),
          ),
          Divider(height: 24, color: mutedColor?.withOpacity(0.2)),
          _summaryRow(
            chipBg: chipBg,
            textColor: textColor,
            mutedColor: mutedColor,
            label: 'TO',
            value: 'Personal Wallet',
          ),
        ],
      ),
    );
  }

  Widget _summaryRow({
    required Color chipBg,
    required Color textColor,
    required Color? mutedColor,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: chipBg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.account_balance_wallet_outlined, size: 18, color: mutedColor),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 11, color: mutedColor)),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: valueColor ?? textColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAmountField(Color innerBg, Color chipBg, Color textColor, Color? mutedColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: innerBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Text('₹', style: TextStyle(fontSize: 16, color: mutedColor)),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
            
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                hintText: 'Enter amount',
                hintStyle: TextStyle(color: mutedColor),
                border: InputBorder.none,
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: chipBg,
              borderRadius: BorderRadius.circular(10),
            ),
          
            child: const Text('All',
                style: TextStyle(color: Color(0xFF7C3AED), fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildTransferButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
   
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6D28D9),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Transfer Now',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward, color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }
}