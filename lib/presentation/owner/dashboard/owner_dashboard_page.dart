import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/widgets/garage_card.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_status_badge.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/garage_model.dart';
import '../../../data/models/rental_model.dart';
import '../../../presentation/auth/controllers/auth_controller.dart';
import '../../../presentation/owner/controllers/owner_dashboard_controller.dart';
import '../../../presentation/owner/controllers/owner_garage_controller.dart';
import '../../../presentation/owner/controllers/owner_booking_controller.dart';

Color _rentalStatusColor(String status) {
  switch (status) {
    case 'accepted':
      return AppColors.success;
    case 'rejected':
      return AppColors.danger;
    default:
      return AppColors.warning;
  }
}

String _rentalStatusLabel(String status) {
  switch (status) {
    case 'accepted':
      return 'Diterima';
    case 'rejected':
      return 'Ditolak';
    default:
      return 'Menunggu';
  }
}

Color _garageStatusColor(String status) {
  return status == 'rented' ? AppColors.warning : AppColors.success;
}

String _garageStatusLabel(String status) {
  return status == 'rented' ? 'Disewa' : 'Tersedia';
}

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
    final controller = Get.find<OwnerDashboardController>();
    final owner = Get.find<AuthController>().currentUser.value;
    if (owner == null) return const SizedBox.shrink();

    return Obx(() {
      final garages = controller.garages;
      final totalGarages = controller.totalGarages;
      final incomingBookings = controller.pendingBookings;
      final rented = controller.rentedGarages;
      final available = controller.availableGarages;
      final pendingRentals = controller.pendingRentalsList;

      return SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _OwnerHeroBanner(owner: owner),
              const SizedBox(height: 24),
              _QuickStats(
                total: totalGarages,
                incoming: incomingBookings,
                rented: rented,
                available: available,
              ),
              const SizedBox(height: 28),
              if (pendingRentals.isNotEmpty) ...[
                _PendingBookingsSection(bookings: pendingRentals),
                const SizedBox(height: 28),
              ],
              _OwnerGarageSection(garages: garages),
              const SizedBox(height: 100),
            ],
          ),
        ),
      );
    });
  }
}

// ─── Hero Banner ──────────────────────────────────────────────────────────

class _OwnerHeroBanner extends StatelessWidget {
  final UserModel owner;
  const _OwnerHeroBanner({required this.owner});

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final horizontalPad = screenW * 0.04;

    return Container(
      margin: EdgeInsets.fromLTRB(horizontalPad, 8, horizontalPad, 0),
      padding: EdgeInsets.all(screenW * 0.05),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryDark, AppColors.primary],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Halo, ${owner.name.split(' ').first} 👋',
                      style: AppTextStyles.headingLarge.copyWith(
                        color: AppColors.surface,
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Kelola garasi dan pantau penyewaanmu',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.surface.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.surface.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.surface.withValues(alpha: 0.25),
                  ),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Quick Stats ──────────────────────────────────────────────────────────

class _QuickStats extends StatelessWidget {
  final int total;
  final int incoming;
  final int rented;
  final int available;

  const _QuickStats({
    required this.total,
    required this.incoming,
    required this.rented,
    required this.available,
  });

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final cardW = screenW * 0.2;
    final cardH = screenW * 0.24;

    final stats = [
      _StatData(
        icon: Iconsax.buildings_2,
        label: 'Total',
        value: '$total',
        color: AppColors.primary,
      ),
      _StatData(
        icon: Iconsax.calendar_1,
        label: 'Booking',
        value: '$incoming',
        color: AppColors.warning,
      ),
      _StatData(
        icon: Iconsax.key,
        label: 'Disewa',
        value: '$rented',
        color: AppColors.danger,
      ),
      _StatData(
        icon: Iconsax.tick_circle,
        label: 'Tersedia',
        value: '$available',
        color: AppColors.success,
      ),
    ];

    return SizedBox(
      height: cardH,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: stats.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) => _StatCard(
          data: stats[i],
          width: cardW,
        ),
      ),
    );
  }
}

class _StatData {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatData({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });
}

class _StatCard extends StatelessWidget {
  final _StatData data;
  final double width;

  const _StatCard({
    required this.data,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: data.color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(data.icon, size: 18, color: data.color),
          ),
          const SizedBox(height: 8),
          Text(
            data.value,
            style: AppTextStyles.headingLarge.copyWith(
              color: data.color,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            data.label,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Pending Bookings Section ─────────────────────────────────────────────

class _PendingBookingsSection extends StatelessWidget {
  final List<RentalModel> bookings;
  const _PendingBookingsSection({required this.bookings});

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final cardW = screenW * 0.7;
    final carouselH = screenW * 0.38;
    final dateFormat = DateFormat('d MMM', 'id_ID');
    final priceFormat =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Booking Terbaru', style: AppTextStyles.headingSmall),
              GestureDetector(
                onTap: () => Get.toNamed(AppRoutes.ownerBookingIncoming),
                child: Text(
                  'Lihat Semua',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: carouselH,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: bookings.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (_, i) => _BookingCarouselCard(
              booking: bookings[i],
              cardWidth: cardW,
              dateFormat: dateFormat,
              priceFormat: priceFormat,
            ),
          ),
        ),
      ],
    );
  }
}

class _BookingCarouselCard extends StatelessWidget {
  final RentalModel booking;
  final double cardWidth;
  final DateFormat dateFormat;
  final NumberFormat priceFormat;

  const _BookingCarouselCard({
    required this.booking,
    required this.cardWidth,
    required this.dateFormat,
    required this.priceFormat,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: AppColors.surface,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (_) => _OwnerBookingDetailSheet(booking: booking),
        );
      },
      child: Container(
        width: cardWidth,
        padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.softSurface,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person_rounded,
                    size: 20, color: AppColors.textSecondary),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(booking.renterName ?? '',
                        style: AppTextStyles.labelLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        )),
                    Text(booking.garageName ?? '', style: AppTextStyles.caption),
                  ],
                ),
              ),
              AppStatusBadge(
                customLabel: _rentalStatusLabel(booking.status),
                customColor: _rentalStatusColor(booking.status),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Icon(Iconsax.calendar_1,
                  size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Text(
                '${dateFormat.format(booking.startDate)} – ${dateFormat.format(booking.endDate)}',
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            priceFormat.format(booking.totalPrice),
            style: AppTextStyles.price.copyWith(fontSize: 16),
          ),
        ],
      ),
      ),
    );
  }
}

// ─── Owner Booking Detail Sheet ───────────────────────────────────────────

class _OwnerBookingDetailSheet extends StatelessWidget {
  final RentalModel booking;
  const _OwnerBookingDetailSheet({required this.booking});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('d MMM yyyy', 'id_ID');
    final priceFormat =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.softSurface,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.person_rounded,
                      size: 24, color: AppColors.textSecondary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(booking.renterName ?? '',
                          style: AppTextStyles.headingSmall),
                      Text(booking.garageName ?? '',
                          style: AppTextStyles.caption),
                    ],
                  ),
                ),
                AppStatusBadge(
                  customLabel: _rentalStatusLabel(booking.status),
                  customColor: _rentalStatusColor(booking.status),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          _DetailRow(label: 'Status', value: _rentalStatusLabel(booking.status)),
          _DetailRow(
              label: 'Tanggal',
              value:
                  '${dateFormat.format(booking.startDate)} – ${dateFormat.format(booking.endDate)}'),
          _DetailRow(
              label: 'Total',
              value: priceFormat.format(booking.totalPrice)),
          if (booking.note != null && booking.note!.isNotEmpty)
            _DetailRow(label: 'Catatan', value: booking.note!),
          const SizedBox(height: 24),

          if (booking.isPending) ...[
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'Tolak',
                    isOutline: true,
                    foregroundColor: AppColors.danger,
                    onTap: () async {
                      Get.back();
                      final bookingCtrl = Get.find<OwnerBookingController>();
                      await bookingCtrl.rejectRental(booking.id!);
                      await Get.find<OwnerDashboardController>().loadDashboard();
                      Get.snackbar('Berhasil', 'Booking ditolak',
                          snackPosition: SnackPosition.BOTTOM);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppButton(
                    label: 'Terima',
                    backgroundColor: AppColors.success,
                    onTap: () async {
                      Get.back();
                      final bookingCtrl = Get.find<OwnerBookingController>();
                      await bookingCtrl.approveRental(booking.id!);
                      await Get.find<OwnerDashboardController>().loadDashboard();
                      Get.snackbar('Berhasil', 'Booking diterima',
                          snackPosition: SnackPosition.BOTTOM);
                    },
                  ),
                ),
              ],
            ),
          ],
          if (booking.isAccepted)
            AppButton(
              label: 'Lihat Garasi',
              onTap: () {
                Get.back();
                final dashboardCtrl = Get.find<OwnerDashboardController>();
                final dbGarage = dashboardCtrl.garages
                    .where((g) => g.id == booking.garageId);
                if (dbGarage.isNotEmpty) {
                  Get.toNamed(AppRoutes.garageDetail,
                      arguments: dbGarage.first);
                } else {
                  Get.snackbar('Info', 'Garasi tidak ditemukan',
                      snackPosition: SnackPosition.BOTTOM);
                }
              },
            ),
          if (booking.isRejected)
            AppButton(
              label: 'Lihat Garasi',
              onTap: () {
                Get.back();
                final dashboardCtrl = Get.find<OwnerDashboardController>();
                final dbGarage = dashboardCtrl.garages
                    .where((g) => g.id == booking.garageId);
                if (dbGarage.isNotEmpty) {
                  Get.toNamed(AppRoutes.garageDetail,
                      arguments: dbGarage.first);
                } else {
                  Get.snackbar('Info', 'Garasi tidak ditemukan',
                      snackPosition: SnackPosition.BOTTOM);
                }
              },
            ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(label, style: AppTextStyles.caption),
          ),
          const Text(': '),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Owner Garage Section ─────────────────────────────────────────────────

class _OwnerGarageSection extends StatelessWidget {
  final List<GarageModel> garages;
  const _OwnerGarageSection({required this.garages});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Garasi Saya', style: AppTextStyles.headingSmall),
              Text(
                '${garages.length} garasi',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        garages.isEmpty
            ? _buildEmpty()
            : ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: garages.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) =>
                    _CompactOwnerGarageTile(garage: garages[i]),
              ),
      ],
    );
  }

  Widget _buildEmpty() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Column(
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
      ),
    );
  }
}

class _CompactOwnerGarageTile extends StatelessWidget {
  final GarageModel garage;
  const _CompactOwnerGarageTile({required this.garage});

  @override
  Widget build(BuildContext context) {
    final formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.garageDetail, arguments: garage),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.softSurface,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.garage_rounded,
                  size: 28, color: AppColors.accent),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          garage.name,
                          style: AppTextStyles.labelLarge.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      AppStatusBadge(
                        customLabel: _garageStatusLabel(garage.status),
                        customColor: _garageStatusColor(garage.status),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Iconsax.location,
                          size: 12, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          garage.address,
                          style: AppTextStyles.caption,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${garage.length}x${garage.width}m',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatter.format(garage.pricePerMonth),
                  style: AppTextStyles.price.copyWith(fontSize: 14),
                ),
                Text(
                  '/bulan',
                  style: AppTextStyles.caption.copyWith(fontSize: 10),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Garage List Tab ──────────────────────────────────────────────────────

class _GarageListTab extends StatelessWidget {
  const _GarageListTab();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OwnerGarageController>();

    return Obx(() {
      final garages = controller.garages;

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
    });
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

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OwnerBookingController>();

    return Obx(() {
      final pending = controller.pendingRentals;
      final accepted = controller.acceptedRentals;
      final rejected = controller.rejectedRentals;

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
                  _buildList(pending),
                  _buildList(accepted),
                  _buildList(rejected),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildList(List<RentalModel> list) {
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
      itemBuilder: (_, i) => GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: AppColors.surface,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (_) => _OwnerBookingDetailSheet(booking: list[i]),
          );
        },
        child: _BookingCard(
          booking: list[i],
          dateFormat: _dateFormat,
          priceFormat: _priceFormat,
        ),
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final RentalModel booking;
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
                    Text(booking.renterName ?? '', style: AppTextStyles.headingSmall),
                    Text(booking.garageName ?? '', style: AppTextStyles.caption),
                  ],
                ),
              ),
              AppStatusBadge(
                customLabel: _rentalStatusLabel(booking.status),
                customColor: _rentalStatusColor(booking.status),
              ),
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
          if (booking.isPending) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'Tolak',
                    isOutline: true,
                    foregroundColor: AppColors.danger,
                    onTap: () {
                      Get.dialog(
                        AlertDialog(
                          title: const Text('Tolak Booking'),
                          content: const Text(
                              'Apakah Anda yakin ingin menolak booking ini?'),
                          actions: [
                            TextButton(
                              onPressed: () => Get.back(),
                              child: const Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () async {
                                Get.back();
                                final bookingCtrl =
                                    Get.find<OwnerBookingController>();
                                await bookingCtrl.rejectRental(booking.id!);
                                await Get.find<OwnerDashboardController>()
                                    .loadDashboard();
                                Get.snackbar(
                                    'Berhasil', 'Booking berhasil ditolak',
                                    snackPosition: SnackPosition.BOTTOM);
                              },
                              style: TextButton.styleFrom(
                                  foregroundColor: AppColors.danger),
                              child: const Text('Tolak'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: AppButton(
                    label: 'Terima',
                    backgroundColor: AppColors.success,
                    onTap: () {
                      Get.dialog(
                        AlertDialog(
                          title: const Text('Terima Booking'),
                          content: const Text(
                              'Apakah Anda yakin ingin menerima booking ini?'),
                          actions: [
                            TextButton(
                              onPressed: () => Get.back(),
                              child: const Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () async {
                                Get.back();
                                final bookingCtrl =
                                    Get.find<OwnerBookingController>();
                                await bookingCtrl.approveRental(booking.id!);
                                await Get.find<OwnerDashboardController>()
                                    .loadDashboard();
                                Get.snackbar(
                                    'Berhasil', 'Booking berhasil diterima',
                                    snackPosition: SnackPosition.BOTTOM);
                              },
                              style: TextButton.styleFrom(
                                  foregroundColor: AppColors.success),
                              child: const Text('Terima'),
                            ),
                          ],
                        ),
                      );
                    },
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
    final user = Get.find<AuthController>().currentUser.value;
    if (user == null) return const SizedBox.shrink();

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
                        onTap: () => Get.toNamed(AppRoutes.editProfile,
                            arguments: user),
                      ),
                      _MenuItem(
                        icon: Iconsax.lock,
                        label: 'Ubah Password',
                        onTap: () => Get.toNamed(AppRoutes.changePassword),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
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
                        onTap: () => Get.toNamed(AppRoutes.ownerBookingIncoming),
                      ),
                      _MenuItem(
                        icon: Iconsax.document_text,
                        label: 'Riwayat Penyewaan',
                        onTap: () => Get.toNamed(AppRoutes.ownerRentalHistory),
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
            onPressed: () => Get.find<AuthController>().logout(),
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
