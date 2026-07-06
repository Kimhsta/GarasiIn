import 'package:shared_preferences/shared_preferences.dart';
import 'app_constants.dart';

/// Manages login session using SharedPreferences
class SessionManager {
  SessionManager._();
  static final SessionManager instance = SessionManager._();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  SharedPreferences get _p => _prefs!;

  // ─── Login Session ──────────────────────────────────────────────────────

  Future<void> saveSession({
    required int userId,
    required String role,
  }) async {
    await _p.setBool(AppConstants.keyIsLoggedIn, true);
    await _p.setInt(AppConstants.keyCurrentUserId, userId);
    await _p.setString(AppConstants.keyCurrentUserRole, role);
  }

  Future<void> clearSession() async {
    await _p.remove(AppConstants.keyIsLoggedIn);
    await _p.remove(AppConstants.keyCurrentUserId);
    await _p.remove(AppConstants.keyCurrentUserRole);
  }

  bool get isLoggedIn => _p.getBool(AppConstants.keyIsLoggedIn) ?? false;

  int? get currentUserId => _p.getInt(AppConstants.keyCurrentUserId);

  String? get currentUserRole =>
      _p.getString(AppConstants.keyCurrentUserRole);

  bool get isOwner => currentUserRole == AppConstants.roleOwner;

  bool get isRenter => currentUserRole == AppConstants.roleRenter;
}
