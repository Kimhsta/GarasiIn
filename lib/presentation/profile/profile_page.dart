import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/routes/app_routes.dart';
import '../../data/dummy/dummy_data.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Detect current "role" from route history - default to renter for demo
    final bool isOwner = Get.previousRoute.contains('owner');
    final user = isOwner ? DummyData.ownerUser : DummyData.renterUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 56, 20, 28),
            decoration: const BoxDecoration(
              color: AppColors.primaryDark,
            ),
            child: Column(
              children: [
                // Avatar
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  user.name,
                  style: AppTextStyles.headingMedium.copyWith(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: Colors.white.withValues(alpha: 0.25)),
                  ),
                  child: Text(
                    user.role == UserRole.owner
                        ? 'Pemilik Garasi'
                        : 'Penyewa',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Menu
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _MenuSection(
                    items: [
                      _MenuItem(
                        icon: Iconsax.edit,
                        label: 'Ubah Profil',
                        onTap: () {},
                      ),
                      _MenuItem(
                        icon: Iconsax.lock,
                        label: 'Ubah Password',
                        onTap: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  if (user.role == UserRole.owner)
                    _MenuSection(
                      items: [
                        _MenuItem(
                          icon: Iconsax.buildings_2,
                          label: 'Garasi Saya',
                          onTap: () => Get.toNamed(AppRoutes.ownerGarageList),
                        ),
                        _MenuItem(
                          icon: Iconsax.calendar_1,
                          label: 'Booking Masuk',
                          onTap: () =>
                              Get.toNamed(AppRoutes.ownerBookingIncoming),
                        ),
                        _MenuItem(
                          icon: Iconsax.document_text,
                          label: 'Riwayat Penyewaan',
                          onTap: () =>
                              Get.toNamed(AppRoutes.ownerRentalHistory),
                        ),
                      ],
                    ),

                  if (user.role == UserRole.renter)
                    _MenuSection(
                      items: [
                        _MenuItem(
                          icon: Iconsax.document_text,
                          label: 'Riwayat Sewa',
                          onTap: () =>
                              Get.toNamed(AppRoutes.renterRentalHistory),
                        ),
                      ],
                    ),

                  const SizedBox(height: 12),

                  _MenuSection(
                    items: [
                      _MenuItem(
                        icon: Iconsax.info_circle,
                        label: 'Tentang Aplikasi',
                        onTap: () => _showAbout(context),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  _MenuSection(
                    items: [
                      _MenuItem(
                        icon: Iconsax.logout,
                        label: 'Logout',
                        isDestructive: true,
                        onTap: () => _onLogout(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  Text('GarasiIn v1.0.0',
                      style: AppTextStyles.caption),
                  const SizedBox(height: 4),
                  Text('Marketplace Sewa Garasi',
                      style: AppTextStyles.caption),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAbout(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.garage_rounded,
                  color: Colors.white, size: 30),
            ),
            const SizedBox(height: 14),
            Text('GarasiIn',
                style: AppTextStyles.headingMedium),
            const SizedBox(height: 4),
            Text('Versi 1.0.0',
                style: AppTextStyles.caption),
            const SizedBox(height: 12),
            Text(
              'Marketplace sewa garasi rumah untuk parkir mobil. Mudah, aman, dan terpercaya.',
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _onLogout() {
    Get.dialog(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Get.offAllNamed(AppRoutes.login),
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class _MenuSection extends StatelessWidget {
  final List<_MenuItem> items;

  const _MenuSection({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: items.asMap().entries.map((e) {
          final isLast = e.key == items.length - 1;
          return Column(
            children: [
              e.value,
              if (!isLast)
                const Divider(height: 1, indent: 16, endIndent: 16),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? AppColors.danger : AppColors.textPrimary;
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: Icon(icon, size: 20, color: isDestructive ? AppColors.danger : AppColors.textSecondary),
      title: Text(label,
          style: AppTextStyles.bodyMedium.copyWith(color: color)),
      trailing: Icon(Icons.chevron_right_rounded,
          size: 18, color: AppColors.border),
    );
  }
}
