import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/garage_card.dart';
import '../../../data/models/garage_model.dart';
import '../../../data/repositories/garage_repository.dart';

class RenterSearchPage extends StatefulWidget {
  const RenterSearchPage({super.key});

  @override
  State<RenterSearchPage> createState() => _RenterSearchPageState();
}

class _RenterSearchPageState extends State<RenterSearchPage> {
  final _searchCtrl = TextEditingController();
  final _garageRepo = GarageRepository();
  List<GarageModel> _allGarages = [];
  List<GarageModel> _results = [];

  @override
  void initState() {
    super.initState();
    _loadGarages();
  }

  Future<void> _loadGarages() async {
    _allGarages = await _garageRepo.getAvailableGarages();
    setState(() {
      _results = _allGarages;
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        _results = _allGarages;
      } else {
        _results = _allGarages
            .where((g) =>
                g.name.toLowerCase().contains(query.toLowerCase()) ||
                g.address.toLowerCase().contains(query.toLowerCase()) ||
                g.city.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Cari Garasi'),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Iconsax.arrow_left, size: 20),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            color: AppColors.surface,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: _searchCtrl,
              autofocus: true,
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
          ),

          // Price Filter
          Container(
            color: AppColors.surface,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FilterPill(label: 'Semua Harga', isSelected: true, onTap: () {}),
                  const SizedBox(width: 8),
                  _FilterPill(label: '< Rp300rb', isSelected: false, onTap: () {}),
                  const SizedBox(width: 8),
                  _FilterPill(
                      label: 'Rp300–500rb', isSelected: false, onTap: () {}),
                  const SizedBox(width: 8),
                  _FilterPill(
                      label: 'Rp500rb–1jt', isSelected: false, onTap: () {}),
                ],
              ),
            ),
          ),

          // Divider
          const Divider(height: 1),

          // Results
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
          Text('Garasi tidak ditemukan',
              style: AppTextStyles.headingSmall),
          const SizedBox(height: 6),
          Text(
            'Coba kata kunci lain',
            style: AppTextStyles.bodySmall,
          ),
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
