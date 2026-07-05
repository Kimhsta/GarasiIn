abstract class AppRoutes {
  static const splash = '/splash';
  static const login = '/login';
  static const register = '/register';

  // Owner routes
  static const ownerDashboard = '/owner/dashboard';
  static const ownerGarageList = '/owner/garages';
  static const ownerGarageAdd = '/owner/garages/add';
  static const ownerGarageEdit = '/owner/garages/edit';
  static const ownerBookingIncoming = '/owner/bookings';
  static const ownerRentalHistory = '/owner/rental-history';

  // Renter routes
  static const renterHome = '/renter/home';
  static const renterSearch = '/renter/search';
  static const garageDetail = '/garage/detail';
  static const rentalApply = '/rental/apply';
  static const rentalContract = '/rental/contract';
  static const rentalSignature = '/rental/signature';
  static const renterRentalHistory = '/renter/rental-history';

  // Shared
  static const profile = '/profile';
}
