import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/widgets/garage_card.dart';
import '../../../core/widgets/section_title.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_status_badge.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          _DashboardTab(),
          _GarageListTab(),
          _BookingTab(),
          _ProfileTab(),
        ],
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () => Get.toNamed(AppRoutes.ownerGarageAdd),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 2,
              icon: const Icon(Icons.add, size: 20),
              label: const Text('Tambah Garasi',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            )
          : null,
      bottomNavigationBar: _buildBottomNav(),
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
            icon: Icon(Iconsax.calendar),
            selectedIcon: Icon(Iconsax.calendar_tick),
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

// ─── Dashboard Tab ────────────────────────────────────────────────────────

class _DashboardTab extends StatelessWidget {
  const _DashboardTab();

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

    return SafeArea(
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
                onActionTap: () {},
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

// ─── Garage List Tab ──────────────────────────────────────────────────────

class _GarageListTab extends StatelessWidget {
  const _GarageListTab();

  @override
  Widget build(BuildContext context) {
    final garages = DummyData.ownerGarages;

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              children: [
                Text('Garasi Saya', style: AppTextStyles.headingMedium),
                const Spacer(),
                GestureDetector(
                  onTap: () => Get.toNamed(AppRoutes.ownerGarageAdd),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, size: 16, color: Colors.white),
                        SizedBox(width: 4),
                        Text('Tambah',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: garages.isEmpty
                ? _buildEmpty()
                : ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: garages.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) => GarageCard(
                      garage: garages[i],
                      showEditButton: true,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: AppColors.softSurface,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.garage_outlined,
                size: 36, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          Text('Belum ada garasi', style: AppTextStyles.headingSmall),
          const SizedBox(height: 6),
          Text(
            'Tambah garasi pertama Anda sekarang',
            style: AppTextStyles.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─── Booking Tab ──────────────────────────────────────────────────────────

class _BookingTab extends StatefulWidget {
  const _BookingTab();

  @override
  State<_BookingTab> createState() => _BookingTabState();
}

class _BookingTabState extends State<_BookingTab>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final _dateFormat = DateFormat('d MMM yyyy', 'id_ID');
  final _priceFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<BookingModel> _getFiltered(BookingStatus status) =>
      DummyData.ownerBookings.where((b) => b.status == status).toList();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            color: AppColors.surface,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Booking Masuk', style: AppTextStyles.headingMedium),
                  ),
                ),
                TabBar(
                  controller: _tabController,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.textSecondary,
                  indicatorColor: AppColors.primary,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelStyle: AppTextStyles.labelMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  tabs: const [
                    Tab(text: 'Menunggu'),
                    Tab(text: 'Diterima'),
                    Tab(text: 'Ditolak'),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildList(_getFiltered(BookingStatus.pending)),
                _buildList(_getFiltered(BookingStatus.accepted)),
                _buildList(_getFiltered(BookingStatus.rejected)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(List<BookingModel> list) {
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Iconsax.calendar_remove,
                size: 40, color: AppColors.textSecondary),
            const SizedBox(height: 12),
            Text('Tidak ada booking',
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.textSecondary)),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: list.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) => _BookingCard(
        booking: list[i],
        dateFormat: _dateFormat,
        priceFormat: _priceFormat,
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final BookingModel booking;
  final DateFormat dateFormat;
  final NumberFormat priceFormat;

  const _BookingCard({
    required this.booking,
    required this.dateFormat,
    required this.priceFormat,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppColors.softSurface,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person_rounded,
                    size: 22, color: AppColors.textSecondary),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(booking.renterName, style: AppTextStyles.headingSmall),
                    Text(booking.garageName, style: AppTextStyles.caption),
                  ],
                ),
              ),
              AppStatusBadge(bookingStatus: booking.status),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          _InfoRow(
            label: 'Tanggal Sewa',
            value:
                '${dateFormat.format(booking.startDate)} – ${dateFormat.format(booking.endDate)}',
          ),
          const SizedBox(height: 6),
          _InfoRow(
            label: 'Total Biaya',
            value: priceFormat.format(booking.totalPrice),
            valueStyle: AppTextStyles.price.copyWith(fontSize: 14),
          ),
          if (booking.note != null && booking.note!.isNotEmpty) ...[
            const SizedBox(height: 6),
            _InfoRow(label: 'Catatan', value: booking.note!),
          ],
          if (booking.status == BookingStatus.pending) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'Tolak',
                    isOutline: true,
                    foregroundColor: AppColors.danger,
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: AppButton(
                    label: 'Terima',
                    backgroundColor: AppColors.success,
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? valueStyle;

  const _InfoRow({
    required this.label,
    required this.value,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(label, style: AppTextStyles.caption),
        ),
        Text(': ', style: AppTextStyles.caption),
        Expanded(
          child: Text(
            value,
            style: valueStyle ??
                AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ],
    );
  }
}

// ─── Profile Tab ──────────────────────────────────────────────────────────

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    final user = DummyData.ownerUser;

    return SafeArea(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
            decoration: const BoxDecoration(
              color: AppColors.primaryDark,
            ),
            child: Column(
              children: [
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
                    'Pemilik Garasi',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
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
                  _MenuSection(
                    items: [
                      _MenuItem(
                        icon: Iconsax.buildings_2,
                        label: 'Garasi Saya',
                        onTap: () {},
                      ),
                      _MenuItem(
                        icon: Iconsax.calendar_1,
                        label: 'Booking Masuk',
                        onTap: () {},
                      ),
                      _MenuItem(
                        icon: Iconsax.document_text,
                        label: 'Riwayat Penyewaan',
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _MenuSection(
                    items: [
                      _MenuItem(
                        icon: Iconsax.info_circle,
                        label: 'Tentang Aplikasi',
                        onTap: () {},
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
                  Text('GarasiIn v1.0.0', style: AppTextStyles.caption),
                  const SizedBox(height: 4),
                  Text('Marketplace Sewa Garasi', style: AppTextStyles.caption),
                ],
              ),
            ),
          ),
        ],
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
      leading: Icon(icon,
          size: 20,
          color: isDestructive ? AppColors.danger : AppColors.textSecondary),
      title: Text(label, style: AppTextStyles.bodyMedium.copyWith(color: color)),
      trailing:
          Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.border),
    );
  }
}
