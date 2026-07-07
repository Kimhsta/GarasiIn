import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/routes/app_routes.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../data/models/garage_model.dart';

class RentalApplyPage extends StatefulWidget {
  const RentalApplyPage({super.key});

  @override
  State<RentalApplyPage> createState() => _RentalApplyPageState();
}

class _RentalApplyPageState extends State<RentalApplyPage> {
  final _noteCtrl = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isLoading = false;

  final _priceFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );
  final _dateFormat = DateFormat('d MMMM yyyy', 'id_ID');

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate(bool isStart) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? now : (_startDate ?? now),
      firstDate: isStart ? now : (_startDate ?? now),
      lastDate: DateTime(now.year + 2),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.primary,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate != null && _endDate!.isBefore(picked)) {
            _endDate = null;
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  int get _totalMonths {
    if (_startDate == null || _endDate == null) return 0;
    final diff = _endDate!.difference(_startDate!).inDays;
    if (diff <= 0) return 0;
    return (diff / 30).ceil().clamp(1, 120);
  }

  @override
  Widget build(BuildContext context) {
    final GarageModel garage =
        Get.arguments as GarageModel;

    final total = garage.pricePerMonth * (_totalMonths == 0 ? 1 : _totalMonths);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Ajukan Sewa'),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Iconsax.arrow_left, size: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Garage Info (readonly)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.softSurface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.garage_rounded,
                        color: AppColors.accent, size: 26),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(garage.name,
                            style: AppTextStyles.headingSmall),
                        const SizedBox(height: 2),
                        Text('${garage.address}, ${garage.city}',
                            style: AppTextStyles.caption),
                        const SizedBox(height: 4),
                        Text(
                          '${_priceFormat.format(garage.pricePerMonth)} / bulan',
                          style: AppTextStyles.price.copyWith(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            Text('Periode Sewa', style: AppTextStyles.headingSmall),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _DatePickerField(
                    label: 'Tanggal Mulai',
                    value: _startDate != null
                        ? _dateFormat.format(_startDate!)
                        : null,
                    onTap: () => _pickDate(true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _DatePickerField(
                    label: 'Tanggal Selesai',
                    value: _endDate != null
                        ? _dateFormat.format(_endDate!)
                        : null,
                    onTap: () => _pickDate(false),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            AppTextField(
              label: 'Catatan untuk Pemilik',
              hint: 'Misal: saya ingin menyewa 1 bulan dulu...',
              controller: _noteCtrl,
              maxLines: 3,
            ),

            const SizedBox(height: 24),

            // Ringkasan Harga
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _SummaryRow(
                    label: 'Harga per bulan',
                    value: _priceFormat.format(garage.pricePerMonth),
                  ),
                  const SizedBox(height: 8),
                  _SummaryRow(
                    label: 'Durasi',
                    value: _totalMonths > 0 ? '$_totalMonths bulan' : '-',
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total', style: AppTextStyles.headingSmall),
                      Text(
                        _totalMonths > 0 ? _priceFormat.format(total) : '-',
                        style: AppTextStyles.priceLarge,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            AppButton(
              label: 'Lanjut ke Kontrak',
              isLoading: _isLoading,
              onTap: () {
                if (_startDate == null || _endDate == null) {
                  Get.snackbar('Perhatian', 'Pilih tanggal sewa terlebih dahulu',
                      snackPosition: SnackPosition.BOTTOM);
                  return;
                }
                if (_endDate!.isBefore(_startDate!) || _endDate!.isAtSameMomentAs(_startDate!)) {
                  Get.snackbar('Perhatian', 'Tanggal selesai harus setelah tanggal mulai',
                      snackPosition: SnackPosition.BOTTOM);
                  return;
                }
                Get.toNamed(AppRoutes.rentalContract, arguments: {
                  'garage': garage,
                  'startDate': _startDate,
                  'endDate': _endDate,
                  'total': total,
                  'note': _noteCtrl.text,
                });
              },
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _DatePickerField extends StatelessWidget {
  final String label;
  final String? value;
  final VoidCallback onTap;

  const _DatePickerField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.labelMedium.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
          fontSize: 13,
        )),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            decoration: BoxDecoration(
              color: AppColors.softSurface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const Icon(Iconsax.calendar_1,
                    size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    value ?? 'Pilih tanggal',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: value != null
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodySmall),
        Text(value,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            )),
      ],
    );
  }
}
