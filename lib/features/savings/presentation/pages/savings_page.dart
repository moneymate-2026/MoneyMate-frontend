import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/colors.dart';
import 'package:flutter_application_1/core/theme/theme_controller.dart';
import 'package:flutter_application_1/features/savings/presentation/pages/widgets/total_savings_card.dart';
import 'package:flutter_application_1/features/savings/presentation/pages/widgets/transfer_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class SavingsPage extends ConsumerWidget {
  const SavingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final textColor = isDark ? Bkcolors.whitecolor : Bkcolors.themetext;

    return Scaffold(
      
      backgroundColor: isDark ? Bkcolors.scaffoldbackground : const Color(0xFFF5F5F7),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
            
                  Icon(Icons.arrow_back, size: 22, color: textColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Savings',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold, color: textColor)),
                        const SizedBox(height: 2),
                        Text(
                          'Grow your money, achieve your goals',
                          style: TextStyle(
                              color: isDark ? Colors.grey[400] : Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
          
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E1E1E) : Bkcolors.whitecolor,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE5E5EA)),
                    ),
                 
                    child: const Icon(Icons.settings_outlined, size: 18, color: Bkcolors.primarycolor),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const TotalSavingsCard(),
              const SizedBox(height: 24),
              const TransferCard(),
            ],
          ),
        ),
      ),
    );
  }
}