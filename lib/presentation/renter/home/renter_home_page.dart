import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/widgets/garage_card.dart';
import '../../../core/widgets/app_status_badge.dart';
import '../../../core/widgets/app_button.dart';
import '../../../data/repositories/garage_repository.dart';
import '../../../presentation/auth/controllers/auth_controller.dart';
import '../../../presentation/renter/controllers/renter_home_controller.dart';
import '../../../presentation/renter/controllers/renter_booking_controller.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/garage_model.dart';
import '../../../data/models/rental_model.dart';

class RenterHomePage extends StatefulWidget {
  const RenterHomePage({super.key});

  @override
  State<RenterHomePage> createState() => _RenterHomePageState();
}

class _RenterHomePageState extends State<RenterHomePage> {
  int _currentIndex = 0;
  int _selectedCategory = -1;

  void _onNavTap(int index) {
    setState(() => _currentIndex = index);
  }

  void _onCategoryTap(int categoryIndex) {
    setState(() {
      _selectedCategory = categoryIndex;
      _currentIndex = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _HomeTab(
            onSearchTap: () => _onNavTap(1),
            onCategoryTap: _onCategoryTap,
          ),
          _SearchTab(initialCategory: _selectedCategory),
          const _BookingHistoryTab(),
          _ProfileTab(onBookingTap: () => _onNavTap(2)),
        ],
      ),
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
            icon: Icon(Iconsax.search_normal_1),
            selectedIcon: Icon(Iconsax.search_normal),
            label: 'Cari',
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

class _HomeTab extends StatelessWidget {
  final VoidCallback onSearchTap;
  final void Function(int categoryIndex) onCategoryTap;
  const _HomeTab({required this.onSearchTap, required this.onCategoryTap});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    final homeCtrl = Get.find<RenterHomeController>();

    return Obx(() {
      final renter = auth.currentUser.value;
      if (renter == null) return const SizedBox.shrink();
      final garages = homeCtrl.garages;

      return SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeroBanner(renter: renter, onSearchTap: onSearchTap),
              const SizedBox(height: 24),
              _CategoryPills(onCategoryTap: onCategoryTap),
              const SizedBox(height: 28),
              _FeaturedSection(garages: garages, onSearchTap: onSearchTap),
              const SizedBox(height: 28),
              _RecentSection(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      );
    });
  }
}

class _HeroBanner extends StatelessWidget {
  final UserModel renter;
  final VoidCallback onSearchTap;
  const _HeroBanner({required this.renter, required this.onSearchTap});

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
          Text(
            'Hi, ${renter.name.split(' ').first} 👋',
            style: AppTextStyles.headingLarge.copyWith(
              color: AppColors.surface,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Mau parkir di mana hari ini?',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.surface.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: onSearchTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.surface.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(Iconsax.search_normal,
                      size: 18,
                      color: AppColors.surface.withValues(alpha: 0.7)),
                  const SizedBox(width: 10),
                  Text(
                    'Cari garasi di kotamu...',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.surface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryPills extends StatelessWidget {
  final void Function(int categoryIndex) onCategoryTap;
  const _CategoryPills({required this.onCategoryTap});

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final cardW = screenW * 0.2;
    final cardH = screenW * 0.22;

    const categories = [
      _CategoryItem(icon: Iconsax.location, label: 'Terdekat'),
      _CategoryItem(icon: Iconsax.star_1, label: 'Populer'),
      _CategoryItem(icon: Iconsax.money, label: 'Murah'),
      _CategoryItem(icon: Iconsax.crown_1, label: 'Premium'),
    ];

    return SizedBox(
      height: cardH,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) => _CategoryCard(
          icon: categories[i].icon,
          label: categories[i].label,
          isSelected: false,
          width: cardW,
          onTap: () => onCategoryTap(i),
        ),
      ),
    );
  }
}

class _CategoryItem {
  final IconData icon;
  final String label;
  const _CategoryItem({required this.icon, required this.label});
}

class _CategoryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final double width;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.width,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
      width: width,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.border,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 24,
            color: isSelected ? AppColors.surface : AppColors.primary,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: isSelected ? AppColors.surface : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    ),
    );
  }
}

class _FeaturedSection extends StatelessWidget {
  final List<GarageModel> garages;
  final VoidCallback onSearchTap;
  const _FeaturedSection({required this.garages, required this.onSearchTap});

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final cardW = screenW * 0.65;
    final carouselH = screenW * 0.52;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Unggulan', style: AppTextStyles.headingSmall),
              GestureDetector(
                onTap: onSearchTap,
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
            itemCount: garages.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (_, i) => _FeaturedCard(
              garage: garages[i],
              cardWidth: cardW,
              imageH: carouselH * 0.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  final GarageModel garage;
  final double cardWidth;
  final double imageH;

  const _FeaturedCard({
    required this.garage,
    required this.cardWidth,
    required this.imageH,
  });

  @override
  Widget build(BuildContext context) {
    final formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.garageDetail, arguments: garage),
      child: Container(
        width: cardWidth,
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
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: imageH,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.softSurface,
              ),
              child: Stack(
                children: [
                  if (garage.imagePath != null && garage.imagePath!.isNotEmpty)
                    Image.file(
                      File(garage.imagePath!),
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Center(
                        child: Icon(
                          Icons.garage_rounded,
                          size: 44,
                          color: AppColors.accent.withValues(alpha: 0.6),
                        ),
                      ),
                    )
                  else
                    Center(
                      child: Icon(
                        Icons.garage_rounded,
                        size: 44,
                        color: AppColors.accent.withValues(alpha: 0.6),
                      ),
                    ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadowLight,
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Iconsax.star_1,
                              size: 12, color: AppColors.warning),
                          const SizedBox(width: 3),
                          Text(
                            '4.8',
                            style: AppTextStyles.labelSmall.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    garage.name,
                    style: AppTextStyles.labelLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Iconsax.location,
                          size: 12, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          garage.city,
                          style: AppTextStyles.caption,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formatter.format(garage.pricePerMonth),
                    style: AppTextStyles.price.copyWith(fontSize: 15),
                  ),
                  Text(
                    '/bulan',
                    style: AppTextStyles.caption.copyWith(fontSize: 10),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentSection extends StatelessWidget {
  const _RecentSection();

  @override
  Widget build(BuildContext context) {
    final homeCtrl = Get.find<RenterHomeController>();

    return Obx(() {
      final garages = homeCtrl.garages;

      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Terbaru', style: AppTextStyles.headingSmall),
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
          ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: garages.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) => _CompactGarageTile(garage: garages[i]),
          ),
        ],
      );
    });
  }
}

class _CompactGarageTile extends StatelessWidget {
  final GarageModel garage;
  const _CompactGarageTile({required this.garage});

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
              clipBehavior: Clip.antiAlias,
              child: garage.imagePath != null && garage.imagePath!.isNotEmpty
                  ? Image.file(
                      File(garage.imagePath!),
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                          Icons.garage_rounded,
                          size: 28,
                          color: AppColors.accent),
                    )
                  : const Icon(Icons.garage_rounded,
                      size: 28, color: AppColors.accent),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    garage.name,
                    style: AppTextStyles.labelLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Iconsax.location,
                          size: 12, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${garage.address}, ${garage.city}',
                          style: AppTextStyles.caption,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
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

class _SearchTab extends StatefulWidget {
  final int initialCategory;
  const _SearchTab({this.initialCategory = -1});

  @override
  State<_SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<_SearchTab> {
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final controller = Get.find<RenterHomeController>();
    controller.filterByPrice(widget.initialCategory);
  }

  @override
  void didUpdateWidget(_SearchTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialCategory != oldWidget.initialCategory) {
      final controller = Get.find<RenterHomeController>();
      controller.filterByPrice(widget.initialCategory);
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onCategorySelect(int index) {
    final controller = Get.find<RenterHomeController>();
    _searchCtrl.clear();
    controller.searchKeyword.value = '';
    controller.filterByPrice(index);
  }

  String _getCategoryTitle(RenterHomeController controller) {
    switch (controller.selectedPriceFilter.value) {
      case 0:
        return 'Terdekat';
      case 1:
        return 'Populer';
      case 2:
        return 'Murah (< Rp300rb)';
      case 3:
        return 'Premium (> Rp500rb)';
      default:
        return 'Cari Garasi';
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RenterHomeController>();

    return SafeArea(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            color: AppColors.surface,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  final sel = controller.selectedPriceFilter.value;
                  return Row(
                    children: [
                      if (sel >= 0) ...[
                        GestureDetector(
                          onTap: () => _onCategorySelect(-1),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.softSurface,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.arrow_back_rounded,
                                size: 20, color: AppColors.textPrimary),
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      Expanded(
                        child: Text(_getCategoryTitle(controller),
                            style: AppTextStyles.headingMedium),
                      ),
                    ],
                  );
                }),
                const SizedBox(height: 12),
                TextField(
                  controller: _searchCtrl,
                  onChanged: (v) => controller.searchGarages(v),
                  style: AppTextStyles.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'Cari nama garasi atau lokasi...',
                    prefixIcon: const Icon(Iconsax.search_normal,
                        size: 18, color: AppColors.textSecondary),
                    suffixIcon: _searchCtrl.text.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              _searchCtrl.clear();
                              controller.searchGarages('');
                            },
                            child: const Icon(Icons.close,
                                size: 18, color: AppColors.textSecondary),
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 12),
                Obx(() {
                  final sel = controller.selectedPriceFilter.value;
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _FilterPill(
                          label: 'Semua Harga',
                          isSelected: sel == -1,
                          onTap: () => _onCategorySelect(-1),
                        ),
                        const SizedBox(width: 8),
                        _FilterPill(
                          label: '< Rp300rb',
                          isSelected: sel == 2,
                          onTap: () => _onCategorySelect(2),
                        ),
                        const SizedBox(width: 8),
                        _FilterPill(
                          label: 'Rp300–500rb',
                          isSelected: sel == 4,
                          onTap: () => _onCategorySelect(4),
                        ),
                        const SizedBox(width: 8),
                        _FilterPill(
                          label: '> Rp500rb',
                          isSelected: sel == 3,
                          onTap: () => _onCategorySelect(3),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: Obx(() {
              final results = controller.searchResults;

              if (results.isEmpty) {
                return _buildEmpty();
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: results.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) => GarageCard(garage: results[i]),
              );
            }),
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
          const Icon(Iconsax.search_zoom_out,
              size: 44, color: AppColors.textSecondary),
          const SizedBox(height: 14),
          Text('Garasi tidak ditemukan', style: AppTextStyles.headingSmall),
          const SizedBox(height: 6),
          Text('Coba kata kunci lain', style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterPill({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class _BookingHistoryTab extends StatefulWidget {
  const _BookingHistoryTab();

  @override
  State<_BookingHistoryTab> createState() => _BookingHistoryTabState();
}

class _BookingHistoryTabState extends State<_BookingHistoryTab>
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
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<RentalModel> _getFiltered(RenterBookingController controller, String? status) {
    final all = controller.rentals;
    if (status == null) return all.toList();
    return all.where((r) => r.status == status).toList();
  }

  void _showBookingDetail(RentalModel rental) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _BookingDetailSheet(rental: rental),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RenterBookingController>();

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
                    child: Text('Riwayat Sewa', style: AppTextStyles.headingMedium),
                  ),
                ),
                TabBar(
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
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              return TabBarView(
                controller: _tabController,
                children: [
                  _buildList(_getFiltered(controller, null)),
                  _buildList(_getFiltered(controller, 'pending')),
                  _buildList(_getFiltered(controller, 'accepted')),
                  _buildList(_getFiltered(controller, 'rejected')),
                ],
              );
            }),
          ),
        ],
      ),
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
        final badgeLabel = r.isPending
            ? 'Menunggu'
            : r.isAccepted
                ? 'Diterima'
                : r.isRejected
                    ? 'Ditolak'
                    : 'Dibatalkan';
        final badgeColor = r.isPending
            ? AppColors.warning
            : r.isAccepted
                ? AppColors.success
                : AppColors.danger;

        return GestureDetector(
          onTap: () => _showBookingDetail(r),
          child: Container(
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
              AppStatusBadge(
                customLabel: badgeLabel,
                customColor: badgeColor,
              ),
            ],
          ),
        ),
        );
      },
    );
  }
}

class _BookingDetailSheet extends StatelessWidget {
  final RentalModel rental;
  const _BookingDetailSheet({required this.rental});

  Future<void> _navigateToGarage(
      BuildContext context, GarageModel? Function() getGarage) async {
    Get.back();
    final repo = GarageRepository();
    final garage = await repo.getGarageById(rental.garageId);
    if (garage != null) {
      Get.toNamed(AppRoutes.garageDetail, arguments: garage);
    } else {
      Get.snackbar('Info', 'Garasi tidak ditemukan',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> _navigateToApply(GarageModel? Function() getGarage) async {
    Get.back();
    final repo = GarageRepository();
    final garage = await repo.getGarageById(rental.garageId);
    if (garage != null) {
      Get.toNamed(AppRoutes.rentalApply, arguments: garage);
    } else {
      Get.snackbar('Info', 'Garasi tidak ditemukan',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('d MMM yyyy', 'id_ID');
    final priceFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    final bookingCtrl = Get.find<RenterBookingController>();

    final badgeLabel = rental.isPending
        ? 'Menunggu'
        : rental.isAccepted
            ? 'Diterima'
            : rental.isRejected
                ? 'Ditolak'
                : 'Dibatalkan';

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
                  child: const Icon(Icons.garage_rounded,
                      size: 24, color: AppColors.accent),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(rental.garageName ?? '-',
                          style: AppTextStyles.headingSmall),
                      Text(rental.renterName ?? '-',
                          style: AppTextStyles.caption),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          _DetailRow(
            label: 'Status',
            value: badgeLabel,
          ),
          _DetailRow(
              label: 'Tanggal',
              value:
                  '${dateFormat.format(rental.startDate)} – ${dateFormat.format(rental.endDate)}'),
          _DetailRow(
              label: 'Total',
              value: priceFormat.format(rental.totalPrice)),
          if (rental.note != null && rental.note!.isNotEmpty)
            _DetailRow(label: 'Catatan', value: rental.note!),
          const SizedBox(height: 24),

          if (rental.isAccepted)
            AppButton(
              label: 'Lihat Garasi',
              onTap: () => _navigateToGarage(context, () => null),
            ),
          if (rental.isRejected)
            AppButton(
              label: 'Ajukan Lagi',
              onTap: () => _navigateToApply(() => null),
            ),
          if (rental.isPending) ...[
            AppButton(
              label: 'Batalkan Booking',
              isOutline: true,
              foregroundColor: AppColors.danger,
              onTap: () async {
                Get.back();
                final success = await bookingCtrl.cancelRental(rental.id!);
                if (success) {
                  Get.snackbar('Berhasil', 'Booking berhasil dibatalkan',
                      snackPosition: SnackPosition.BOTTOM);
                }
              },
            ),
            const SizedBox(height: 10),
            AppButton(
              label: 'Lihat Garasi',
              onTap: () => _navigateToGarage(context, () => null),
            ),
          ],
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

class _ProfileTab extends StatelessWidget {
  final VoidCallback onBookingTap;
  const _ProfileTab({required this.onBookingTap});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    return Obx(() {
      final user = auth.currentUser.value;
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
                    clipBehavior: Clip.antiAlias,
                    child: user.imagePath != null && user.imagePath!.isNotEmpty
                        ? Image.file(
                            File(user.imagePath!),
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.person_rounded,
                              size: 40,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(
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
                      'Penyewa',
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
                          onTap: () => Get.toNamed(
                            AppRoutes.editProfile,
                            arguments: user,
                          ),
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
                          icon: Iconsax.document_text,
                          label: 'Riwayat Sewa',
                          onTap: onBookingTap,
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
                          onTap: () => _onLogout(auth),
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
    });
  }

  void _onLogout(AuthController auth) {
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
            onPressed: () {
              Get.back();
              auth.logout();
            },
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
    return Material(
      type: MaterialType.transparency,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        leading: Icon(icon,
            size: 20,
            color: isDestructive ? AppColors.danger : AppColors.textSecondary),
        title: Text(label,
            style: AppTextStyles.bodyMedium.copyWith(color: color)),
        trailing: Icon(Icons.chevron_right_rounded,
            size: 18, color: AppColors.border),
      ),
    );
  }
}
