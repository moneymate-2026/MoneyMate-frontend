import 'package:flutter/material.dart';


class RecentTransactionsSection extends StatelessWidget {
  const RecentTransactionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // "Recent Transactions" title + "View All" link
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Transactions',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            GestureDetector(
              onTap: () {
         
              },
              child: const Text('View All', style: TextStyle(color: Colors.deepPurple)),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // White rounded box holding all 4 rows below
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              // Row 1: Salary
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE7F9EF),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.work_outline, size: 18, color: Color(0xFF16A34A)),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Received from Salary',
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black)),
                          SizedBox(height: 2),
                          Text('Today, 09:30 AM', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                    const Text('+₹45,000',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF16A34A))),
                    const SizedBox(width: 4),
                    const Icon(Icons.chevron_right, color: Colors.grey, size: 18),
                  ],
                ),
              ),
              const Divider(height: 1, indent: 68),

              // Row 2: Netflix
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.play_arrow_rounded, size: 18, color: Colors.red),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Netflix Subscription',
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black)),
                          SizedBox(height: 2),
                          Text('Yesterday, 08:15 PM', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                    const Text('-₹649',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFFDC2626))),
                    const SizedBox(width: 4),
                    const Icon(Icons.chevron_right, color: Colors.grey, size: 18),
                  ],
                ),
              ),
              const Divider(height: 1, indent: 68),

              // Row 3: Grocery Store
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3E8FF),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.shopping_cart_outlined, size: 18, color: Color(0xFF9333EA)),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('To Grocery Store',
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black)),
                          SizedBox(height: 2),
                          Text('Yesterday, 06:20 PM', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                    const Text('-₹1,250',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFFDC2626))),
                    const SizedBox(width: 4),
                    const Icon(Icons.chevron_right, color: Colors.grey, size: 18),
                  ],
                ),
              ),
              const Divider(height: 1, indent: 68),

              // Row 4: Cashback (last row — no divider after this one)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE7F9EF),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.subject, size: 18, color: Color(0xFF16A34A)),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Cashback Received',
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black)),
                          SizedBox(height: 2),
                          Text('2 May 2024, 11:45 AM', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                    const Text('+₹200',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF16A34A))),
                    const SizedBox(width: 4),
                    const Icon(Icons.chevron_right, color: Colors.grey, size: 18),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}