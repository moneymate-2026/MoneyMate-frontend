import 'package:flutter/material.dart';

class SpendingBarChart extends StatelessWidget {
  const SpendingBarChart({super.key});


  static const _barHeights = [30.0, 20.0, 5.0, 70.0, 15.0, 90.0, 25.0, 0.0, 30.0, 70.0];
  static const _labels = ['1 May', '8 May', '15 May', '22 May', '29 May'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _barHeights.map((h) {
                return Container(
                  width: 14,
                  height: h,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: h > 50 ? const Color(0xFF7C3AED) : const Color(0xFFD8CCF5),
                    borderRadius: BorderRadius.circular(6),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _labels
                .map((l) => Text(l, style: const TextStyle(fontSize: 11, color: Colors.grey)))
                .toList(),
          ),
        ],
      ),
    );
  }
}