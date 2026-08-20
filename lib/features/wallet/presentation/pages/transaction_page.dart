import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/colors.dart';
import 'package:flutter_application_1/features/authentication/controllers/enter_pinnotifier.dart';
import 'package:flutter_application_1/features/authentication/controllers/pin_controller.dart';
import 'package:flutter_application_1/features/authentication/widgets/custom_pin_dot_indicator.dart';
import 'package:flutter_application_1/features/authentication/widgets/custom_pin_numpad.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionPinPage extends ConsumerStatefulWidget {
  const TransactionPinPage({super.key});

  @override
  ConsumerState<TransactionPinPage> createState() =>
      _TransactionPinPageState();
}

class _TransactionPinPageState extends ConsumerState<TransactionPinPage> {
  static const int pinLength = 6;

  bool _isLoading = false;
  String? _error;

  Future<void> _onConfirmTap() async {
    final notifier = ref.read(enterPinProvider.notifier);
    final enteredPin = ref.read(enterPinProvider).enteredPin;

    if (enteredPin.length != pinLength) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final token = await ref
        .read(pinControllerProvider.notifier)
        .verifyPinWithBackend(enteredPin);

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (token != null) {
      notifier.clearPin();

      Navigator.pop(context,token);   
    } else {
      setState(() {
        _error = "Invalid PIN. Please try again.";
      });

      notifier.clearPin();
    }
  }

  @override
  Widget build(BuildContext context) {
    final pinState = ref.watch(enterPinProvider);
    final notifier = ref.read(enterPinProvider.notifier);

    final bool isPinComplete =
        pinState.enteredPin.length == pinLength;

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/rintbg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 95),

              const Text(
                "Enter Transaction PIN",
                style: TextStyle(
                  color: Bkcolors.themetext,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 45),

              PinDotIndicator(
                pinLength: pinLength,
                enteredLength: pinState.enteredPin.length,
              ),

              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(
                  _error!,
                  style: const TextStyle(
                    color: Bkcolors.redcolor,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],

              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : PinNumpad(
                            onNumberTap: notifier.addDigit,
                            onDeleteTap: notifier.deleteDigit,
                            onConfirmTap: _onConfirmTap,
                            showConfirmButton: isPinComplete,
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}