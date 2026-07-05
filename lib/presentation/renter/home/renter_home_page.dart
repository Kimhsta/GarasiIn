import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/widgets/garage_card.dart';
import '../../../core/widgets/app_status_badge.dart';
import '../../../core/widgets/section_title.dart';
import '../../../data/dummy/dummy_data.dart';

class RenterHomePage extends StatefulWidget {
  const RenterHomePage({super.key});

  @override
  State<RenterHomePage> createState() => _RenterHomePageState();
}

class _RenterHomePageState extends State<RenterHomePage> {
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
          _HomeTab(),
          _SearchTab(),
          _BookingHistoryTab(),
          _ProfileTab(),
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

// ─── Home Tab ─────────────────────────────────────────────────────────────

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    final renter = DummyData.renterUser;
    final garages = DummyData.availableGarages;

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(renter),
            _buildSearchBar(),
            _buildPriceFilters(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SectionTitle(
                title: 'Rekomendasi Garasi',
                actionLabel: 'Semua',
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
                itemBuilder: (_, i) => GarageCard(garage: garages[i]),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(UserModel renter) {
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
                  'Halo, ${renter.name.split(' ').first} 👋',
                  style: AppTextStyles.headingMedium,
                ),
                const SizedBox(height: 2),
                Text(
                  'Cari garasi aman dan nyaman',
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

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              const Icon(Iconsax.search_normal,
                  size: 18, color: AppColors.textSecondary),
              const SizedBox(width: 10),
              Text('Cari garasi di Solo...',
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.textSecondary)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceFilters() {
    const filters = [
      'Semua',
      '< 300rb',
      '300–500rb',
      '500rb–1jt',
      '> 1jt',
    ];
    return SizedBox(
      height: 36,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) => _FilterChip(
          label: filters[i],
          isSelected: i == 0,
        ),
      ),
    );
  }
}

// ─── Search Tab ───────────────────────────────────────────────────────────

class _SearchTab extends StatefulWidget {
  const _SearchTab();

  @override
  State<_SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<_SearchTab> {
  final _searchCtrl = TextEditingController();
  List<GarageModel> _results = [];

  @override
  void initState() {
    super.initState();
    _results = DummyData.availableGarages;
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    setState(() {
      _results = DummyData.garages
          .where((g) =>
              g.name.toLowerCase().contains(query.toLowerCase()) ||
              g.address.toLowerCase().contains(query.toLowerCase()) ||
              g.city.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            color: AppColors.surface,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Cari Garasi', style: AppTextStyles.headingMedium),
                const SizedBox(height: 12),
                TextField(
                  controller: _searchCtrl,
                  onChanged: _onSearch,
                  style: AppTextStyles.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'Cari nama garasi atau lokasi...',
                    prefixIcon: const Icon(Iconsax.search_normal,
                        size: 18, color: AppColors.textSecondary),
                    suffixIcon: _searchCtrl.text.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              _searchCtrl.clear();
                              _onSearch('');
                            },
                            child: const Icon(Icons.close,
                                size: 18, color: AppColors.textSecondary),
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _FilterPill(label: 'Semua Harga', isSelected: true, onTap: () {}),
                      const SizedBox(width: 8),
                      _FilterPill(label: '< Rp300rb', isSelected: false, onTap: () {}),
                      const SizedBox(width: 8),
                      _FilterPill(label: 'Rp300–500rb', isSelected: false, onTap: () {}),
                      const SizedBox(width: 8),
                      _FilterPill(label: 'Rp500rb–1jt', isSelected: false, onTap: () {}),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: _results.isEmpty
                ? _buildEmpty()
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _results.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) => GarageCard(garage: _results[i]),
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

// ─── Booking History Tab ──────────────────────────────────────────────────

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

  List<BookingModel> _getFiltered(BookingStatus? status) {
    final all = DummyData.renterBookings;
    if (status == null) return all;
    return all.where((b) => b.status == status).toList();
  }

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
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildList(_getFiltered(null)),
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
        final b = list[i];
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
                    Text(b.garageName,
                        style: AppTextStyles.headingSmall.copyWith(
                          fontSize: 14,
                        )),
                    const SizedBox(height: 4),
                    Text(
                      '${_dateFormat.format(b.startDate)} – ${_dateFormat.format(b.endDate)}',
                      style: AppTextStyles.caption,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _priceFormat.format(b.totalPrice),
                      style: AppTextStyles.price.copyWith(fontSize: 13),
                    ),
                  ],
                ),
              ),
              AppStatusBadge(bookingStatus: b.status),
            ],
          ),
        );
      },
    );
  }
}

// ─── Profile Tab ──────────────────────────────────────────────────────────

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    final user = DummyData.renterUser;

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
                        icon: Iconsax.document_text,
                        label: 'Riwayat Sewa',
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
      title: Text(label,
          style: AppTextStyles.bodyMedium.copyWith(color: color)),
      trailing: Icon(Icons.chevron_right_rounded,
          size: 18, color: AppColors.border),
    );
  }
}

// ─── Filter Chip (Home Tab) ──────────────────────────────────────────────

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _FilterChip({required this.label, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : AppColors.surface,
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
    );
  }
}
