import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/widgets/garage_card.dart';
import '../../../core/widgets/section_title.dart';
import '../../../data/dummy/dummy_data.dart';

class OwnerDashboardPage extends StatefulWidget {
  const OwnerDashboardPage({super.key});

  @override
  State<OwnerDashboardPage> createState() => _OwnerDashboardPageState();
}

class _OwnerDashboardPageState extends State<OwnerDashboardPage> {
  int _currentIndex = 0;

  void _onNavTap(int index) {
    setState(() => _currentIndex = index);
    switch (index) {
      case 0:
        break;
      case 1:
        Get.toNamed(AppRoutes.ownerGarageList);
        break;
      case 2:
        Get.toNamed(AppRoutes.ownerBookingIncoming);
        break;
      case 3:
        Get.toNamed(AppRoutes.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final owner = DummyData.ownerUser;
    final garages = DummyData.ownerGarages;
    final bookings = DummyData.ownerBookings;

    final totalGarages = garages.length;
    final incomingBookings =
        bookings.where((b) => b.status == BookingStatus.pending).length;
    final rented =
        garages.where((g) => g.status == GarageStatus.rented).length;
    final available =
        garages.where((g) => g.status == GarageStatus.available).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(AppRoutes.ownerGarageAdd),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 2,
        icon: const Icon(Icons.add, size: 20),
        label: const Text('Tambah Garasi',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      bottomNavigationBar: _buildBottomNav(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(owner),
              _buildStats(totalGarages, incomingBookings, rented, available),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SectionTitle(
                  title: 'Garasi Saya',
                  actionLabel: 'Lihat Semua',
                  onActionTap: () => Get.toNamed(AppRoutes.ownerGarageList),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: garages.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) => GarageCard(
                    garage: garages[i],
                    showEditButton: true,
                  ),
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(UserModel owner) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      color: AppColors.surface,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Halo, ${owner.name.split(' ').first} 👋',
                  style: AppTextStyles.headingMedium,
                ),
                const SizedBox(height: 2),
                Text(
                  'Kelola garasi dan pengajuan sewa Anda',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_rounded,
              color: AppColors.primary,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats(int total, int incoming, int rented, int available) {
    final formatter = NumberFormat.compact(locale: 'id_ID');
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ringkasan', style: AppTextStyles.labelLarge),
          const SizedBox(height: 14),
          Row(
            children: [
              _StatItem(
                  label: 'Total\nGarasi',
                  value: formatter.format(total),
                  color: AppColors.primary),
              const SizedBox(width: 1),
              _StatItem(
                  label: 'Booking\nMasuk',
                  value: formatter.format(incoming),
                  color: AppColors.warning),
              const SizedBox(width: 1),
              _StatItem(
                  label: 'Sedang\nDisewa',
                  value: formatter.format(rented),
                  color: AppColors.danger),
              const SizedBox(width: 1),
              _StatItem(
                  label: 'Tersedia',
                  value: formatter.format(available),
                  color: AppColors.success),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onNavTap,
        destinations: const [
          NavigationDestination(
            icon: Icon(Iconsax.home_2),
            selectedIcon: Icon(Iconsax.home_24),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Iconsax.buildings_2),
            selectedIcon: Icon(Iconsax.buildings_24),
            label: 'Garasi',
          ),
          NavigationDestination(
            icon: Icon(Iconsax.calendar_1),
            selectedIcon: Icon(Iconsax.calendar_14),
            label: 'Booking',
          ),
          NavigationDestination(
            icon: Icon(Iconsax.profile_circle),
            selectedIcon: Icon(Iconsax.profile_circle4),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.displayMedium.copyWith(
              fontSize: 24,
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(fontSize: 11),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
