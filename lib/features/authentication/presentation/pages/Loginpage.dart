import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/colors.dart';
import 'package:flutter_application_1/features/authentication/controllers/Login_controller.dart';
import 'package:flutter_application_1/features/authentication/presentation/pages/Registerpage.dart';
import 'package:flutter_application_1/features/authentication/widgets/custom_socialbutton.dart';
import 'package:flutter_application_1/features/authentication/widgets/custom_textfield.dart';
import 'package:flutter_application_1/features/navigation/presentation/pages/bottom_nav.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Loginpage extends ConsumerStatefulWidget {
  const Loginpage({super.key});
  @override
  ConsumerState<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends ConsumerState<Loginpage>
    with SingleTickerProviderStateMixin {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late AnimationController _walletController;
  late Animation<double> _walletFloat;
  @override
  void initState() {
    super.initState();

    _walletController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _walletFloat = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _walletController, curve: Curves.easeInOut),
    );

    _walletController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _walletController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final obscurePassword = ref.watch(obscurePasswordProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/rintbg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const Text(
                  "Welcome back!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  "Good to see you again",
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  height: (width * .70) + 15,
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _walletFloat,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _walletFloat.value),
                          child: child,
                        );
                      },
                      child: Image.asset(
                        "assets/loginlogo.png",
                        width: width * .70,
                      ),
                    ),
                  ),
                ),

                CustomTextField(
                  controller: emailController,
                  hintText: "Email or Phone",
                  prefixIcon: Icons.mail_outline,
                ),
                const SizedBox(height: 10),
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
                          color: Colors.black,
                    ),
                    onPressed: () =>
                        ref.read(obscurePasswordProvider.notifier).state =
                            !obscurePassword,
                  ),
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(color: Color(0xff6F3DFF)),
                    ),
                  ),
                ),
                const SizedBox(height: 4),

                Container(
                  width: double.infinity,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: Bkcolors.buttons,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Bottomnav_page(),
                          ),
                          (route) => false,
                        );
                      },
                      child: const Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Registerpage()),
                      );
                    },
                    child: const Text(
                      "Create Account",
                      style: TextStyle(color: Color(0xff6F3DFF)),
                    ),
                  ),
                ),
                const SizedBox(height: 6),

                const Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text("Or continue with",style: TextStyle(color: Colors.black),),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    SocialLoginButton(
                      label: "Google",
                      icon: FaIcon(
                        FontAwesomeIcons.google,
                        color: const Color.fromARGB(255, 0, 0, 0),
                        size: 20,
                      ),

                      onPressed: () {},
                    ),
                    SizedBox(width: 12),
                    SocialLoginButton(
                      label: "Apple",
                      icon: const Icon(Icons.apple, color: Colors.black),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                const Center(
                  child: Column(
                    children: [
                      Icon(Icons.security, color: Colors.grey, size: 20),
                      SizedBox(height: 6),
                      Text(
                        "Bank-level Security",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,color: Colors.black
                        ),
                      ),
                      Text(
                        "Your data is 100% safe with us",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
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
      ),
    );
  }
}
