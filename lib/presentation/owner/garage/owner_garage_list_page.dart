import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/garage_card.dart';
import '../../../data/dummy/dummy_data.dart';

class OwnerGarageListPage extends StatelessWidget {
  const OwnerGarageListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final garages = DummyData.ownerGarages;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Garasi Saya'),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Iconsax.arrow_left, size: 20),
        ),
      ),
      body: garages.isEmpty
          ? _buildEmpty()
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: garages.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) => GarageCard(
                garage: garages[i],
                showEditButton: true,
              ),
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: AppButton(
          label: 'Tambah Garasi Baru',
          icon: Icons.add,
          onTap: () => Get.toNamed(AppRoutes.ownerGarageAdd),
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.softSurface,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.garage_outlined,
                size: 36, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          Text('Belum ada garasi', style: AppTextStyles.headingSmall),
          const SizedBox(height: 6),
          Text(
            'Tambah garasi pertama Anda sekarang',
            style: AppTextStyles.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
