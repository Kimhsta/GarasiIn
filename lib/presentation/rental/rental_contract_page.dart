import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/routes/app_routes.dart';
import '../../core/widgets/app_button.dart';
import '../../data/dummy/dummy_data.dart';

class RentalContractPage extends StatelessWidget {
  const RentalContractPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final GarageModel garage =
        args?['garage'] as GarageModel? ?? DummyData.garages.first;
    final DateTime startDate =
        args?['startDate'] as DateTime? ?? DateTime(2024, 7, 1);
    final DateTime endDate =
        args?['endDate'] as DateTime? ?? DateTime(2024, 7, 31);
    final int total = args?['total'] as int? ?? garage.pricePerMonth;
    final String note = args?['note'] as String? ?? '';

    final priceFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    final dateFormat = DateFormat('d MMMM yyyy', 'id_ID');
    final owner = DummyData.ownerUser;
    final renter = DummyData.renterUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Kontrak Sewa'),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Iconsax.arrow_left, size: 20),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.description_outlined,
                              size: 30, color: AppColors.primary),
                        ),
                        const SizedBox(height: 12),
                        Text('Kontrak Sewa Garasi',
                            style: AppTextStyles.headingMedium),
                        const SizedBox(height: 4),
                        Text(
                          'No. KTR-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  _SectionCard(
                    title: 'Data Pemilik Garasi',
                    items: {
                      'Nama': owner.name,
                      'Email': owner.email,
                      'No. HP': owner.phone,
                    },
                  ),
                  const SizedBox(height: 12),

                  _SectionCard(
                    title: 'Data Penyewa',
                    items: {
                      'Nama': renter.name,
                      'Email': renter.email,
                      'No. HP': renter.phone,
                    },
                  ),
                  const SizedBox(height: 12),

                  _SectionCard(
                    title: 'Informasi Garasi',
                    items: {
                      'Nama Garasi': garage.name,
                      'Alamat': '${garage.address}, ${garage.city}',
                      'Ukuran': '${garage.length}m × ${garage.width}m',
                    },
                  ),
                  const SizedBox(height: 12),

                  _SectionCard(
                    title: 'Periode & Pembayaran',
                    items: {
                      'Mulai Sewa': dateFormat.format(startDate),
                      'Selesai Sewa': dateFormat.format(endDate),
                      'Total Biaya': priceFormat.format(total),
                    },
                  ),

                  if (note.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _SectionCard(
                      title: 'Catatan',
                      items: {'': note},
                    ),
                  ],

                  const SizedBox(height: 20),

                  // Isi kontrak singkat
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.softSurface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Syarat & Ketentuan',
                            style: AppTextStyles.headingSmall),
                        const SizedBox(height: 10),
                        ...[
                          'Penyewa wajib merawat dan menjaga kebersihan garasi selama masa sewa.',
                          'Penyewa tidak diperkenankan menyewakan kembali garasi kepada pihak lain.',
                          'Pembatalan sewa harus disampaikan minimal 7 hari sebelumnya.',
                          'Pemilik garasi berhak meninjau kondisi garasi setiap bulan.',
                          'Keterlambatan pembayaran dikenakan denda sesuai kesepakatan.',
                        ].map((s) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.circle,
                                      size: 5, color: AppColors.textSecondary),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(s,
                                        style: AppTextStyles.bodySmall
                                            .copyWith(fontSize: 12)),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          // Sticky Button
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: const Border(top: BorderSide(color: AppColors.border)),
            ),
            child: AppButton(
              label: 'Lanjut Tanda Tangan',
              onTap: () => Get.toNamed(AppRoutes.rentalSignature),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Map<String, String> items;

  const _SectionCard({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.labelLarge),
          const SizedBox(height: 10),
          ...items.entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (e.key.isNotEmpty) ...[
                      SizedBox(
                        width: 100,
                        child: Text(e.key, style: AppTextStyles.caption),
                      ),
                      Text(': ', style: AppTextStyles.caption),
                    ],
                    Expanded(
                      child: Text(
                        e.value,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
