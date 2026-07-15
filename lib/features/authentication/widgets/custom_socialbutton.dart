import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {
  final String label;
  final Widget icon;
  final VoidCallback onPressed;

  const SocialLoginButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(55),
          backgroundColor: Colors.white,
          side: BorderSide.none,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        onPressed: onPressed,
        icon: icon,
        label: Text(label, style: const TextStyle(color: Colors.black87)),
      ),
    );
  }
}