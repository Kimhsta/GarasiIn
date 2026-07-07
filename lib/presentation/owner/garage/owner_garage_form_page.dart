import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../data/models/garage_model.dart';
import '../../../presentation/owner/controllers/owner_garage_controller.dart';

class OwnerGarageFormPage extends StatefulWidget {
  final bool isEdit;

  const OwnerGarageFormPage({super.key, required this.isEdit});

  @override
  State<OwnerGarageFormPage> createState() => _OwnerGarageFormPageState();
}

class _OwnerGarageFormPageState extends State<OwnerGarageFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _addressCtrl;
  late TextEditingController _cityCtrl;
  late TextEditingController _lengthCtrl;
  late TextEditingController _widthCtrl;
  late TextEditingController _priceCtrl;
  late TextEditingController _accessCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _facilityCtrl;
  List<String> _facilities = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final garage =
        widget.isEdit ? Get.arguments as GarageModel? : null;

    _nameCtrl = TextEditingController(text: garage?.name ?? '');
    _addressCtrl = TextEditingController(text: garage?.address ?? '');
    _cityCtrl = TextEditingController(text: garage?.city ?? '');
    _lengthCtrl =
        TextEditingController(text: garage?.length.toString() ?? '');
    _widthCtrl =
        TextEditingController(text: garage?.width.toString() ?? '');
    _priceCtrl = TextEditingController(
        text: garage?.pricePerMonth.toString() ?? '');
    _accessCtrl =
        TextEditingController(text: garage?.roadAccess ?? '');
    _descCtrl =
        TextEditingController(text: garage?.description ?? '');
    _facilityCtrl = TextEditingController();
    _facilities = List<String>.from(garage?.facilities ?? []);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    _lengthCtrl.dispose();
    _widthCtrl.dispose();
    _priceCtrl.dispose();
    _accessCtrl.dispose();
    _descCtrl.dispose();
    _facilityCtrl.dispose();
    super.dispose();
  }

  void _addFacility() {
    final text = _facilityCtrl.text.trim();
    if (text.isEmpty) return;
    if (_facilities.contains(text)) {
      Get.snackbar('Perhatian', 'Fasilitas "$text" sudah ditambahkan',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    setState(() {
      _facilities.add(text);
      _facilityCtrl.clear();
    });
  }

  void _removeFacility(int index) {
    setState(() {
      _facilities.removeAt(index);
    });
  }

  void _onSave() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final garageCtrl = Get.find<OwnerGarageController>();
    bool success;

    if (widget.isEdit) {
      final garage = Get.arguments as GarageModel?;
      success = await garageCtrl.updateGarage(
        id: garage?.id ?? 0,
        name: _nameCtrl.text,
        address: _addressCtrl.text,
        city: _cityCtrl.text,
        length: double.tryParse(_lengthCtrl.text) ?? 0,
        width: double.tryParse(_widthCtrl.text) ?? 0,
        pricePerMonth: int.tryParse(_priceCtrl.text) ?? 0,
        roadAccess: _accessCtrl.text,
        description: _descCtrl.text,
        facilities: _facilities,
        imagePath: garage?.imagePath,
      );
    } else {
      success = await garageCtrl.createGarage(
        name: _nameCtrl.text,
        address: _addressCtrl.text,
        city: _cityCtrl.text,
        length: double.tryParse(_lengthCtrl.text) ?? 0,
        width: double.tryParse(_widthCtrl.text) ?? 0,
        pricePerMonth: int.tryParse(_priceCtrl.text) ?? 0,
        roadAccess: _accessCtrl.text,
        description: _descCtrl.text,
        facilities: _facilities,
      );
    }

    setState(() => _isLoading = false);
    if (success) {
      Get.back();
      Get.snackbar(
        'Berhasil',
        widget.isEdit
            ? 'Garasi berhasil diperbarui'
            : 'Garasi berhasil ditambahkan',
        backgroundColor: AppColors.success.withValues(alpha: 0.1),
        colorText: AppColors.success,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.isEdit ? 'Edit Garasi' : 'Tambah Garasi'),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Iconsax.arrow_left, size: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo Upload Area
              _buildPhotoUpload(),

              const SizedBox(height: 24),

              Text('Informasi Garasi', style: AppTextStyles.headingSmall),
              const SizedBox(height: 16),

              AppTextField(
                label: 'Nama Garasi',
                hint: 'Misal: Garasi Rumah Pak Budi',
                controller: _nameCtrl,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Nama garasi wajib diisi' : null,
              ),
              const SizedBox(height: 14),

              AppTextField(
                label: 'Alamat Lengkap',
                hint: 'Jl. Melati No. 10',
                controller: _addressCtrl,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Alamat wajib diisi' : null,
              ),
              const SizedBox(height: 14),

              AppTextField(
                label: 'Kota',
                hint: 'Solo',
                controller: _cityCtrl,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Kota wajib diisi' : null,
              ),
              const SizedBox(height: 14),

              Text('Dimensi Garasi', style: AppTextStyles.headingSmall),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      label: 'Panjang (m)',
                      hint: '5.0',
                      controller: _lengthCtrl,
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Wajib diisi' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppTextField(
                      label: 'Lebar (m)',
                      hint: '3.0',
                      controller: _widthCtrl,
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Wajib diisi' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              AppTextField(
                label: 'Harga Sewa per Bulan (Rp)',
                hint: '500000',
                controller: _priceCtrl,
                keyboardType: TextInputType.number,
                prefixIcon: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14),
                  child: Text('Rp',
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500)),
                ),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Harga wajib diisi' : null,
              ),
              const SizedBox(height: 14),

              AppTextField(
                label: 'Kondisi Akses Jalan',
                hint: 'Misal: Jalan 2 jalur, mudah dilalui',
                controller: _accessCtrl,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Akses jalan wajib diisi' : null,
              ),
              const SizedBox(height: 14),

              AppTextField(
                label: 'Deskripsi',
                hint: 'Deskripsikan kondisi garasi, keunggulan, dll.',
                controller: _descCtrl,
                maxLines: 4,
              ),

              const SizedBox(height: 20),

              Text('Fasilitas Garasi', style: AppTextStyles.headingSmall),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      label: '',
                      hint: 'Misal: CCTV, Pagar, Lampu',
                      controller: _facilityCtrl,
                      prefixIcon: const Icon(Iconsax.tick_circle,
                          size: 18, color: AppColors.textSecondary),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _addFacility,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.add,
                          color: Colors.white, size: 22),
                    ),
                  ),
                ],
              ),

              if (_facilities.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(_facilities.length, (index) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.07),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color:
                                AppColors.primary.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.check_circle_outline,
                              size: 13, color: AppColors.primary),
                          const SizedBox(width: 5),
                          Text(_facilities[index],
                              style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              )),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: () => _removeFacility(index),
                            child: const Icon(Icons.close,
                                size: 14, color: AppColors.danger),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ],

              const SizedBox(height: 28),

              AppButton(
                label: widget.isEdit ? 'Simpan Perubahan' : 'Tambah Garasi',
                isLoading: _isLoading,
                onTap: _onSave,
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoUpload() {
    final garageCtrl = Get.find<OwnerGarageController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Foto Garasi', style: AppTextStyles.labelMedium.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
          fontSize: 13,
        )),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            try {
              await garageCtrl.pickGarageImage();
              setState(() {});
            } catch (e) {
              Get.snackbar('Error', 'Gagal membuka galeri: $e',
                  snackPosition: SnackPosition.BOTTOM);
            }
          },
          child: Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.softSurface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.border,
                style: BorderStyle.solid,
              ),
            ),
            child: Obx(() {
              final imgPath = garageCtrl.selectedImagePath.value;
              if (imgPath != null) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.file(
                        File(imgPath),
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Center(
                          child: Icon(Icons.broken_image_outlined,
                              size: 48, color: AppColors.textSecondary),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.edit, size: 13, color: Colors.white),
                            SizedBox(width: 4),
                            Text('Ganti Foto',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
              if (widget.isEdit) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        color: AppColors.accent.withValues(alpha: 0.3),
                        child: const Icon(
                          Icons.garage_rounded,
                          size: 64,
                          color: AppColors.accent,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.edit, size: 13, color: Colors.white),
                            SizedBox(width: 4),
                            Text('Ganti Foto',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate_outlined,
                      size: 36, color: AppColors.textSecondary),
                  SizedBox(height: 8),
                  Text('Unggah Foto Garasi',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      )),
                  SizedBox(height: 4),
                  Text('Tap untuk pilih foto',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      )),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}
