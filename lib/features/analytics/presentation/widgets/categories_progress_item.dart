import 'package:flutter/material.dart';


class CategoryListSection extends StatelessWidget {
  const CategoryListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Spending by Category',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            GestureDetector(
              onTap: () {
            
              },
              child: const Text('View All', style: TextStyle(color: Color(0xFF7C3AED))),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const _CategoryTile(
          icon: Icons.shopping_bag_outlined,
          bgColor: Color(0xFFF3E8FF),
          fgColor: Color(0xFF7C3AED),
          title: 'Shopping',
          percent: 0.32,
          amount: '₹8,150',
        ),
        const SizedBox(height: 14),
        const _CategoryTile(
          icon: Icons.restaurant_outlined,
          bgColor: Color(0xFFFFF1DB),
          fgColor: Color(0xFFE8A33D),
          title: 'Food & Dining',
          percent: 0.25,
          amount: '₹6,360',
        ),
        const SizedBox(height: 14),
        const _CategoryTile(
          icon: Icons.directions_car_outlined,
          bgColor: Color(0xFFDCEBFF),
          fgColor: Color(0xFF3B82F6),
          title: 'Transport',
          percent: 0.15,
          amount: '₹3,820',
        ),
      ],
    );
  }
}

/// Reusable single-category row with a progress bar.
class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.icon,
    required this.bgColor,
    required this.fgColor,
    required this.title,
    required this.percent,
    required this.amount,
  });

  final IconData icon;
  final Color bgColor;
  final Color fgColor;
  final String title;
  final double percent;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: fgColor, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                  Text('${(percent * 100).toInt()}%   $amount',
                      style: const TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: percent,
                  minHeight: 6,
                  backgroundColor: const Color(0xFFEDEDED),
                  valueColor: AlwaysStoppedAnimation<Color>(fgColor),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}