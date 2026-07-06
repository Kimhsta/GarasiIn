import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../app/theme/app_colors.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/app_button.dart';
import '../../presentation/profile/controllers/profile_controller.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _oldPassCtrl = TextEditingController();
  final _newPassCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _oldPassCtrl.dispose();
    _newPassCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  void _onSave() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final profileCtrl = Get.find<ProfileController>();
    final success = await profileCtrl.changePassword(
      _oldPassCtrl.text,
      _newPassCtrl.text,
    );
    setState(() => _isLoading = false);
    if (success) {
      Get.back();
      Get.snackbar(
        'Berhasil',
        'Password berhasil diubah',
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
        title: const Text('Ubah Password'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Iconsax.lock_1,
                  size: 32,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Masukkan password lama dan password baru Anda',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              AppTextField(
                label: 'Password Lama',
                hint: 'Masukkan password lama',
                controller: _oldPassCtrl,
                obscureText: _obscureOld,
                prefixIcon: const Icon(Iconsax.lock,
                    size: 18, color: AppColors.textSecondary),
                suffixIcon: GestureDetector(
                  onTap: () => setState(() => _obscureOld = !_obscureOld),
                  child: Icon(
                    _obscureOld
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                ),
                validator: (v) => (v == null || v.isEmpty)
                    ? 'Password lama wajib diisi'
                    : null,
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Password Baru',
                hint: 'Masukkan password baru',
                controller: _newPassCtrl,
                obscureText: _obscureNew,
                prefixIcon: const Icon(Iconsax.lock,
                    size: 18, color: AppColors.textSecondary),
                suffixIcon: GestureDetector(
                  onTap: () => setState(() => _obscureNew = !_obscureNew),
                  child: Icon(
                    _obscureNew
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Password baru wajib diisi';
                  if (v.length < 6) return 'Password minimal 6 karakter';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Konfirmasi Password',
                hint: 'Masukkan ulang password baru',
                controller: _confirmPassCtrl,
                obscureText: _obscureConfirm,
                prefixIcon: const Icon(Iconsax.lock,
                    size: 18, color: AppColors.textSecondary),
                suffixIcon: GestureDetector(
                  onTap: () =>
                      setState(() => _obscureConfirm = !_obscureConfirm),
                  child: Icon(
                    _obscureConfirm
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return 'Konfirmasi password wajib diisi';
                  }
                  if (v != _newPassCtrl.text) {
                    return 'Password tidak cocok';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              AppButton(
                label: 'Simpan Password',
                isLoading: _isLoading,
                onTap: _onSave,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
