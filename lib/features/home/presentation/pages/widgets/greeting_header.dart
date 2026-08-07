import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/profile/presentation/pages/profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GreetingHeader extends StatelessWidget {
  const GreetingHeader({super.key});
Future<String> getUserName() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString("user_name") ?? "User";
}
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             FutureBuilder<String>(
  future: getUserName(),
  builder: (context, snapshot) {
    final name = snapshot.data ?? "User";

    return Text(
      "Hello, $name",
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  },
),
            Text(
              'Good Morning,',
              style: TextStyle(
                color: Theme.of(
                  context,
                ).textTheme.bodyMedium?.color?.withOpacity(0.6),
                fontSize: 14,
              ),
            ),
            Row(
              children: [
                const SizedBox(width: 6),
                const Text('👋', style: TextStyle(fontSize: 20)),
              ],
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.notifications_none_rounded,
                color: Theme.of(context).iconTheme.color,
              ),
              onPressed: () {},
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
              child: CircleAvatar(
                backgroundColor: Colors.deepPurple.shade50,
                child: const Icon(Icons.person, color: Colors.deepPurple),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
