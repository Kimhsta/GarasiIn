import 'package:get/get.dart';
import '../../../core/utils/session_manager.dart';
import '../../../data/models/garage_model.dart';
import '../../../data/models/rental_model.dart';
import '../../../data/repositories/garage_repository.dart';
import '../../../data/repositories/rental_repository.dart';

/// Controller for owner dashboard with statistics
class OwnerDashboardController extends GetxController {
  final GarageRepository _garageRepo = GarageRepository();
  final RentalRepository _rentalRepo = RentalRepository();
  final _session = SessionManager.instance;

  final RxList<GarageModel> garages = <GarageModel>[].obs;
  final RxList<RentalModel> rentals = <RentalModel>[].obs;
  final RxBool isLoading = false.obs;

  int get totalGarages => garages.length;
  int get rentedGarages =>
      garages.where((g) => g.status == 'rented').length;
  int get availableGarages =>
      garages.where((g) => g.status == 'available').length;
  int get pendingBookings =>
      rentals.where((r) => r.isPending).length;

  List<RentalModel> get pendingRentalsList =>
      rentals.where((r) => r.isPending).toList();

  @override
  void onInit() {
    super.onInit();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    isLoading.value = true;
    try {
      final ownerId = _session.currentUserId;
      if (ownerId != null) {
        garages.value = await _garageRepo.getGaragesByOwner(ownerId);
        rentals.value = await _rentalRepo.getRentalsByOwner(ownerId);
      }
    } finally {
      isLoading.value = false;
    }
  }
}
