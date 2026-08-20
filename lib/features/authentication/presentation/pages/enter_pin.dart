import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/colors.dart';
import 'package:flutter_application_1/features/authentication/controllers/enter_pinnotifier.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_application_1/features/authentication/datasources/login_service.dart';
import 'package:flutter_application_1/features/authentication/models/login_model.dart';

import 'package:flutter_application_1/features/authentication/widgets/custom_pin_dot_indicator.dart';
import 'package:flutter_application_1/features/authentication/widgets/custom_pin_numpad.dart';
import 'package:flutter_application_1/features/navigation/presentation/pages/bottom_nav.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EnterPinPage extends ConsumerStatefulWidget {
  final String email;
  final String password;

  const EnterPinPage({
    super.key,
    required this.email,
    required this.password,
  });

  @override
  ConsumerState<EnterPinPage> createState() => _EnterPinPageState();
}

class _EnterPinPageState extends ConsumerState<EnterPinPage> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  static const int pinLength = 6;
  bool _isLoading = false;
  String? _loginError;

  void _goToHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const Bottomnav_page()),
      (route) => false,
    );
  }
      
      Future<void> _onConfirmTap() async {
  final notifier = ref.read(enterPinProvider.notifier);
  final enteredPin = ref.read(enterPinProvider).enteredPin;

  if (enteredPin.length != pinLength) return;

  setState(() {
    _isLoading = true;
    _loginError = null;
  });

  final loginModel = Loginmodel(
    email: widget.email,
    password: widget.password,
    pin: enteredPin,
  );

  final success = await Loginservice().loginpost(loginModel);

  if (!mounted) return;

  setState(() {
    _isLoading = false;
  });

  if (success) {
    notifier.clearPin();
    _goToHome();
  } else {
    setState(() {
      _loginError = "Invalid PIN. Please try again.";
    });

    notifier.clearPin();
  }
} 

  Future<void> _onBiometricTap() async {
    try {
      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Unlock MoneyMate',
        biometricOnly: true,
      );

      if (didAuthenticate) {
        _goToHome();
      } else {
        setState(() {
          _loginError = 'Biometric authentication failed.';
        });
      }
    } catch (e) {
      setState(() {
        _loginError = 'Biometric authentication error.';
      });
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

              if (_loginError != null) ...[
                const SizedBox(height: 12),
                Text(
                  _loginError!,
                  style: const TextStyle(
                    color: Bkcolors.redcolor,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],

              const SizedBox(height: 16),

              TextButton.icon(
                onPressed: _isLoading ? null : _onBiometricTap,
                icon: const Icon(
                  Icons.fingerprint,
                  color: Bkcolors.primarycolor,
                  size: 26,
                ),
                label: const Text(
                  'Use fingerprint instead',
                  style: TextStyle(color: Bkcolors.primarycolor, fontSize: 13),
                ),
              ),

              const SizedBox(height: 16),

              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: CircularProgressIndicator(),
                )
              else
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