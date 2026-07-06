import 'package:get/get.dart';

import '../../presentation/splash/splash_screen.dart';
import '../../presentation/auth/login_page.dart';
import '../../presentation/auth/register_page.dart';
import '../../presentation/owner/dashboard/owner_dashboard_page.dart';
import '../../presentation/owner/garage/owner_garage_list_page.dart';
import '../../presentation/owner/garage/owner_garage_form_page.dart';
import '../../presentation/owner/booking/owner_booking_page.dart';
import '../../presentation/owner/rental_history/owner_rental_history_page.dart';
import '../../presentation/renter/home/renter_home_page.dart';
import '../../presentation/renter/search/renter_search_page.dart';
import '../../presentation/garage/garage_detail_page.dart';
import '../../presentation/rental/rental_apply_page.dart';
import '../../presentation/rental/rental_contract_page.dart';
import '../../presentation/rental/rental_signature_page.dart';
import '../../presentation/renter/rental_history/renter_rental_history_page.dart';
import '../../presentation/profile/profile_page.dart';
import '../../presentation/profile/edit_profile_page.dart';
import '../../presentation/profile/change_password_page.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterPage(),
      transition: Transition.rightToLeft,
    ),

    // Owner
    GetPage(
      name: AppRoutes.ownerDashboard,
      page: () => const OwnerDashboardPage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.ownerGarageList,
      page: () => const OwnerGarageListPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.ownerGarageAdd,
      page: () => OwnerGarageFormPage(isEdit: false),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.ownerGarageEdit,
      page: () => OwnerGarageFormPage(isEdit: true),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.ownerBookingIncoming,
      page: () => const OwnerBookingPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.ownerRentalHistory,
      page: () => const OwnerRentalHistoryPage(),
      transition: Transition.rightToLeft,
    ),

    // Renter
    GetPage(
      name: AppRoutes.renterHome,
      page: () => const RenterHomePage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.renterSearch,
      page: () => const RenterSearchPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.garageDetail,
      page: () => const GarageDetailPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.rentalApply,
      page: () => const RentalApplyPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.rentalContract,
      page: () => const RentalContractPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.rentalSignature,
      page: () => const RentalSignaturePage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.renterRentalHistory,
      page: () => const RenterRentalHistoryPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfilePage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.editProfile,
      page: () => const EditProfilePage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.changePassword,
      page: () => const ChangePasswordPage(),
      transition: Transition.rightToLeft,
    ),
  ];
}
