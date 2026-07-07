import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/utils/session_manager.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/user_repository.dart';

/// Auth controller handling login, register, logout, session
class AuthController extends GetxController {
  final UserRepository _userRepo = UserRepository();
  final _session = SessionManager.instance;

  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;

  /// Check existing session on app start
  Future<void> checkSession() async {
    if (_session.isLoggedIn && _session.currentUserId != null) {
      final user = await _userRepo.getUserById(_session.currentUserId!);
      if (user != null) {
        currentUser.value = user;
        if (_session.isOwner) {
          Get.offAllNamed(AppRoutes.ownerDashboard);
        } else {
          Get.offAllNamed(AppRoutes.renterHome);
        }
        return;
      }
    }
    Get.offAllNamed(AppRoutes.login);
  }

  /// Login with email and password
  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Email dan password wajib diisi',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;
    try {
      final user = await _userRepo.login(email.trim(), password);
      if (user == null) {
        Get.snackbar('Gagal', 'Email atau password salah',
            snackPosition: SnackPosition.BOTTOM);
        return;
      }
      currentUser.value = user;
      await _session.saveSession(userId: user.id!, role: user.role);

      if (user.isOwner) {
        Get.offAllNamed(AppRoutes.ownerDashboard);
      } else {
        Get.offAllNamed(AppRoutes.renterHome);
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  /// Register new user
  Future<void> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String role,
  }) async {
    if (name.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Semua field wajib diisi',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (!GetUtils.isEmail(email.trim())) {
      Get.snackbar('Error', 'Format email tidak valid',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (password.length < 6) {
      Get.snackbar('Error', 'Password minimal 6 karakter',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;
    try {
      // Check email unique
      final existing = await _userRepo.getUserByEmail(email.trim());
      if (existing != null) {
        Get.snackbar('Gagal', 'Email sudah terdaftar',
            snackPosition: SnackPosition.BOTTOM);
        return;
      }

      final user = await _userRepo.register(
        name: name.trim(),
        email: email.trim(),
        phone: phone.trim(),
        password: password,
        role: role,
      );
      currentUser.value = user;
      await _session.saveSession(userId: user.id!, role: user.role);

      if (user.isOwner) {
        Get.offAllNamed(AppRoutes.ownerDashboard);
      } else {
        Get.offAllNamed(AppRoutes.renterHome);
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  /// Logout and clear session
  Future<void> logout() async {
    await _session.clearSession();
    currentUser.value = null;
    Get.offAllNamed(AppRoutes.login);
  }

  /// Reload current user from database
  Future<void> reloadUser() async {
    if (_session.currentUserId != null) {
      currentUser.value =
          await _userRepo.getUserById(_session.currentUserId!);
    }
  }
}
