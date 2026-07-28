import 'package:flutter/material.dart';

class AnalyticsHeader extends StatelessWidget {
  const AnalyticsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFF0E6FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.show_chart, color: Color(0xFF8A3FFC)),
        ),
        const SizedBox(width: 12),
        const Text(
          'Analytics',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}