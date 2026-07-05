import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/app_status_badge.dart';
import '../../../data/dummy/dummy_data.dart';

class OwnerRentalHistoryPage extends StatefulWidget {
  const OwnerRentalHistoryPage({super.key});

  @override
  State<OwnerRentalHistoryPage> createState() =>
      _OwnerRentalHistoryPageState();
}

class _OwnerRentalHistoryPageState extends State<OwnerRentalHistoryPage> {
  final _dateFormat = DateFormat('d MMM yyyy', 'id_ID');
  final _priceFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    final bookings = DummyData.ownerBookings;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Riwayat Penyewaan'),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Iconsax.arrow_left, size: 20),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: bookings.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) {
          final b = bookings[i];
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
                      Text(b.garageName,
                          style: AppTextStyles.headingSmall
                              .copyWith(fontSize: 14)),
                      const SizedBox(height: 2),
                      Text(b.renterName, style: AppTextStyles.caption),
                      const SizedBox(height: 4),
                      Text(
                        '${_dateFormat.format(b.startDate)} – ${_dateFormat.format(b.endDate)}',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    AppStatusBadge(bookingStatus: b.status),
                    const SizedBox(height: 4),
                    Text(
                      _priceFormat.format(b.totalPrice),
                      style: AppTextStyles.price.copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
