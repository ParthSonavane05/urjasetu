import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_values.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    if (isOutlined) {
      return SizedBox(
        width: double.infinity,
        height: AppValues.buttonHeight,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.primary, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppValues.radiusLg),
            ),
          ),
          child: _buildChild(context, AppColors.primary),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: AppValues.buttonHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: _buildChild(context, AppColors.textLight),
      ),
    );
  }

  Widget _buildChild(BuildContext context, Color color) {
    if (isLoading) {
      return SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: color,
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: AppValues.iconMd),
          const SizedBox(width: AppValues.paddingSm),
          Text(label),
        ],
      );
    }

    return Text(label);
  }
}
