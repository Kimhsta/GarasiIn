import 'package:get/get.dart';
import '../../../data/models/garage_model.dart';
import '../../../data/repositories/garage_repository.dart';

/// Controller for garage detail page
class GarageDetailController extends GetxController {
  final GarageRepository _garageRepo = GarageRepository();

  final Rx<GarageModel?> garage = Rx<GarageModel?>(null);
  final RxBool isLoading = false.obs;

  Future<void> loadGarage(int garageId) async {
    isLoading.value = true;
    try {
      garage.value = await _garageRepo.getGarageById(garageId);
    } finally {
      isLoading.value = false;
    }
  }

  void setGarage(GarageModel g) {
    garage.value = g;
  }
}
