import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/colors.dart';
import 'package:flutter_application_1/features/authentication/presentation/pages/confirm_pin_page.dart';
import 'package:flutter_application_1/features/authentication/controllers/create_pin_state_controller.dart';
import 'package:flutter_application_1/features/authentication/widgets/custom_pin_dot_indicator.dart';
import 'package:flutter_application_1/features/authentication/widgets/custom_pin_numpad.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreatePinPage extends ConsumerStatefulWidget {
  final String fullName;
  final String phone;
  final String email;
  final String password;

  const CreatePinPage({
    super.key,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.password,
  });

  @override
  ConsumerState<CreatePinPage> createState() => _CreatePinPageState();
}

class _CreatePinPageState extends ConsumerState<CreatePinPage> {
  static const int pinLength = 6;

  void _onConfirmTap() {
    final enteredPin = ref.read(createPinProvider);
    if (enteredPin.length != pinLength) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConfirmPinPage(
          originalPin: enteredPin,
          fullName: widget.fullName,
          phone: widget.phone,
          email: widget.email,
          password: widget.password,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final enteredPin = ref.watch(createPinProvider);
    final notifier = ref.read(createPinProvider.notifier);
    final bool isPinComplete = enteredPin.length == pinLength;

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

            const Text(
              'Create your pin',
              style: TextStyle(
                color: Bkcolors.themetext,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),

            PinDotIndicator(
              pinLength: pinLength,
              enteredLength: enteredPin.length,
            ),

            const Spacer(),

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
    );
  }
}