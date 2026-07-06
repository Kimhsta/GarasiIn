import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/routes/app_routes.dart';
import '../../data/models/garage_model.dart';
import 'app_status_badge.dart';

class GarageCard extends StatelessWidget {
  final GarageModel garage;
  final bool showEditButton;
  final bool isCompact;

  const GarageCard({
    super.key,
    required this.garage,
    this.showEditButton = false,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );

    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.garageDetail, arguments: garage),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Stack(
              children: [
                Container(
                  height: isCompact ? 110 : 140,
                  width: double.infinity,
                  color: AppColors.softSurface,
                  child: Center(
                    child: Icon(
                      Icons.garage_rounded,
                      size: isCompact ? 40 : 52,
                      color: AppColors.accent,
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: AppStatusBadge(
                    customLabel: garage.isAvailable ? 'Tersedia' : 'Disewa',
                    customColor: garage.isAvailable ? AppColors.success : AppColors.warning,
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          garage.name,
                          style: AppTextStyles.headingSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (showEditButton)
                        GestureDetector(
                          onTap: () => Get.toNamed(
                            AppRoutes.ownerGarageEdit,
                            arguments: garage,
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.softSurface,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.edit_outlined,
                              size: 16,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 13,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          '${garage.address}, ${garage.city}',
                          style: AppTextStyles.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        '${garage.length}m × ${garage.width}m',
                        style: AppTextStyles.caption,
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 3,
                        height: 3,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        formatter.format(garage.pricePerMonth),
                        style: AppTextStyles.price.copyWith(fontSize: 13),
                      ),
                      Text(
                        '/bln',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
