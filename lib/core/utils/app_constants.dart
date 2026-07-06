/// App-wide constants for GarasiIn
class AppConstants {
  AppConstants._();

  static const String dbName = 'garasiin.db';
  static const int dbVersion = 1;

  // Session keys
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyCurrentUserId = 'current_user_id';
  static const String keyCurrentUserRole = 'current_user_role';

  // Roles
  static const String roleOwner = 'owner';
  static const String roleRenter = 'renter';

  // Garage status
  static const String statusAvailable = 'available';
  static const String statusRented = 'rented';

  // Rental status
  static const String rentalPending = 'pending';
  static const String rentalAccepted = 'accepted';
  static const String rentalRejected = 'rejected';
  static const String rentalCancelled = 'cancelled';
}
