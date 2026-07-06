import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/app_status_badge.dart';
import '../../../presentation/owner/controllers/owner_booking_controller.dart';

class OwnerRentalHistoryPage extends StatefulWidget {
  const OwnerRentalHistoryPage({super.key});

  @override
  State<OwnerRentalHistoryPage> createState() =>
      _OwnerRentalHistoryPageState();
}

class _OwnerRentalHistoryPageState extends State<OwnerRentalHistoryPage> {
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
    bookingCtrl.loadOwnerBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Riwayat Penyewaan'),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Iconsax.arrow_left, size: 20),
        ),
      ),
      body: Obx(() {
        final rentals = bookingCtrl.allRentals;
        if (rentals.isEmpty) {
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
          itemCount: rentals.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, i) {
            final r = rentals[i];
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
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.softSurface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.garage_rounded,
                        size: 22, color: AppColors.accent),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(r.garageName ?? '-',
                            style: AppTextStyles.headingSmall
                                .copyWith(fontSize: 14)),
                        const SizedBox(height: 2),
                        Text(r.renterName ?? '-', style: AppTextStyles.caption),
                        const SizedBox(height: 4),
                        Text(
                          '${_dateFormat.format(r.startDate)} – ${_dateFormat.format(r.endDate)}',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      AppStatusBadge(customLabel: statusLabel, customColor: statusColor),
                      const SizedBox(height: 4),
                      Text(
                        _priceFormat.format(r.totalPrice),
                        style: AppTextStyles.price.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
