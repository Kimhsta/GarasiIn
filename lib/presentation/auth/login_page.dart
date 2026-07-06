import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/routes/app_routes.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../auth/controllers/auth_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscurePass = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (!_formKey.currentState!.validate()) return;
    final authCtrl = Get.find<AuthController>();
    authCtrl.login(_emailCtrl.text.trim(), _passCtrl.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 48),
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Icon(Icons.garage_rounded,
                            color: Colors.white, size: 34),
                      ),
                      const SizedBox(height: 12),
                      Text('GarasiIn',
                          style: AppTextStyles.headingLarge.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800,
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Text('Masuk ke GarasiIn', style: AppTextStyles.displayMedium),
                const SizedBox(height: 6),
                Text(
                  'Kelola dan temukan garasi dengan mudah',
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 32),
                AppTextField(
                  label: 'Email',
                  hint: 'Masukkan email Anda',
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.mail_outline_rounded,
                      size: 18, color: AppColors.textSecondary),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Email wajib diisi' : null,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Password',
                  hint: 'Masukkan password',
                  controller: _passCtrl,
                  obscureText: _obscurePass,
                  prefixIcon: const Icon(Icons.lock_outline_rounded,
                      size: 18, color: AppColors.textSecondary),
                  suffixIcon: GestureDetector(
                    onTap: () =>
                        setState(() => _obscurePass = !_obscurePass),
                    child: Icon(
                      _obscurePass
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 18,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Password wajib diisi' : null,
                ),
                const SizedBox(height: 28),
                GetX<AuthController>(
                  builder: (ctrl) => AppButton(
                    label: 'Masuk',
                    isLoading: ctrl.isLoading.value,
                    onTap: _onLogin,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.softSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Akun Demo:',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          )),
                      const SizedBox(height: 4),
                      Text('Pemilik: pemilik@gmail.com / 123456',
                          style: AppTextStyles.caption),
                      Text('Penyewa: penyewa@gmail.com / 123456',
                          style: AppTextStyles.caption),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Belum punya akun? ',
                        style: AppTextStyles.bodySmall),
                    GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.register),
                      child: Text('Daftar Akun',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          )),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
