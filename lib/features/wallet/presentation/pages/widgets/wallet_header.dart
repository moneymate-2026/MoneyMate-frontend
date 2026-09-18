import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/colors.dart';

class WalletHeader extends StatelessWidget {
  final bool isDark;
  const WalletHeader({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Bkcolors.whitecolor : Bkcolors.themetext;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
        
            Icon(Icons.arrow_back, size: 22, color: textColor),
            const SizedBox(width: 16),
            Text('Wallet',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor)),
          ],
        ),
   
        Stack(
          clipBehavior: Clip.none,
          children: [
           
     
            const Positioned(
              top: -2,
              right: -2,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Bkcolors.primarycolor,
                  shape: BoxShape.circle,
                ),
                child: SizedBox(width: 10, height: 10),
              ),
            ),
          ],
        ),
      ],
    );
  }
}