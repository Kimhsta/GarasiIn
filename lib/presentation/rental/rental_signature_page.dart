import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:signature/signature.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/widgets/app_button.dart';
import '../../presentation/rental/controllers/rental_signature_controller.dart';
import '../../presentation/auth/controllers/auth_controller.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/models/garage_model.dart';

class RentalSignaturePage extends StatefulWidget {
  const RentalSignaturePage({super.key});

  @override
  State<RentalSignaturePage> createState() => _RentalSignaturePageState();
}

class _RentalSignaturePageState extends State<RentalSignaturePage> {
  final sigCtrl = Get.find<RentalSignatureController>();
  final authCtrl = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    sigCtrl.signatureController.clear();
    sigCtrl.hasSigned.value = false;
    sigCtrl.isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>;
    final garage = args['garage'] as GarageModel;
    final renter = authCtrl.currentUser.value;
    if (renter == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    final renterName = renter.name;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Tanda Tangan Digital'),
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
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.15)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline,
                            size: 18, color: AppColors.primary),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Tanda tangan di bawah ini sebagai bukti persetujuan kontrak sewa.',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.primary,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  Text('Tanda Tangan Penyewa',
                      style: AppTextStyles.headingSmall),
                  const SizedBox(height: 8),
                  Text(renterName, style: AppTextStyles.bodySmall),

                  const SizedBox(height: 14),

                  Container(
                    height: 220,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: sigCtrl.hasSigned.value
                            ? AppColors.primary
                            : AppColors.border,
                        width: sigCtrl.hasSigned.value ? 1.5 : 1,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Obx(() => Stack(
                      children: [
                        Signature(
                          controller: sigCtrl.signatureController,
                          backgroundColor: Colors.white,
                        ),
                        if (!sigCtrl.hasSigned.value)
                          Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.draw_outlined,
                                    size: 28, color: AppColors.border),
                                const SizedBox(height: 8),
                                Text(
                                  'Tanda tangani di sini',
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.border,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    )),
                  ),

                  const SizedBox(height: 12),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: sigCtrl.clearSignature,
                      icon: const Icon(Icons.refresh_rounded,
                          size: 16, color: AppColors.danger),
                      label: Text('Hapus Tanda Tangan',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.danger,
                            fontSize: 13,
                          )),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Obx(() => sigCtrl.hasSigned.value
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: AppColors.success.withValues(alpha: 0.2)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.check_circle_outline,
                                  size: 16, color: AppColors.success),
                              const SizedBox(width: 6),
                              Text('Tanda tangan tersimpan',
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.success,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ],
                          ),
                        )
                      : const SizedBox.shrink()),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: const Border(top: BorderSide(color: AppColors.border)),
            ),
            child: Obx(() => AppButton(
              label: 'Kirim Pengajuan',
              isLoading: sigCtrl.isLoading.value,
              onTap: () async {
                final owner = await UserRepository().getUserById(garage.ownerId);
                if (owner == null) return;
                await sigCtrl.submitRentalWithContract({
                  'garageId': garage.id!,
                  'ownerId': garage.ownerId,
                  'garageName': garage.name,
                  'garageAddress': '${garage.address}, ${garage.city}',
                  'ownerName': owner.name,
                  'ownerEmail': owner.email,
                  'ownerPhone': owner.phone,
                  'renterName': renter.name,
                  'renterEmail': renter.email,
                  'renterPhone': renter.phone,
                  'startDate': args['startDate'] as DateTime,
                  'endDate': args['endDate'] as DateTime,
                  'totalPrice': args['total'] as int,
                  'note': args['note'] as String?,
                  'contractNumber': args['contractNumber'] as String?,
                });
              },
            )),
          ),
        ],
      ),
    );
  }
}
