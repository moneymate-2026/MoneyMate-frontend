import 'package:flutter/material.dart';

/// Shows a row of dots representing PIN length.
/// Filled dots = digits entered, empty dots = digits remaining.
class PinDotIndicator extends StatelessWidget {
  final int pinLength;
  final int enteredLength;

  const PinDotIndicator({
    super.key,
    required this.pinLength,
    required this.enteredLength,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pinLength, (index) {
        final bool isFilled = index < enteredLength;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isFilled
                ? const Color(0xFF7B2FF7) // filled purple
                : Colors.transparent,
            border: Border.all(
              color: const Color(0xFF7B2FF7),
              width: 1.5,
            ),
          ),
        );
      }),
    );
  }
}