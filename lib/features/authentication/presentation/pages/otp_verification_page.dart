import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_application_1/core/theme/colors.dart';
import 'package:flutter_application_1/core/theme/network/dio_client.dart';
import 'package:flutter_application_1/features/authentication/datasources/otp_controller.dart';

import 'package:flutter_application_1/features/authentication/presentation/pages/create_pin_page.dart';

class OtpVerificationPage extends StatefulWidget {
  final String fullname;
  final String phone;
  final String email;
  final String password;

  const OtpVerificationPage({
    required this.fullname,
    required this.phone,
    required this.email,
    required this.password,
    super.key,
  });

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  InputDecoration otpBoxDecoration() {
    return InputDecoration(
      counterText: '',
      filled: true,
      fillColor: Bkcolors.whitecolor,

      contentPadding: EdgeInsets.zero,

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1.2),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Bkcolors.primarycolor, width: 2),
      ),
    );
  }

  final TextEditingController box1 = TextEditingController();
  final TextEditingController box2 = TextEditingController();
  final TextEditingController box3 = TextEditingController();
  final TextEditingController box4 = TextEditingController();
  final TextEditingController box5 = TextEditingController();
  final TextEditingController box6 = TextEditingController();

  bool isSending = false;
  bool isVerifying = false;
  int secondsRemaining = 0;
  Timer? cooldownTimer;

  void startCooldown() {
    setState(() {
      secondsRemaining = 60;
    });

    cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining == 0) {
        timer.cancel();
      } else {
        setState(() {
          secondsRemaining--;
        });
      }
    });
  }

  Future<void> sendOtp() async {
    setState(() {
      isSending = true;
    });

    try {
      final otpController = OtpController();
      await otpController.sendOtp(widget.email);

      startCooldown();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() {
        isSending = false;
      });
    }
  }

  Future<void> verifyOtp() async {
    final code =
        box1.text + box2.text + box3.text + box4.text + box5.text + box6.text;

    if (code.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the full 6-digit code')),
      );
      return;
    }

    setState(() {
      isVerifying = true;
    });

    try {
      final otpController = OtpController();
      final isVerified = await otpController.verifyOtp(widget.email, code);

      if (isVerified != true) {
        return;
      }
      final authpost = Authpost();
      await authpost.postauth(
        widget.fullname,
        widget.phone,
        widget.email,
        widget.password,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration Successful'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const CreatePinPage()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        setState(() {
          isVerifying = false;
        });
      }
    }
  }

  @override
  void dispose() {
    box1.dispose();
    box2.dispose();
    box3.dispose();
    box4.dispose();
    box5.dispose();
    box6.dispose();
    cooldownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.extraLightBackgroundGray,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/rintbg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Verify OTP',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Bkcolors.themetext,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Enter the 6-digit code sent to ${widget.email}',
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: OutlinedButton(
                    onPressed: (isSending || secondsRemaining > 0)
                        ? null
                        : sendOtp,
                    child: Text(
                      isSending
                          ? 'Sending...'
                          : secondsRemaining > 0
                          ? 'Resend in ${secondsRemaining}s'
                          : 'Send OTP',
                      style: TextStyle(
                        color: secondsRemaining > 0
                            ? Colors.orange
                            : Bkcolors.primarycolor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 48,
                      height: 56,
                      child: TextField(
                        style: TextStyle(
                          color: Bkcolors.themetext,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        controller: box1,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        decoration: otpBoxDecoration(),
                      ),
                    ),
                    SizedBox(
                      width: 48,
                      height: 56,
                      child: TextField(
                        style: TextStyle(
                          color: Bkcolors.themetext,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        controller: box2,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        decoration: otpBoxDecoration(),
                      ),
                    ),
                    SizedBox(
                      width: 48,
                      height: 56,
                      child: TextField(
                        style: TextStyle(
                          color: Bkcolors.themetext,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        controller: box3,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        decoration: otpBoxDecoration(),
                      ),
                    ),
                    SizedBox(
                      width: 48,
                      height: 56,
                      child: TextField(
                        style: TextStyle(
                          color: Bkcolors.themetext,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        controller: box4,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        decoration: otpBoxDecoration(),
                      ),
                    ),
                    SizedBox(
                      width: 48,
                      height: 56,
                      child: TextField(
                        style: TextStyle(
                          color: Bkcolors.themetext,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        controller: box5,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        decoration: otpBoxDecoration(),
                      ),
                    ),
                    SizedBox(
                      width: 48,
                      height: 56,
                      child: TextField(
                        style: TextStyle(
                          color: Bkcolors.themetext,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        controller: box6,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        decoration: otpBoxDecoration(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isVerifying ? null : verifyOtp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Bkcolors.primarycolor,
                    ),
                    child: isVerifying
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Bkcolors.whitecolor,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Verify',
                            style: TextStyle(
                              fontSize: 16,
                              color: Bkcolors.whitecolor,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
