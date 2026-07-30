import 'package:flutter/material.dart';

class PeriodPill extends StatelessWidget {
  const PeriodPill({super.key, required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
 
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF0F0F3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Text(
            'This Month',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          Icon(Icons.keyboard_arrow_down, color: isDark ? Colors.white : Colors.black),
        ],
      ),
    );
  }
}