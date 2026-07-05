import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/routes/app_routes.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_status_badge.dart';
import '../../data/dummy/dummy_data.dart';

class GarageDetailPage extends StatelessWidget {
  const GarageDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final GarageModel garage =
        Get.arguments as GarageModel? ?? DummyData.garages.first;

    final priceFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                ),
              ],
            ),
            child: const Icon(Iconsax.arrow_left, size: 20),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Image
                  Container(
                    height: 240,
                    width: double.infinity,
                    color: AppColors.softSurface,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(
                          color: AppColors.accent.withValues(alpha: 0.25),
                          child: const Icon(
                            Icons.garage_rounded,
                            size: 90,
                            color: AppColors.accent,
                          ),
                        ),
                        Positioned(
                          bottom: 12,
                          left: 16,
                          child: AppStatusBadge(garageStatus: garage.status),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name & Price
                        Text(garage.name, style: AppTextStyles.headingLarge),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined,
                                size: 14, color: AppColors.textSecondary),
                            const SizedBox(width: 4),
                            Text(
                              '${garage.address}, ${garage.city}',
                              style: AppTextStyles.bodySmall,
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Text(
                              priceFormat.format(garage.pricePerMonth),
                              style: AppTextStyles.priceLarge,
                            ),
                            Text(' / bulan',
                                style: AppTextStyles.bodySmall),
                          ],
                        ),

                        const SizedBox(height: 20),
                        const Divider(),
                        const SizedBox(height: 16),

                        // Dimensions
                        Text('Dimensi Carport',
                            style: AppTextStyles.headingSmall),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _DimCard(
                              label: 'Panjang',
                              value: '${garage.length} m',
                              icon: Iconsax.ruler,
                            ),
                            const SizedBox(width: 10),
                            _DimCard(
                              label: 'Lebar',
                              value: '${garage.width} m',
                              icon: Iconsax.ruler,
                            ),
                            const SizedBox(width: 10),
                            _DimCard(
                              label: 'Luas',
                              value:
                                  '${(garage.length * garage.width).toStringAsFixed(1)} m²',
                              icon: Iconsax.grid_1,
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Road Access
                        Text('Akses Jalan', style: AppTextStyles.headingSmall),
                        const SizedBox(height: 6),
                        Text(garage.roadAccess,
                            style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondary)),

                        const SizedBox(height: 20),

                        // Description
                        Text('Deskripsi', style: AppTextStyles.headingSmall),
                        const SizedBox(height: 6),
                        Text(garage.description,
                            style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondary)),

                        const SizedBox(height: 20),

                        // Facilities
                        Text('Fasilitas', style: AppTextStyles.headingSmall),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: garage.facilities
                              .map((f) => _FacilityBadge(label: f))
                              .toList(),
                        ),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Sticky Bottom
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: const Border(top: BorderSide(color: AppColors.border)),
            ),
            child: AppButton(
              label: 'Ajukan Sewa',
              onTap: garage.status == GarageStatus.available
                  ? () => Get.toNamed(AppRoutes.rentalApply, arguments: garage)
                  : null,
              backgroundColor: garage.status == GarageStatus.available
                  ? AppColors.primary
                  : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _DimCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _DimCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: AppColors.softSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Icon(icon, size: 16, color: AppColors.primary),
            const SizedBox(height: 6),
            Text(value,
                style: AppTextStyles.labelLarge.copyWith(fontSize: 13)),
            const SizedBox(height: 2),
            Text(label, style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }
}

class _FacilityBadge extends StatelessWidget {
  final String label;

  const _FacilityBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle_outline,
              size: 13, color: AppColors.primary),
          const SizedBox(width: 5),
          Text(label,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              )),
        ],
      ),
    );
  }
}
