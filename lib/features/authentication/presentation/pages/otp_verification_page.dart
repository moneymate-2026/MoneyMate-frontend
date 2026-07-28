import 'dart:async';
import 'package:flutter/material.dart';

import 'package:flutter_application_1/core/theme/colors.dart';
import 'package:flutter_application_1/features/authentication/datasources/otp_controller.dart';
import 'package:flutter_application_1/features/authentication/presentation/pages/create_pin_page.dart';
 

class OtpVerificationPage extends StatefulWidget {
  final String email;
  const OtpVerificationPage({required this.email, super.key});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
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
      final otpController = OtpController
      ();
      await otpController.sendOtp(widget.email);

      startCooldown();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() {
        isSending = false;
      });
    }
  }

  Future<void> verifyOtp() async {
    final code = box1.text + box2.text + box3.text + box4.text + box5.text + box6.text;

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
      await otpController.verifyOtp(widget.email, code);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CreatePinPage(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() {
        isVerifying = false;
      });
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
      backgroundColor: Bkcolors.whitecolor,
      body: SafeArea(
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
                height: 45,
                child: OutlinedButton(
                  onPressed: (isSending || secondsRemaining > 0) ? null : sendOtp,
                  child: Text(
                    isSending
                        ? 'Sending...'
                        : secondsRemaining > 0
                            ? 'Resend in ${secondsRemaining}s'
                            : 'Send OTP',
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 45,
                    height: 55,
                    child: TextField(
                      controller: box1,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      decoration: const InputDecoration(counterText: ''),
                    ),
                  ),
                  SizedBox(
                    width: 45,
                    height: 55,
                    child: TextField(
                      controller: box2,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      decoration: const InputDecoration(counterText: ''),
                    ),
                  ),
                  SizedBox(
                    width: 45,
                    height: 55,
                    child: TextField(
                      controller: box3,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      decoration: const InputDecoration(counterText: ''),
                    ),
                  ),
                  SizedBox(
                    width: 45,
                    height: 55,
                    child: TextField(
                      controller: box4,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      decoration: const InputDecoration(counterText: ''),
                    ),
                  ),
                  SizedBox(
                    width: 45,
                    height: 55,
                    child: TextField(
                      controller: box5,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      decoration: const InputDecoration(counterText: ''),
                    ),
                  ),
                  SizedBox(
                    width: 45,
                    height: 55,
                    child: TextField(
                      controller: box6,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      decoration: const InputDecoration(counterText: ''),
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
                          style: TextStyle(fontSize: 16, color: Bkcolors.whitecolor),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}