import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/colors.dart';
import 'package:flutter_application_1/features/authentication/datasources/login_service.dart';
import 'package:flutter_application_1/features/authentication/presentation/pages/loginpage.dart';
import 'package:flutter_application_1/supportcustomer/presentation/pages/support.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/theme/theme_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  Future<Map<String, String>> _getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      "name": prefs.getString("user_name") ?? "User",
      "email": prefs.getString("user_email") ?? "",
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;

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
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: textColor),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Profile",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ),
                  ),
                  Icon(Icons.settings, size: 26, color: textColor),
                ],
              ),

              const SizedBox(height: 24),

              // avatar + name + email (dynamic now)
              FutureBuilder<Map<String, String>>(
                future: _getUserInfo(),
                builder: (context, snapshot) {
                  final name = snapshot.data?["name"] ?? "User";
                  final email = snapshot.data?["email"] ?? "";

                  return Row(
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
                          Text(
                            name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            email,
                            style: TextStyle(color: mutedColor),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 28),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: iconBubbleColor,
                        child: const Icon(
                          Icons.person_outline,
                          color: Bkcolors.primarycolor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Personal Info",
                        style: TextStyle(fontSize: 11, color: textColor),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: iconBubbleColor,
                        child: const Icon(
                          Icons.shield_outlined,
                          color: Bkcolors.primarycolor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Security",
                        style: TextStyle(fontSize: 11, color: textColor),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          ref.read(themeModeProvider.notifier).state = isDark
                              ? ThemeMode.light
                              : ThemeMode.dark;
                        },
                        child: CircleAvatar(
                          radius: 22,
                          backgroundColor: iconBubbleColor,
                          child: Icon(
                            isDark ? Icons.light_mode : Icons.dark_mode,
                            color: Bkcolors.primarycolor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        isDark ? "Dark Mode" : "Light Mode",
                        style: TextStyle(fontSize: 11, color: textColor),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SupportPage()));
                        },
                        child: CircleAvatar(
                          radius: 22,
                          backgroundColor: iconBubbleColor,
                          child: const Icon(
                            Icons.support_agent,
                            color: Bkcolors.primarycolor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Support",
                        style: TextStyle(fontSize: 11, color: textColor),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 28),

              Text(
                "Account Settings",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),

              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
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

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Row(
                        children: [
                          const Icon(Icons.local_offer_outlined, color: Bkcolors.primarycolor, size: 22),
                          const SizedBox(width: 14),
                          Text("Offers", style: TextStyle(fontSize: 14, color: textColor)),
                          const Spacer(),
                          Icon(Icons.chevron_right, color: mutedColor, size: 20),
                        ],
                      ),
                    ),
                    Divider(height: 1, color: dividerColor),

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

                    InkWell(
                      onTap: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (dialogContext) {
                            return AlertDialog(
                              title: const Text('Log Out'),
                              content: const Text('Are you sure you want to log out?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(dialogContext, false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(dialogContext, true),
                                  child: Text(
                                    'Log Out',
                                    style: TextStyle(color: Bkcolors.redcolor),
                                  ),
                                ),
                              ],
                            );
                          },
                        );

                        if (confirmed != true) return;
                        if (!context.mounted) return;

                        final logoutService = Logoutservice();
                        final success = await logoutService.logoutpost();

                        if (!context.mounted) return;
                        if (success) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const Loginpage()),
                            (route) => false,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Logout failed')),
                          );
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: Row(
                          children: [
                            Icon(
                              Icons.logout,
                              color: Bkcolors.redcolor,
                              size: 22,
                            ),
                            SizedBox(width: 14),
                            Text(
                              "Log Out",
                              style: TextStyle(
                                fontSize: 14,
                                color: Bkcolors.redcolor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
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