import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_status_badge.dart';
import '../../../data/models/rental_model.dart';
import '../../../presentation/owner/controllers/owner_booking_controller.dart';

class OwnerBookingPage extends StatefulWidget {
  const OwnerBookingPage({super.key});

  @override
  State<OwnerBookingPage> createState() => _OwnerBookingPageState();
}

class _OwnerBookingPageState extends State<OwnerBookingPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final bookingCtrl = Get.find<OwnerBookingController>();
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
    bookingCtrl.loadOwnerBookings();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<RentalModel> _getFiltered(String status) =>
      bookingCtrl.allRentals.where((r) => r.status == status).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Booking Masuk'),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Iconsax.arrow_left, size: 20),
        ),
        bottom: TabBar(
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
      ),
      body: Obx(() => TabBarView(
        controller: _tabController,
        children: [
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
        rental: list[i],
        dateFormat: _dateFormat,
        priceFormat: _priceFormat,
        bookingCtrl: bookingCtrl,
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final RentalModel rental;
  final DateFormat dateFormat;
  final NumberFormat priceFormat;
  final OwnerBookingController bookingCtrl;

  const _BookingCard({
    required this.rental,
    required this.dateFormat,
    required this.priceFormat,
    required this.bookingCtrl,
  });

  @override
  Widget build(BuildContext context) {
    final statusLabel = rental.isPending
        ? 'Menunggu'
        : rental.isAccepted
            ? 'Diterima'
            : 'Ditolak';
    final statusColor = rental.isPending
        ? AppColors.warning
        : rental.isAccepted
            ? AppColors.success
            : AppColors.danger;

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
                    Text(rental.renterName ?? '-',
                        style: AppTextStyles.headingSmall),
                    Text(rental.garageName ?? '-',
                        style: AppTextStyles.caption),
                  ],
                ),
              ),
              AppStatusBadge(customLabel: statusLabel, customColor: statusColor),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),

          _InfoRow(
            label: 'Tanggal Sewa',
            value:
                '${dateFormat.format(rental.startDate)} – ${dateFormat.format(rental.endDate)}',
          ),
          const SizedBox(height: 6),
          _InfoRow(
            label: 'Total Biaya',
            value: priceFormat.format(rental.totalPrice),
            valueStyle: AppTextStyles.price.copyWith(fontSize: 14),
          ),
          if (rental.note != null && rental.note!.isNotEmpty) ...[
            const SizedBox(height: 6),
            _InfoRow(label: 'Catatan', value: rental.note!),
          ],

          if (rental.isPending) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'Tolak',
                    isOutline: true,
                    foregroundColor: AppColors.danger,
                    onTap: () async {
                      final confirm = await Get.dialog<bool>(
                        AlertDialog(
                          title: const Text('Tolak Booking'),
                          content: const Text('Yakin ingin menolak booking ini?'),
                          actions: [
                            TextButton(onPressed: () => Get.back(result: false), child: const Text('Batal')),
                            TextButton(onPressed: () => Get.back(result: true), style: TextButton.styleFrom(foregroundColor: AppColors.danger), child: const Text('Tolak')),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        await bookingCtrl.rejectRental(rental.id!);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: AppButton(
                    label: 'Terima',
                    backgroundColor: AppColors.success,
                    onTap: () async {
                      final confirm = await Get.dialog<bool>(
                        AlertDialog(
                          title: const Text('Terima Booking'),
                          content: const Text('Yakin ingin menerima booking ini?'),
                          actions: [
                            TextButton(onPressed: () => Get.back(result: false), child: const Text('Batal')),
                            TextButton(onPressed: () => Get.back(result: true), style: TextButton.styleFrom(foregroundColor: AppColors.success), child: const Text('Terima')),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        await bookingCtrl.approveRental(rental.id!);
                      }
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
