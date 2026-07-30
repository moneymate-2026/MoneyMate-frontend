import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/theme/theme_controller.dart';


class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // check if dark mode is on
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;

    // pick colors based on dark mode
    final textColor = isDark ? Bkcolors.whitecolor : Bkcolors.themetext;
    final mutedColor = isDark ? Colors.grey[400] : Colors.grey;
    final cardColor = isDark ? Bkcolors.darkcardcolor : Bkcolors.whitecolor;
    final dividerColor = isDark ? Bkcolors.darkbordercolor : Colors.grey[200];
    final pageBackground = isDark ? Bkcolors.scaffoldbackground : Colors.grey[100];
    final iconBubbleColor = isDark ? Bkcolors.darkcardcolor : Colors.deepPurple[50];

    return Scaffold(
      backgroundColor: pageBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // title row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Profile", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: textColor)),
                  Icon(Icons.settings, size: 26, color: textColor),
                ],
              ),

              const SizedBox(height: 24),

              // avatar + name + email
              Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, color: Colors.white, size: 30),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Muhammed", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
                      const SizedBox(height: 2),
                      Text("muhammed@email.com", style: TextStyle(color: mutedColor)),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // 4 quick action icons, written one by one
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: iconBubbleColor,
                        child: const Icon(Icons.person_outline, color: Bkcolors.primarycolor),
                      ),
                      const SizedBox(height: 6),
                      Text("Personal Info", style: TextStyle(fontSize: 11, color: textColor)),
                    ],
                  ),
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: iconBubbleColor,
                        child: const Icon(Icons.shield_outlined, color: Bkcolors.primarycolor),
                      ),
                      const SizedBox(height: 6),
                      Text("Security", style: TextStyle(fontSize: 11, color: textColor)),
                    ],
                  ),
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: iconBubbleColor,
                        child: const Icon(Icons.settings_outlined, color: Bkcolors.primarycolor),
                      ),
                      const SizedBox(height: 6),
                      Text("Preferences", style: TextStyle(fontSize: 11, color: textColor)),
                    ],
                  ),
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: iconBubbleColor,
                        child: const Icon(Icons.support_agent, color: Bkcolors.primarycolor),
                      ),
                      const SizedBox(height: 6),
                      Text("Support", style: TextStyle(fontSize: 11, color: textColor)),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 28),

              Text("Account Settings", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),

              const SizedBox(height: 10),

              // settings list card
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(14)),
                child: Column(
                  children: [

                    // Linked Accounts
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Row(
                        children: [
                          const Icon(Icons.link, color: Bkcolors.primarycolor, size: 22),
                          const SizedBox(width: 14),
                          Text("Linked Accounts", style: TextStyle(fontSize: 14, color: textColor)),
                          const Spacer(),
                          Icon(Icons.chevron_right, color: mutedColor, size: 20),
                        ],
                      ),
                    ),
                    Divider(height: 1, color: dividerColor),

                    // OTP Verification
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Row(
                        children: [
                          const Icon(Icons.email_outlined, color: Bkcolors.primarycolor, size: 22),
                          const SizedBox(width: 14),
                          Text("OTP Verification", style: TextStyle(fontSize: 14, color: textColor)),
                          const Spacer(),
                          Icon(Icons.chevron_right, color: mutedColor, size: 20),
                        ],
                      ),
                    ),
                    Divider(height: 1, color: dividerColor),

                    // Privacy Policy
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Row(
                        children: [
                          const Icon(Icons.privacy_tip_outlined, color: Bkcolors.primarycolor, size: 22),
                          const SizedBox(width: 14),
                          Text("Privacy Policy", style: TextStyle(fontSize: 14, color: textColor)),
                          const Spacer(),
                          Icon(Icons.chevron_right, color: mutedColor, size: 20),
                        ],
                      ),
                    ),
                    Divider(height: 1, color: dividerColor),

                    // Rewards
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Row(
                        children: [
                          const Icon(Icons.card_giftcard, color: Bkcolors.primarycolor, size: 22),
                          const SizedBox(width: 14),
                          Text("Rewards", style: TextStyle(fontSize: 14, color: textColor)),
                          const Spacer(),
                          Icon(Icons.chevron_right, color: mutedColor, size: 20),
                        ],
                      ),
                    ),
                    Divider(height: 1, color: dividerColor),

                    // Refer & Earn
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Row(
                        children: [
                          const Icon(Icons.people_outline, color: Bkcolors.primarycolor, size: 22),
                          const SizedBox(width: 14),
                          Text("Refer & Earn", style: TextStyle(fontSize: 14, color: textColor)),
                          const Spacer(),
                          Icon(Icons.chevron_right, color: mutedColor, size: 20),
                        ],
                      ),
                    ),
                    Divider(height: 1, color: dividerColor),

                    // Help & Support
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Row(
                        children: [
                          const Icon(Icons.help_outline, color: Bkcolors.primarycolor, size: 22),
                          const SizedBox(width: 14),
                          Text("Help & Support", style: TextStyle(fontSize: 14, color: textColor)),
                          const Spacer(),
                          Icon(Icons.chevron_right, color: mutedColor, size: 20),
                        ],
                      ),
                    ),
                    Divider(height: 1, color: dividerColor),

                    // Log Out
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Row(
                        children: [
                          Icon(Icons.logout, color: Bkcolors.redcolor, size: 22),
                          SizedBox(width: 14),
                          Text("Log Out", style: TextStyle(fontSize: 14, color: Bkcolors.redcolor, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),

                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}