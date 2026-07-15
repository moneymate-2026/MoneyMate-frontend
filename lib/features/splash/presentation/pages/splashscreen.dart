import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/colors.dart';
import 'package:flutter_application_1/features/authentication/presentation/pages/Loginpage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> logoScale;
  late Animation<double> logoOpacity;
  late Animation<Offset> walletAnimation;
  late Animation<double> textOpacity;
  late Animation<double> walletScale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    logoScale = Tween<double>(
      begin: 0.7,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    logoOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0, 0.4)),
    );

    walletAnimation = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    textOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.6, 1)),
    );
    walletScale = Tween<double>(
      begin: 0.98,
      end: 1.02,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();
    _navigateNext();
    //   _navigateNext();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _navigateNext() async {
    await Future.delayed(const Duration(seconds: 4));
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Loginpage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: Bkcolors.splashscreens),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40),

                Center(
                  child: FadeTransition(
                    opacity: logoOpacity,
                    child: ScaleTransition(
                      scale: logoScale,
                      child: Image.asset(
                        "assets/fromgood.png",
                        width: screenWidth * 0.55,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),

                Center(
                  child: SlideTransition(
                    position: walletAnimation,
                    child: ScaleTransition(
                      scale: walletScale,
                      child: Image.asset(
                        'assets/wallet_illustration.png',
                        width: screenWidth * 0.78,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),

                const Spacer(flex: 2),

                FadeTransition(
                  opacity: textOpacity,
                  child: const Column(
                    children: [
                      Text(
                        'All your Money,',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'One Smart Place',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFB388FF),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(flex: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
