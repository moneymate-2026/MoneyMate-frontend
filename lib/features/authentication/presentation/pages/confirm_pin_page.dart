import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/colors.dart';
import 'package:flutter_application_1/core/theme/network/dio_client.dart';

import 'package:flutter_application_1/features/authentication/controllers/confirm_pin_state_controller.dart';

import 'package:flutter_application_1/features/authentication/presentation/pages/loginpage.dart';

import 'package:flutter_application_1/features/authentication/widgets/custom_pin_dot_indicator.dart';
import 'package:flutter_application_1/features/authentication/widgets/custom_pin_numpad.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConfirmPinPage extends ConsumerStatefulWidget {
  final String originalPin;
  final String fullName;
  final String phone;
  final String email;
  final String password;

  const ConfirmPinPage({
    super.key,
    required this.originalPin,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.password,
  });

  @override
  ConsumerState<ConfirmPinPage> createState() => _ConfirmPinPageState();
}

class _ConfirmPinPageState extends ConsumerState<ConfirmPinPage> {
  static const int pinLength = 6;
  bool _isLoading = false;

  void _onConfirmTap() async {
    final notifier = ref.read(confirmPinProvider.notifier);
    if (ref.read(confirmPinProvider).enteredPin.length != pinLength) return;

    if (!notifier.checkMatch(widget.originalPin)) return;

    setState(() => _isLoading = true);

    try {
      // Register API call — full name, phone, email, password, pin ellam koode
      await Authpost().postauth(
        widget.fullName,
        widget.phone,
        widget.email,
        widget.password,
        widget.originalPin,
      );

    
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Loginpage()),
        (route) => false,
      );
    } catch (e) {
      setState(() => _isLoading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final pinState = ref.watch(confirmPinProvider);
    final notifier = ref.read(confirmPinProvider.notifier);
    final bool isPinComplete = pinState.enteredPin.length == pinLength;

    return Scaffold(
      backgroundColor: Bkcolors.whitecolor,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.black87),
              ),
            ),
            const SizedBox(height: 12),

            Image.asset(
              "assets/createlogo.png",
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 16),

            const Text(
              'Confirm your pin',
              style: TextStyle(
                color: Bkcolors.themetext,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),

            PinDotIndicator(
              pinLength: pinLength,
              enteredLength: pinState.enteredPin.length,
            ),

            if (pinState.errorText != null) ...[
              const SizedBox(height: 12),
              Text(
                pinState.errorText!,
                style: const TextStyle(
                  color: Bkcolors.redcolor,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],

            const Spacer(),

            _isLoading
                ? const CircularProgressIndicator()
                : PinNumpad(
                    onNumberTap: notifier.addDigit,
                    onDeleteTap: notifier.deleteDigit,
                    onConfirmTap: _onConfirmTap,
                    showConfirmButton: isPinComplete,
                  ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}