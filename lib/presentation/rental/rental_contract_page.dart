import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/routes/app_routes.dart';
import '../../core/widgets/app_button.dart';
import '../../data/models/garage_model.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/contract_repository.dart';
import '../../presentation/auth/controllers/auth_controller.dart';
import '../../data/repositories/user_repository.dart';

class RentalContractPage extends StatefulWidget {
  const RentalContractPage({super.key});

  @override
  State<RentalContractPage> createState() => _RentalContractPageState();
}

class _RentalContractPageState extends State<RentalContractPage> {
  UserModel? _owner;
  bool _isLoadingOwner = true;

  @override
  void initState() {
    super.initState();
    _loadOwner();
  }

  Future<void> _loadOwner() async {
    final args = Get.arguments as Map<String, dynamic>;
    final garage = args['garage'] as GarageModel;
    final owner = await UserRepository().getUserById(garage.ownerId);
    if (mounted) {
      setState(() {
        _owner = owner;
        _isLoadingOwner = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>;
    final garage = args['garage'] as GarageModel;
    final startDate = args['startDate'] as DateTime;
    final endDate = args['endDate'] as DateTime;
    final total = args['total'] as int;
    final note = args['note'] as String? ?? '';

    final priceFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    final dateFormat = DateFormat('d MMMM yyyy', 'id_ID');
    final authCtrl = Get.find<AuthController>();
    final renter = authCtrl.currentUser.value;
    if (renter == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final contractNumber = ContractRepository().generateContractNumber();

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
                        Text('No. $contractNumber',
                            style: AppTextStyles.caption),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  _isLoadingOwner
                      ? const Center(child: CircularProgressIndicator())
                      : Column(
                          children: [
                            _SectionCard(
                              title: 'Data Pemilik Garasi',
                              items: {
                                'Nama': _owner?.name ?? '-',
                                'Email': _owner?.email ?? '-',
                                'No. HP': _owner?.phone ?? '-',
                              },
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),

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

          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: const Border(top: BorderSide(color: AppColors.border)),
            ),
            child: AppButton(
              label: 'Lanjut Tanda Tangan',
              onTap: () {
                Get.toNamed(AppRoutes.rentalSignature, arguments: {
                  'garage': garage,
                  'startDate': startDate,
                  'endDate': endDate,
                  'total': total,
                  'note': note.isEmpty ? null : note,
                  'contractNumber': contractNumber,
                  'owner': _owner,
                });
              },
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
