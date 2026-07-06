import 'package:get/get.dart';
import '../../../data/models/garage_model.dart';
import '../../../data/repositories/garage_repository.dart';

/// Controller for renter home page
class RenterHomeController extends GetxController {
  final GarageRepository _garageRepo = GarageRepository();

  final RxList<GarageModel> garages = <GarageModel>[].obs;
  final RxList<GarageModel> searchResults = <GarageModel>[].obs;
  final RxString searchKeyword = ''.obs;
  final RxInt selectedPriceFilter = (-1).obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadGarages();
  }

  Future<void> loadGarages() async {
    isLoading.value = true;
    try {
      garages.value = await _garageRepo.getAvailableGarages();
      searchResults.value = garages;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadAllGarages() async {
    isLoading.value = true;
    try {
      garages.value = await _garageRepo.getAllGarages();
      searchResults.value = garages;
    } finally {
      isLoading.value = false;
    }
  }

  void searchGarages(String keyword) {
    searchKeyword.value = keyword;
    if (keyword.isEmpty) {
      _applyPriceFilter(garages);
      return;
    }
    final kw = keyword.toLowerCase();
    final filtered = garages.where((g) =>
        g.name.toLowerCase().contains(kw) ||
        g.address.toLowerCase().contains(kw) ||
        g.city.toLowerCase().contains(kw)).toList();
    _applyPriceFilter(filtered);
  }

  void filterByPrice(int categoryIndex) {
    selectedPriceFilter.value = categoryIndex;
    if (searchKeyword.isEmpty) {
      _applyPriceFilter(garages);
    } else {
      searchGarages(searchKeyword.value);
    }
  }

  void _applyPriceFilter(List<GarageModel> source) {
    switch (selectedPriceFilter.value) {
      case 2: // Murah < 300rb
        searchResults.value =
            source.where((g) => g.pricePerMonth < 300000).toList();
        break;
      case 3: // Premium > 500rb
        searchResults.value =
            source.where((g) => g.pricePerMonth > 500000).toList();
        break;
      case 4: // 300-500rb
        searchResults.value = source
            .where((g) =>
                g.pricePerMonth >= 300000 && g.pricePerMonth <= 500000)
            .toList();
        break;
      default:
        searchResults.value = source;
    }
  }
}
