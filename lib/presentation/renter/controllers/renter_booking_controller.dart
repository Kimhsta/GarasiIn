import 'package:get/get.dart';
import '../../../core/utils/session_manager.dart';
import '../../../data/models/rental_model.dart';
import '../../../data/repositories/rental_repository.dart';

/// Controller for renter booking/rental history
class RenterBookingController extends GetxController {
  final RentalRepository _rentalRepo = RentalRepository();
  final _session = SessionManager.instance;

  final RxList<RentalModel> rentals = <RentalModel>[].obs;
  final RxBool isLoading = false.obs;

  List<RentalModel> get pendingRentals =>
      rentals.where((r) => r.isPending).toList();
  List<RentalModel> get acceptedRentals =>
      rentals.where((r) => r.isAccepted).toList();
  List<RentalModel> get rejectedRentals =>
      rentals.where((r) => r.isRejected).toList();

  @override
  void onInit() {
    super.onInit();
    loadMyRentals();
  }

  Future<void> loadMyRentals() async {
    isLoading.value = true;
    try {
      final renterId = _session.currentUserId;
      if (renterId != null) {
        rentals.value = await _rentalRepo.getRentalsByRenter(renterId);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> cancelRental(int rentalId) async {
    try {
      await _rentalRepo.cancelRental(rentalId);
      await loadMyRentals();
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Gagal membatalkan booking: $e',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
  }
}
