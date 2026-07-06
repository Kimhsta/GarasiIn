import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/app_status_badge.dart';
import '../../../data/models/rental_model.dart';
import '../../../presentation/renter/controllers/renter_booking_controller.dart';

class RenterRentalHistoryPage extends StatefulWidget {
  const RenterRentalHistoryPage({super.key});

  @override
  State<RenterRentalHistoryPage> createState() =>
      _RenterRentalHistoryPageState();
}

class _RenterRentalHistoryPageState extends State<RenterRentalHistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final bookingCtrl = Get.find<RenterBookingController>();
  final _dateFormat = DateFormat('d MMM yyyy', 'id_ID');
  final _priceFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    bookingCtrl.loadMyRentals();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<RentalModel> _getFiltered(String? status) {
    final all = bookingCtrl.rentals;
    if (status == null) return all;
    return all.where((r) => r.status == status).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Riwayat Sewa'),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Iconsax.arrow_left, size: 20),
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          indicatorSize: TabBarIndicatorSize.label,
          labelStyle: AppTextStyles.labelMedium.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
          tabs: const [
            Tab(text: 'Semua'),
            Tab(text: 'Menunggu'),
            Tab(text: 'Diterima'),
            Tab(text: 'Ditolak'),
          ],
        ),
      ),
      body: Obx(() => TabBarView(
        controller: _tabController,
        children: [
          _buildList(_getFiltered(null)),
          _buildList(_getFiltered('pending')),
          _buildList(_getFiltered('accepted')),
          _buildList(_getFiltered('rejected')),
        ],
      )),
    );
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
            Text('Belum ada riwayat',
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.textSecondary)),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: list.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) {
        final r = list[i];
        final statusLabel = r.isPending
            ? 'Menunggu'
            : r.isAccepted
                ? 'Diterima'
                : r.isRejected
                    ? 'Ditolak'
                    : 'Dibatalkan';
        final statusColor = r.isPending
            ? AppColors.warning
            : r.isAccepted
                ? AppColors.success
                : AppColors.danger;
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.softSurface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.garage_rounded,
                    size: 28, color: AppColors.accent),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r.garageName ?? '-',
                        style: AppTextStyles.headingSmall.copyWith(
                          fontSize: 14,
                        )),
                    const SizedBox(height: 4),
                    Text(
                      '${_dateFormat.format(r.startDate)} – ${_dateFormat.format(r.endDate)}',
                      style: AppTextStyles.caption,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _priceFormat.format(r.totalPrice),
                      style: AppTextStyles.price.copyWith(fontSize: 13),
                    ),
                  ],
                ),
              ),
              AppStatusBadge(customLabel: statusLabel, customColor: statusColor),
            ],
          ),
        );
      },
    );
  }
}
