import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/colors.dart';
import 'package:flutter_application_1/features/authentication/datasources/login_service.dart';
import 'package:flutter_application_1/features/authentication/presentation/pages/loginpage.dart';
import 'package:flutter_application_1/features/profile/presentation/pages/complaint_reportpage.dart';
import 'package:flutter_application_1/features/profile/presentation/pages/controller/profile_service.dart';
import 'package:flutter_application_1/features/profile/presentation/pages/feedback.dart';
import 'package:flutter_application_1/supportcustomer/presentation/pages/support.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/theme/theme_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  String? profileImageUrl;
  bool uploadingImage = false;
  String? qrCode;

  @override
  void initState() {
    super.initState();
    // _loadQrCode();
    _loadProfile();
  }

  // Future<void> _loadQrCode() async {
  //   try {
  //     final result = await getprofile();

  //     if (!mounted) return;

  //     setState(() {
  //       qrCode = result;
  //     });
  //   } catch (e) {
  //     debugPrint('QR Code Error: $e');
  //   }
  // }

  Future<Map<String, String>> _getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      "name": prefs.getString("user_name") ?? "User",
      "email": prefs.getString("user_email") ?? "",
    };
  }

  Future<void> _selectProfileImage() async {
    if (uploadingImage) return;

    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image == null) return;

    try {
      setState(() {
        uploadingImage = true;
      });

      
      final bytes = await image.readAsBytes();

    
      final contentType = image.mimeType ?? 'image/jpeg';

   final presign = await getPresignedUrl(contentType);

debugPrint("UPLOAD URL: ${presign.uploadUrl}");
debugPrint("PUBLIC URL: ${presign.publicUrl}");

await uploadToS3(
  uploadUrl: presign.uploadUrl,
  bytes: bytes,
  contentType: contentType,
);

await confirmProfilePicture(presign.publicUrl);

if (!mounted) return;

setState(() {
  profileImageUrl = presign.publicUrl;
  uploadingImage = false;
});

debugPrint("PROFILE PHOTO SAVED: ${presign.publicUrl}");

ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(
    content: Text('Profile photo updated successfully'),
  ),
);
       

    } catch (e) {
      if (!mounted) return;

      setState(() {
        uploadingImage = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload profile photo: $e')),
      );
    }
  }
  Future<void> _loadProfile() async {
  try {
    final data = await getprofile();

    if (!mounted) return;

    setState(() {
      qrCode = data['qr_code'];
      profileImageUrl = data['profile_image_url'];
    });

    debugPrint('Profile Image URL: $profileImageUrl');
  } catch (e) {
    debugPrint('Profile Error: $e');
  }
}

  void _showQrCode() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "My QR Code",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: qrCode != null && qrCode!.isNotEmpty
                      ? Image.memory(
                          base64Decode(qrCode!.split(',').last),
                          width: 180,
                          height: 180,
                          fit: BoxFit.contain,
                        )
                      : const SizedBox(
                          width: 180,
                          height: 180,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                ),

                const SizedBox(height: 16),

                const Text(
                  "Scan this QR code to view my profile",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Bkcolors.primarycolor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Close"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;

    final textColor = isDark ? Bkcolors.whitecolor : Bkcolors.themetext;

    final mutedColor = isDark ? Colors.grey[400] : Colors.grey;

    final cardColor = isDark ? Bkcolors.darkcardcolor : Bkcolors.whitecolor;

    final dividerColor = isDark ? Bkcolors.darkbordercolor : Colors.grey[200];

    final pageBackground = isDark
        ? Bkcolors.scaffoldbackground
        : Colors.grey[100];

    final iconBubbleColor = isDark
        ? Bkcolors.darkcardcolor
        : Colors.deepPurple[50];

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
              FutureBuilder<Map<String, String>>(
                future: _getUserInfo(),

                builder: (context, snapshot) {
                  final name = snapshot.data?["name"] ?? "User";

                  final email = snapshot.data?["email"] ?? "";

                  return Row(
                    children: [
                      GestureDetector(
                        onTap: _selectProfileImage,

                        child: Stack(
                          children: [
                            Container(
                              width: 72,
                              height: 72,

                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.shade300,

                                border: Border.all(
                                  color: Bkcolors.primarycolor,
                                  width: 2,
                                ),
                              ),

                              child: ClipOval(
                                child:
                                  profileImageUrl != null && profileImageUrl!.isNotEmpty
    ? ClipOval(
        child: Image.network(
          profileImageUrl!,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.person, size: 50);
          },
        ),
      )
    : const Icon(Icons.person, size: 50),
                              ),
                            ),

                            Positioned(
                              bottom: 0,
                              right: 0,

                              child: Container(
                                width: 25,
                                height: 25,

                                decoration: BoxDecoration(
                                  color: Bkcolors.primarycolor,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: pageBackground!,
                                    width: 2,
                                  ),
                                ),

                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 13,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text(
                              name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,

                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              email,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,

                              style: TextStyle(color: mutedColor, fontSize: 13),
                            ),

                            const SizedBox(height: 5),

                            GestureDetector(
                              onTap: _selectProfileImage,

                              child: const Text(
                                "Change profile photo",
                                style: TextStyle(
                                  color: Bkcolors.primarycolor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      GestureDetector(
                        onTap: _showQrCode,

                        child: Container(
                          width: 52,
                          height: 52,

                          decoration: BoxDecoration(
                            color: iconBubbleColor,
                            borderRadius: BorderRadius.circular(15),

                            border: Border.all(
                              color: Bkcolors.primarycolor.withOpacity(0.15),
                            ),
                          ),

                          child: const Icon(
                            Icons.qr_code_2,
                            color: Bkcolors.primarycolor,
                            size: 30,
                          ),
                        ),
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SupportPage(),
                            ),
                          );
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
                    // PRIVACY
                    _settingItem(
                      icon: Icons.privacy_tip_outlined,
                      title: "Privacy Policy",
                      textColor: textColor,
                      mutedColor: mutedColor,
                    ),

                    Divider(height: 1, color: dividerColor),

                    // REWARDS
                    _settingItem(
                      icon: Icons.card_giftcard,
                      title: "Rewards",
                      textColor: textColor,
                      mutedColor: mutedColor,
                    ),

                    Divider(height: 1, color: dividerColor),

                    // OFFERS
                    _settingItem(
                      icon: Icons.local_offer_outlined,
                      title: "Offers",
                      textColor: textColor,
                      mutedColor: mutedColor,
                    ),

                    Divider(height: 1, color: dividerColor),

                    // REFER
                    _settingItem(
                      icon: Icons.people_outline,
                      title: "Refer & Earn",
                      textColor: textColor,
                      mutedColor: mutedColor,
                    ),

                    Divider(height: 1, color: dividerColor),

                    // HELP
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ComplaintReportPage(),
                          ),
                        );
                      },

                      child: _settingItem(
                        icon: Icons.help_outline,
                        title: "Help & Support",
                        textColor: textColor,
                        mutedColor: mutedColor,
                      ),
                    ),

                    Divider(height: 1, color: dividerColor),

                    // FEEDBACK
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Feedbacks()),
                        );
                      },

                      child: _settingItem(
                        icon: Icons.feedback_outlined,
                        title: "Feedback",
                        textColor: textColor,
                        mutedColor: mutedColor,
                      ),
                    ),

                    // LOGOUT
                    InkWell(
                      onTap: _logout,

                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),

                        child: Row(
                          children: [
                            Icon(
                              Icons.logout,
                              color: Bkcolors.redcolor,
                              size: 22,
                            ),

                            const SizedBox(width: 14),

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

  Widget _settingItem({
    required IconData icon,
    required String title,
    required Color textColor,
    required Color? mutedColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),

      child: Row(
        children: [
          Icon(icon, color: Bkcolors.primarycolor, size: 22),

          const SizedBox(width: 14),

          Text(title, style: TextStyle(fontSize: 14, color: textColor)),

          const Spacer(),

          Icon(Icons.chevron_right, color: mutedColor, size: 20),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,

      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Log Out"),

          content: const Text("Are you sure you want to log out?"),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },

              child: const Text("Cancel"),
            ),

            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },

              child: Text(
                "Log Out",
                style: TextStyle(color: Bkcolors.redcolor),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    if (!mounted) return;

    final logoutService = Logoutservice();

    final success = await logoutService.logoutpost();

    if (!mounted) return;

    if (success) {
      Navigator.pushAndRemoveUntil(
        context,

        MaterialPageRoute(builder: (context) => const Loginpage()),

        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Logout failed")));
    }
  }
}
