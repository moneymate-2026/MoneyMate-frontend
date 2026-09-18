import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/colors.dart';

import 'package:flutter_application_1/features/authentication/controllers/Register.controller.dart';
import 'package:flutter_application_1/features/authentication/datasources/otp_controller.dart';

import 'package:flutter_application_1/features/authentication/presentation/pages/otp_verification_page.dart';
import 'package:flutter_application_1/features/authentication/widgets/custom_textfield.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Registerpage extends ConsumerStatefulWidget {
  const Registerpage({super.key});
  @override
  ConsumerState<Registerpage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<Registerpage> {
  final usernameController = TextEditingController();
  final phonenumberController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    phonenumberController.dispose();
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final agreeTerms = ref.watch(agreeTermsProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/rintbg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 8,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 16,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Create your account",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Bkcolors.themetext,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Let's get you started",
                          style: TextStyle(
                            fontSize: 14,
                            color: Bkcolors.themetext,
                          ),
                        ),
                        const SizedBox(height: 24),

                        CustomTextField(
                          controller: usernameController,
                          hintText: "Username",
                          prefixIcon: Icons.person_outline,
                        ),
                        const SizedBox(height: 14),

                        CustomTextField(
                          controller: phonenumberController,
                          hintText: "Phone",
                          prefixIcon: Icons.phone_outlined,
                        ),
                        const SizedBox(height: 14),

                        CustomTextField(
                          controller: emailController,
                          hintText: "Email",
                          prefixIcon: Icons.email_outlined,
                        ),
                        const SizedBox(height: 14),

                        CustomTextField(
                          controller: passwordController,
                          hintText: "Password",
                          prefixIcon: Icons.lock_outline,
                        ),
                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Checkbox(
                              value: agreeTerms,
                              onChanged: (val) =>
                                  ref.read(agreeTermsProvider.notifier).state =
                                      val ?? false,
                            ),
                            const Expanded(
                              child: Text.rich(
                                TextSpan(
                                  text: "I agree to the ",
                                  style: TextStyle(color: Bkcolors.themetext),
                                  children: [
                                    TextSpan(
                                      text: "Terms & Conditions",
                                      style: TextStyle(
                                        color: Bkcolors.primarycolor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        Container(
                          width: double.infinity,
                          height: 54,
                          decoration: BoxDecoration(
                            gradient: Bkcolors.buttons,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Material(
                            color: Bkcolors.trasprntcolor,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(30),
                              onTap: agreeTerms
                                  ? () async {
                                      try {
                                        final otpController = OtpController();
                                        await otpController.sendOtp(
                                          emailController.text.trim(),
                                        );

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                OtpVerificationPage(
                                                  fullname: usernameController
                                                      .text
                                                      .trim(),
                                                  phone: phonenumberController
                                                      .text
                                                      .trim(),
                                                  email: emailController.text
                                                      .trim(),
                                                  password: passwordController
                                                      .text
                                                      .trim(),
                                                ),
                                          ),
                                        );
                                      } catch (e) {
                                        if (!context.mounted) return;

                                        String message = e.toString();

                                        if (message.startsWith("Exception: ")) {
                                          message = message.replaceFirst(
                                            "Exception: ",
                                            "",
                                          );
                                        }
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text(
                                                "Registration Failed",
                                              ),
                                              content: Text(message),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("OK"),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    }
                                  : null,
                              child: const Center(
                                child: Text(
                                  "Create Account",
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Bkcolors.whitecolor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        Center(
                          child: RichText(
                            text: TextSpan(
                              text: "Already have an account? ",
                              style: const TextStyle(color: Colors.black87),
                              children: [
                                TextSpan(
                                  text: "Login",
                                  style: const TextStyle(
                                    color: Bkcolors.primarycolor,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => Navigator.pop(context),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const Spacer(),

                        Center(
                          child: Column(
                            children: [
                              Image.asset(
                                "assets/protectlogo.png",
                                width: 70,
                                height: 70,
                              ),

                              Text(
                                "Safe. Secure. Private.",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: Bkcolors.themetext,
                                ),
                              ),
                              Text(
                                "We never share your data",
                                style: TextStyle(
                                  color: Bkcolors.logocolor,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: Text(
                            "MoneyMate v1.0.0",
                            style: TextStyle(
                              color: Bkcolors.logocolor.shade400,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
