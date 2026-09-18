// import 'package:flutter/material.dart';

// class CoinsCard extends StatelessWidget {
//   final int coinBalance;

//   const CoinsCard({
//     super.key,
//     required this.coinBalance,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [Color(0xFF5B21B6), Color(0xFF1E1B4B)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Row(
//                 children: [
//                   Icon(Icons.circle, color: Colors.amber, size: 14),
//                   SizedBox(width: 6),
//                   Text('My Coins', style: TextStyle(color: Colors.white70)),
//                 ],
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 coinBalance.toString(),
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const Text(
//                 'Keep playing games and\nearn more coins!',
//                 style: TextStyle(color: Colors.white70, fontSize: 12),
//               ),
//               const SizedBox(height: 10),
//               InkWell(
//                 onTap: () {
                  
//                 },
//                 child: const Row(
//                   children: [
//                     Text('Play Games', style: TextStyle(color: Colors.amber, fontSize: 13)),
//                     SizedBox(width: 4),
//                     Icon(Icons.arrow_forward, color: Colors.amber, size: 14),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           const Icon(Icons.card_giftcard, color: Colors.amber, size: 50),
//         ],
//       ),
//     );
//   }
// }