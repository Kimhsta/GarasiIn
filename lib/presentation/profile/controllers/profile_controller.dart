import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/utils/session_manager.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/user_repository.dart';
import '../../auth/controllers/auth_controller.dart';

class ProfileController extends GetxController {
  final UserRepository _userRepo = UserRepository();
  final _session = SessionManager.instance;

  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final userId = _session.currentUserId;
    if (userId != null) {
      user.value = await _userRepo.getUserById(userId);
    }
  }

  Future<bool> updateProfile({
    required String name,
    required String email,
    required String phone,
    String? imagePath,
  }) async {
    isLoading.value = true;
    try {
      final userId = _session.currentUserId;
      if (userId == null) return false;

      final current = user.value ?? await _userRepo.getUserById(userId);
      if (current == null) return false;

      final updated = current.copyWith(
        name: name, email: email, phone: phone,
        imagePath: imagePath ?? current.imagePath,
      );
      await _userRepo.updateUser(updated);
      user.value = updated;
      if (Get.isRegistered<AuthController>()) {
        Get.find<AuthController>().currentUser.value = updated;
      }
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Gagal memperbarui profil: $e',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> changePassword(String oldPass, String newPass) async {
    isLoading.value = true;
    try {
      final userId = _session.currentUserId;
      if (userId == null) return false;
      final result = await _userRepo.changePassword(userId, oldPass, newPass);
      if (result == 0) {
        Get.snackbar('Gagal', 'Password lama salah',
            snackPosition: SnackPosition.BOTTOM);
        return false;
      }
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengubah password: $e',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<String?> pickProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery, maxWidth: 800, maxHeight: 800,
      imageQuality: 85,
    );
    return pickedFile?.path;
  }
}
