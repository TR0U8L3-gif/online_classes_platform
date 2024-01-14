import 'package:flutter/material.dart';
import 'package:online_classes_platform/config/assets/app_colors.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({required this.label, required this.onPressed, super.key});

  final String label;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: 48,
          vertical: 18,
        ),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
    );
  }
}
