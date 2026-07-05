import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:signature/signature.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/routes/app_routes.dart';
import '../../core/widgets/app_button.dart';

class RentalSignaturePage extends StatefulWidget {
  const RentalSignaturePage({super.key});

  @override
  State<RentalSignaturePage> createState() => _RentalSignaturePageState();
}

class _RentalSignaturePageState extends State<RentalSignaturePage> {
  late final SignatureController _signatureCtrl;
  bool _hasSigned = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _signatureCtrl = SignatureController(
      penStrokeWidth: 2.5,
      penColor: AppColors.primaryDark,
      exportBackgroundColor: Colors.white,
    );
    _signatureCtrl.addListener(() {
      if (_signatureCtrl.isNotEmpty && !_hasSigned) {
        setState(() => _hasSigned = true);
      }
    });
  }

  @override
  void dispose() {
    _signatureCtrl.dispose();
    super.dispose();
  }

  void _onClear() {
    _signatureCtrl.clear();
    setState(() => _hasSigned = false);
  }

  void _onSubmit() async {
    if (!_hasSigned) {
      Get.snackbar(
        'Perhatian',
        'Silakan buat tanda tangan terlebih dahulu',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);

    Get.offAllNamed(AppRoutes.renterHome);
    Get.snackbar(
      'Berhasil',
      'Pengajuan sewa berhasil dikirim! Tunggu konfirmasi pemilik.',
      backgroundColor: AppColors.success.withValues(alpha: 0.1),
      colorText: AppColors.success,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 4),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  // Info
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
                  Text('Andi Pratama', style: AppTextStyles.bodySmall),

                  const SizedBox(height: 14),

                  // Signature Area
                  Container(
                    height: 220,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _hasSigned
                            ? AppColors.primary
                            : AppColors.border,
                        width: _hasSigned ? 1.5 : 1,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        Signature(
                          controller: _signatureCtrl,
                          backgroundColor: Colors.white,
                        ),
                        if (!_hasSigned)
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
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Clear button
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: _onClear,
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

                  // Status indicator
                  if (_hasSigned)
                    Container(
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
                    ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          // Sticky bottom
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: const Border(top: BorderSide(color: AppColors.border)),
            ),
            child: AppButton(
              label: 'Kirim Pengajuan',
              isLoading: _isLoading,
              onTap: _onSubmit,
            ),
          ),
        ],
      ),
    );
  }
}
