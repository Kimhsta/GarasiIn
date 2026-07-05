import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isLoading;
  final bool isOutline;
  final bool isFullWidth;
  final double? width;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const AppButton({
    super.key,
    required this.label,
    this.onTap,
    this.isLoading = false,
    this.isOutline = false,
    this.isFullWidth = true,
    this.width,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final content = isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: isOutline ? AppColors.primary : Colors.white,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18),
                const SizedBox(width: 8),
              ],
              Text(label, style: AppTextStyles.labelLarge.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: isOutline
                    ? (foregroundColor ?? AppColors.primary)
                    : (foregroundColor ?? Colors.white),
              )),
            ],
          );

    final buttonChild = SizedBox(
      width: isFullWidth ? double.infinity : width,
      child: isOutline
          ? OutlinedButton(
              onPressed: isLoading ? null : onTap,
              style: OutlinedButton.styleFrom(
                foregroundColor: foregroundColor ?? AppColors.primary,
                side: BorderSide(
                  color: foregroundColor ?? AppColors.primary,
                  width: 1.5,
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: content,
            )
          : ElevatedButton(
              onPressed: isLoading ? null : onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor ?? AppColors.primary,
                foregroundColor: foregroundColor ?? Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: content,
            ),
    );

    return buttonChild;
  }
}
