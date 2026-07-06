import 'package:get/get.dart';
import '../../../data/models/garage_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/user_repository.dart';

/// Controller for rental apply page
class RentalApplyController extends GetxController {
  final UserRepository _userRepo = UserRepository();

  final Rx<GarageModel?> selectedGarage = Rx<GarageModel?>(null);
  final Rx<DateTime?> startDate = Rx<DateTime?>(null);
  final Rx<DateTime?> endDate = Rx<DateTime?>(null);
  final RxInt totalMonths = 0.obs;
  final RxInt totalPrice = 0.obs;
  final Rxn<UserModel> ownerUser = Rxn<UserModel>(null);

  void setGarage(GarageModel garage) {
    selectedGarage.value = garage;
    _loadOwner(garage.ownerId);
  }

  Future<void> _loadOwner(int ownerId) async {
    ownerUser.value = await _userRepo.getUserById(ownerId);
  }

  void setStartDate(DateTime date) {
    startDate.value = date;
    _calculateTotal();
  }

  void setEndDate(DateTime date) {
    endDate.value = date;
    _calculateTotal();
  }

  void _calculateTotal() {
    if (startDate.value == null || endDate.value == null) return;
    if (endDate.value!.isBefore(startDate.value!)) return;

    final diff = endDate.value!.difference(startDate.value!).inDays;
    totalMonths.value = (diff / 30).ceil().clamp(1, 999);
    totalPrice.value = (selectedGarage.value?.pricePerMonth ?? 0) * totalMonths.value;
  }

  bool validateDates() {
    if (startDate.value == null || endDate.value == null) {
      Get.snackbar('Perhatian', 'Pilih tanggal mulai dan selesai',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    if (endDate.value!.isBefore(startDate.value!) ||
        endDate.value!.isAtSameMomentAs(startDate.value!)) {
      Get.snackbar('Perhatian', 'Tanggal selesai harus setelah tanggal mulai',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    return true;
  }
}
