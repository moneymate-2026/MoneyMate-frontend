import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/colors.dart';
import 'package:flutter_application_1/features/authentication/controllers/Register.controller.dart';
import 'package:flutter_application_1/features/authentication/widgets/custom_textfield.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Registerpage extends ConsumerStatefulWidget {
  const Registerpage({super.key});
  @override
  ConsumerState<Registerpage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<Registerpage> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final obscurePassword = ref.watch(obscureRegPasswordProvider);
    final obscureConfirm = ref.watch(obscureConfirmPasswordProvider);
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
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight - 16),
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
                          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold,color: Colors.black),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Let's get you started",
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                        const SizedBox(height: 24),

                        CustomTextField(
                          controller: usernameController,
                          hintText: "Username",
                          prefixIcon: Icons.person_outline,
                        ),
                        const SizedBox(height: 14),

                        CustomTextField(
                          controller: emailController,
                          hintText: "Email or Phone",
                          prefixIcon: Icons.mail_outline,
                        ),
                        const SizedBox(height: 14),

                        CustomTextField(
                          controller: passwordController,
                          hintText: "Password",
                          prefixIcon: Icons.lock_outline,
                          obscureText: obscurePassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                            onPressed: () =>
                                ref.read(obscureRegPasswordProvider.notifier).state =
                                    !obscurePassword,
                          ),
                        ),
                        const SizedBox(height: 14),

                        CustomTextField(
                          controller: confirmPasswordController,
                          hintText: "Confirm Password",
                          prefixIcon: Icons.lock_outline,
                          obscureText: obscureConfirm,
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscureConfirm
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                            onPressed: () => ref
                                    .read(obscureConfirmPasswordProvider.notifier)
                                    .state =
                                !obscureConfirm,
                          ),
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
                                  style: TextStyle(color: Colors.black87),
                                  children: [
                                    TextSpan(
                                      text: "Terms & Conditions",
                                      style: TextStyle(color: Color(0xff6F3DFF)),
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
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(30),
                              onTap: agreeTerms ? () {} : null,
                              child: const Center(
                                child: Text(
                                  "Create Account",
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.white,
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
                                  style: const TextStyle(color: Color(0xff6F3DFF)),
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
                        Image.asset("assets/protectlogo.png",width: 70,height: 70),
                            
                              Text(
                                "Safe. Secure. Private.",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: Colors.black
                                ),
                                
                              ),
                              Text(
                                "We never share your data",
                                style: TextStyle(color: Colors.grey, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: Text(
                            "MoneyMate v1.0.0",
                            style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
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