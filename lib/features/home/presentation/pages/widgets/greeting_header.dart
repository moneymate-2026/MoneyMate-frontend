import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/profile/presentation/pages/profile_page.dart';

class GreetingHeader extends StatelessWidget {
  final String userName;

  const GreetingHeader({
    super.key,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good Morning,',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
                fontSize: 14,
              ),
            ),
            Row(
              children: [
                Text(
                  userName,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
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
              onPressed: () {
         
              },
            ),
                 GestureDetector(onTap: () {
                   
                 Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfilePage()));

                 },child:CircleAvatar(
                                    backgroundColor: Colors.deepPurple.shade50,
        child: const Icon(
          Icons.person,
          color: Colors.deepPurple,
        ),




                 ) ,)
            
           
          ],
        ),
      ],
    );
  }
}