import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../data/dummy/dummy_data.dart';

class AppStatusBadge extends StatelessWidget {
  final BookingStatus? bookingStatus;
  final GarageStatus? garageStatus;
  final String? customLabel;
  final Color? customColor;

  const AppStatusBadge({
    super.key,
    this.bookingStatus,
    this.garageStatus,
    this.customLabel,
    this.customColor,
  });

  @override
  Widget build(BuildContext context) {
    String label;
    Color color;
    Color bg;

    if (customLabel != null) {
      label = customLabel!;
      color = customColor ?? AppColors.primary;
      bg = (customColor ?? AppColors.primary).withValues(alpha: 0.1);
    } else if (bookingStatus != null) {
      switch (bookingStatus!) {
        case BookingStatus.pending:
          label = 'Menunggu';
          color = AppColors.warning;
          bg = AppColors.warning.withValues(alpha: 0.1);
          break;
        case BookingStatus.accepted:
          label = 'Diterima';
          color = AppColors.success;
          bg = AppColors.success.withValues(alpha: 0.1);
          break;
        case BookingStatus.rejected:
          label = 'Ditolak';
          color = AppColors.danger;
          bg = AppColors.danger.withValues(alpha: 0.1);
          break;
      }
    } else if (garageStatus != null) {
      switch (garageStatus!) {
        case GarageStatus.available:
          label = 'Tersedia';
          color = AppColors.success;
          bg = AppColors.success.withValues(alpha: 0.1);
          break;
        case GarageStatus.rented:
          label = 'Disewa';
          color = AppColors.warning;
          bg = AppColors.warning.withValues(alpha: 0.1);
          break;
      }
    } else {
      label = '-';
      color = AppColors.textSecondary;
      bg = AppColors.softSurface;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
      ),
    );
  }
}
