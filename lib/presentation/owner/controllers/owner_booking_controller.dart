import 'package:get/get.dart';
import '../../../core/utils/session_manager.dart';
import '../../../data/models/rental_model.dart';
import '../../../data/repositories/rental_repository.dart';

/// Controller for owner booking management
class OwnerBookingController extends GetxController {
  final RentalRepository _rentalRepo = RentalRepository();
  final _session = SessionManager.instance;

  final RxList<RentalModel> allRentals = <RentalModel>[].obs;
  final RxBool isLoading = false.obs;

  List<RentalModel> get pendingRentals =>
      allRentals.where((r) => r.isPending).toList();

  List<RentalModel> get acceptedRentals =>
      allRentals.where((r) => r.isAccepted).toList();

  List<RentalModel> get rejectedRentals =>
      allRentals.where((r) => r.isRejected).toList();

  @override
  void onInit() {
    super.onInit();
    loadOwnerBookings();
  }

  Future<void> loadOwnerBookings() async {
    isLoading.value = true;
    try {
      final ownerId = _session.currentUserId;
      if (ownerId != null) {
        allRentals.value = await _rentalRepo.getRentalsByOwner(ownerId);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> approveRental(int rentalId) async {
    try {
      await _rentalRepo.approveRental(rentalId);
      await loadOwnerBookings();
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Gagal menerima booking: $e',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
  }

  Future<bool> rejectRental(int rentalId) async {
    try {
      await _rentalRepo.rejectRental(rentalId);
      await loadOwnerBookings();
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Gagal menolak booking: $e',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
  }
}
