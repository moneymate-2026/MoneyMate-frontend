import 'package:flutter/material.dart';


class OverviewSection extends StatelessWidget {
  const OverviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Spending Overview',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        const SizedBox(height: 14),
        Row(
          children: const [
            Expanded(
              child: _OverviewCard(
                title: 'Highest Spending',
                value: '₹8,150',
                subtitle: 'Shopping',
                bgColor: Color(0xFFF3E8FF),
                valueColor: Color(0xFF7C3AED),
              ),
            ),
            SizedBox(width: 14),
            Expanded(
              child: _OverviewCard(
                title: 'Average Daily Spend',
                value: '₹821',
                subtitle: 'This Month',
                bgColor: Color(0xFFE7F9EF),
                valueColor: Color(0xFF16A34A),
                trailingIcon: Icons.trending_up,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _OverviewCard extends StatelessWidget {
  const _OverviewCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.bgColor,
    required this.valueColor,
    this.trailingIcon,
  });

  final String title;
  final String value;
  final String subtitle;
  final Color bgColor;
  final Color valueColor;
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 12, color: valueColor)),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(value,
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold, color: valueColor)),
              if (trailingIcon != null) ...[
                const Spacer(),
                Icon(trailingIcon, color: valueColor, size: 18),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}