import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/colors.dart';
import 'package:flutter_application_1/features/authentication/controllers/enter_pinnotifier.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_application_1/features/authentication/controllers/pin_controller.dart';
import 'package:flutter_application_1/features/authentication/controllers/enter_pin_state_controller.dart';

import 'package:flutter_application_1/features/authentication/widgets/custom_pin_dot_indicator.dart';
import 'package:flutter_application_1/features/authentication/widgets/custom_pin_numpad.dart';
import 'package:flutter_application_1/features/navigation/presentation/pages/bottom_nav.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EnterPinPage extends ConsumerStatefulWidget {
  const EnterPinPage({super.key});

  @override
  ConsumerState<EnterPinPage> createState() => _EnterPinPageState();
}

class _EnterPinPageState extends ConsumerState<EnterPinPage> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  static const int pinLength = 4;

  @override
  void initState() {
    super.initState();
    _loadSavedPin();
  }

  Future<void> _loadSavedPin() async {
    final pin = await ref.read(pinControllerProvider.notifier).loadPin();
    ref.read(enterPinProvider.notifier).setSavedPin(pin);
  }

  void _goToHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const Bottomnav_page()),
      (route) => false,
    );
  }

  void _onConfirmTap() {
    final notifier = ref.read(enterPinProvider.notifier);
    if (ref.read(enterPinProvider).enteredPin.length != pinLength) return;

    if (notifier.checkPin()) {
      _goToHome();
    }
  }

  Future<void> _onBiometricTap() async {
    final notifier = ref.read(enterPinProvider.notifier);
    try {
      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Unlock MoneyMate',
        biometricOnly: true,
      );

      if (didAuthenticate) {
        _goToHome();
      } else {
        notifier.setBiometricError('Biometric authentication failed.');
      }
    } catch (e) {
      notifier.setBiometricError('Biometric authentication error.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final pinState = ref.watch(enterPinProvider);
    final notifier = ref.read(enterPinProvider.notifier);
    final bool isPinComplete = pinState.enteredPin.length == pinLength;

    return Scaffold(
      backgroundColor: Bkcolors.whitecolor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 12),
          
              Image.asset(
                "assets/createlogo.png",
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 16),
          
              const Text(
                'Enter your pin',
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
          
              const SizedBox(height: 16),
          
              TextButton.icon(
                onPressed: _onBiometricTap,
                icon: const Icon(Icons.fingerprint, color: Bkcolors.primarycolor, size: 26),
                label: const Text(
                  'Use fingerprint instead',
                  style: TextStyle(color:  Bkcolors.primarycolor, fontSize: 13),
                ),
              ),
          
              const SizedBox(height: 16,),
          
              PinNumpad(
                onNumberTap: notifier.addDigit,
                onDeleteTap: notifier.deleteDigit,
                onConfirmTap: _onConfirmTap,
                showConfirmButton: isPinComplete,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}