import 'package:flutter/material.dart';

/// A 3x4 numpad (1-9, delete, 0, confirm) matching the light-theme
/// circular button design.
class PinNumpad extends StatelessWidget {
  final ValueChanged<String> onNumberTap;
  final VoidCallback onDeleteTap;
  final VoidCallback? onConfirmTap;
  final bool showConfirmButton;

  const PinNumpad({
    super.key,
    required this.onNumberTap,
    required this.onDeleteTap,
    this.onConfirmTap,
    this.showConfirmButton = false,
  });

  static const Color _purple = Color(0xFF6F3DFF);

  @override
  Widget build(BuildContext context) {
    final List<String> keys = [
      '1', '2', '3',
      '4', '5', '6',
      '7', '8', '9',
      'del', '0', 'confirm',
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 32),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemCount: keys.length,
      itemBuilder: (context, index) {
        final String key = keys[index];

        if (key == 'del') {
          return _CircleButton(
            backgroundColor: Colors.white,
            onTap: onDeleteTap,
            child: const Icon(Icons.backspace_outlined, color: _purple, size: 20),
          );
        }

        if (key == 'confirm') {
          // Only show the confirm button once PIN is complete;
          // otherwise leave the slot empty.
          if (!showConfirmButton) return const SizedBox.shrink();
          return _CircleButton(
            backgroundColor: _purple,
            onTap: onConfirmTap ?? () {},
            child: const Icon(Icons.check, color: Colors.white, size: 22),
          );
        }

        return _CircleButton(
          backgroundColor: Colors.white,
          onTap: () => onNumberTap(key),
          child: Text(
            key,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      },
    );
  }
}

class _CircleButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final Color backgroundColor;

  const _CircleButton({
    required this.child,
    required this.onTap,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      shape: const CircleBorder(),
      elevation: 2,
      shadowColor: Colors.black26,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Center(child: child),
      ),
    );
  }
}