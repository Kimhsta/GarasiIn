import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/utils/session_manager.dart';
import '../../../data/models/garage_model.dart';
import '../../../data/repositories/garage_repository.dart';

/// Controller for owner garage management
class OwnerGarageController extends GetxController {
  final GarageRepository _garageRepo = GarageRepository();
  final _session = SessionManager.instance;

  final RxList<GarageModel> garages = <GarageModel>[].obs;
  final RxBool isLoading = false.obs;
  final Rx<String?> selectedImagePath = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    loadOwnerGarages();
  }

  Future<void> loadOwnerGarages() async {
    isLoading.value = true;
    try {
      final ownerId = _session.currentUserId;
      if (ownerId != null) {
        garages.value = await _garageRepo.getGaragesByOwner(ownerId);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> createGarage({
    required String name,
    required String address,
    required String city,
    required double length,
    required double width,
    required int pricePerMonth,
    required String roadAccess,
    String description = '',
    List<String> facilities = const [],
  }) async {
    isLoading.value = true;
    try {
      final ownerId = _session.currentUserId;
      if (ownerId == null) return false;

      final garage = GarageModel(
        ownerId: ownerId,
        name: name,
        address: address,
        city: city,
        length: length,
        width: width,
        pricePerMonth: pricePerMonth,
        roadAccess: roadAccess,
        description: description,
        facilities: facilities,
        imagePath: selectedImagePath.value,
      );
      await _garageRepo.createGarage(garage);
      selectedImagePath.value = null;
      await loadOwnerGarages();
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Gagal menambah garasi: $e',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateGarage({
    required int id,
    required String name,
    required String address,
    required String city,
    required double length,
    required double width,
    required int pricePerMonth,
    required String roadAccess,
    String description = '',
    List<String> facilities = const [],
    String? imagePath,
  }) async {
    isLoading.value = true;
    try {
      final ownerId = _session.currentUserId;
      if (ownerId == null) return false;

      final garage = GarageModel(
        id: id,
        ownerId: ownerId,
        name: name,
        address: address,
        city: city,
        length: length,
        width: width,
        pricePerMonth: pricePerMonth,
        roadAccess: roadAccess,
        description: description,
        facilities: facilities,
        imagePath: imagePath ?? selectedImagePath.value,
      );
      await _garageRepo.updateGarage(garage);
      selectedImagePath.value = null;
      await loadOwnerGarages();
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Gagal memperbarui garasi: $e',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteGarage(int id) async {
    isLoading.value = true;
    try {
      await _garageRepo.deleteGarage(id);
      await loadOwnerGarages();
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghapus garasi: $e',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickGarageImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );
    if (pickedFile != null) {
      selectedImagePath.value = pickedFile.path;
    }
  }
}
