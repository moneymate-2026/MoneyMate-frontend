import 'package:flutter/material.dart';

class TotalSavingsCard extends StatelessWidget {
  const TotalSavingsCard({super.key});

  static const _totalSavings = '₹ 2,450.00';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF9333EA), Color(0xFF3B0764)],
        ),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Total Savings',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              SizedBox(height: 10),
              Text(
                _totalSavings,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          // Simple stand-in for the illustration — swap for an image asset
          // once you have the final artwork.
          Positioned(
            right: 0,
            bottom: 0,
            child: Icon(
              Icons.savings_rounded,
              size: 70,
              color: Colors.white.withOpacity(0.25),
            ),
          ),
        ],
      ),
    );
  }
}