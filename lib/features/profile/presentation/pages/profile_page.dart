import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/colors.dart';
import 'package:flutter_application_1/core/theme/theme_controller.dart';
import 'package:flutter_application_1/features/authentication/datasources/login_service.dart';
import 'package:flutter_application_1/features/authentication/presentation/pages/loginpage.dart';
import 'package:flutter_application_1/features/profile/presentation/pages/complaint_reportpage.dart';
import 'package:flutter_application_1/features/profile/presentation/pages/controller/profile_service.dart';
import 'package:flutter_application_1/features/profile/presentation/pages/feedback.dart';
import 'package:flutter_application_1/features/profile/presentation/pages/privacyandpolicy.dart';
import 'package:flutter_application_1/supportcustomer/presentation/pages/support.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});
  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  String? profileImageUrl, qrCode;
  bool uploadingImage = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<Map<String, String>> _getUserInfo() async {
    final p = await SharedPreferences.getInstance();
    return {
      'name': p.getString('user_name') ?? 'User',
      'email': p.getString('user_email') ?? '',
    };
  }

  Future<void> _selectProfileImage() async {
    if (uploadingImage) return;
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image == null) return;
    try {
      setState(() => uploadingImage = true);
      final bytes = await image.readAsBytes();
      final type = image.mimeType ?? 'image/jpeg';
      final p = await getPresignedUrl(type);
      await uploadToS3(uploadUrl: p.uploadUrl, bytes: bytes, contentType: type);
      await confirmProfilePicture(p.publicUrl);
      if (!mounted) return;
      setState(() {
        profileImageUrl = p.publicUrl;
        uploadingImage = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile photo updated successfully')),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => uploadingImage = false);
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
        profileImageUrl = data['profile_picture_url'];
      });
    } catch (e) {
      debugPrint('Profile Error: $e');
    }
  }

  void _showQrCode() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'My QR Code',
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
                child: qrCode?.isNotEmpty == true
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
                'Scan this QR code to view my profile',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Bkcolors.primarycolor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _open(Widget page) =>
      Navigator.push(context, MaterialPageRoute(builder: (_) => page));

  @override
  Widget build(BuildContext context) {
    final dark = ref.watch(themeModeProvider) == ThemeMode.dark;
    final text = dark ? Bkcolors.whitecolor : Bkcolors.themetext;
    final muted = dark ? Colors.grey[400] : Colors.grey;
    final card = dark ? Bkcolors.darkcardcolor : Bkcolors.whitecolor;
    final divider = dark ? Bkcolors.darkbordercolor : Colors.grey[200];
    final bg = dark ? Bkcolors.scaffoldbackground : Colors.grey[100];
    final bubble = dark ? Bkcolors.darkcardcolor : Colors.deepPurple[50];

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: text),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: text,
                        ),
                      ),
                    ),
                  ),
                  Icon(Icons.settings, size: 26, color: text),
                ],
              ),
              const SizedBox(height: 24),
              FutureBuilder<Map<String, String>>(
                future: _getUserInfo(),
                builder: (_, s) {
                  final name = s.data?['name'] ?? 'User';
                  final email = s.data?['email'] ?? '';
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
                                child: profileImageUrl?.isNotEmpty == true
                                    ? Image.network(
                                        profileImageUrl!,
                                        width: 72,
                                        height: 72,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            const Icon(Icons.person, size: 50),
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
                                  border: Border.all(color: bg!, width: 2),
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
                                color: text,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              email,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: muted, fontSize: 13),
                            ),
                            const SizedBox(height: 5),
                            GestureDetector(
                              onTap: _selectProfileImage,
                              child: const Text(
                                'Change profile photo',
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
                            color: bubble,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Bkcolors.primarycolor.withOpacity(.15),
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
                  _quick(Icons.person_outline, 'Personal Info', text, bubble),
                  _quick(Icons.shield_outlined, 'Security', text, bubble),
                  GestureDetector(
                    onTap: () => ref.read(themeModeProvider.notifier).state =
                        dark ? ThemeMode.light : ThemeMode.dark,
                    child: _quick(
                      dark ? Icons.light_mode : Icons.dark_mode,
                      dark ? 'Dark Mode' : 'Light Mode',
                      text,
                      bubble,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Text(
                'Account Settings',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: text,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: card,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: GestureDetector(
                     onTap:(){

                      Navigator.push(context, MaterialPageRoute(builder: (context)=>PrivacyPolicyPage()));
                     } ,
                  child: Column(
                    children: [
                      _setting(
                        Icons.privacy_tip_outlined,
                        'Privacy Policy',
                        text,
                        muted,
                      ),
                      Divider(height: 1, color: divider),
                      InkWell(
                        onTap: () => _open(ComplaintReportPage()),
                        child: _setting(
                          Icons.help_outline,
                          'Help & Support',
                          text,
                          muted,
                        ),
                      ),
                      Divider(height: 1, color: divider),
                      InkWell(
                        onTap: () => _open(Feedbacks()),
                        child: _setting(
                          Icons.feedback_outlined,
                          'Feedback',
                          text,
                          muted,
                        ),
                      ),
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
                                'Log Out',
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
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _quick(IconData icon, String title, Color text, Color? bg) {
    return Column(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: bg,
          child: Icon(icon, color: Bkcolors.primarycolor),
        ),
        const SizedBox(height: 6),
        Text(title, style: TextStyle(fontSize: 11, color: text)),
      ],
    );
  }

  Widget _setting(IconData icon, String title, Color text, Color? muted) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: Bkcolors.primarycolor, size: 22),
          const SizedBox(width: 14),
          Text(title, style: TextStyle(fontSize: 14, color: text)),
          const Spacer(),
          Icon(Icons.chevron_right, color: muted, size: 20),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(c, true),
            child: Text('Log Out', style: TextStyle(color: Bkcolors.redcolor)),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    final success = await Logoutservice().logoutpost();
    if (!mounted) return;
    if (success) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const Loginpage()),
        (_) => false,
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Logout failed')));
    }
  }
}
