import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/theme/app_theme.dart';
import 'core/utils/session_manager.dart';
import 'data/datasources/local/database_helper.dart';
import 'presentation/auth/controllers/auth_controller.dart';
import 'presentation/owner/controllers/owner_dashboard_controller.dart';
import 'presentation/owner/controllers/owner_garage_controller.dart';
import 'presentation/owner/controllers/owner_booking_controller.dart';
import 'presentation/renter/controllers/renter_home_controller.dart';
import 'presentation/renter/controllers/renter_booking_controller.dart';
import 'presentation/profile/controllers/profile_controller.dart';
import 'presentation/garage/controllers/garage_detail_controller.dart';
import 'presentation/rental/controllers/rental_apply_controller.dart';
import 'presentation/rental/controllers/rental_contract_controller.dart';
import 'presentation/rental/controllers/rental_signature_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);

  // Initialize database
  await DatabaseHelper.instance.database;

  // Initialize session manager
  await SessionManager.instance.init();

  // Register GetX controllers
  Get.put(AuthController(), permanent: true);
  Get.lazyPut(() => OwnerDashboardController());
  Get.lazyPut(() => OwnerGarageController());
  Get.lazyPut(() => OwnerBookingController());
  Get.lazyPut(() => RenterHomeController());
  Get.lazyPut(() => RenterBookingController());
  Get.lazyPut(() => ProfileController());
  Get.lazyPut(() => GarageDetailController());
  Get.lazyPut(() => RentalApplyController());
  Get.lazyPut(() => RentalContractController());
  Get.lazyPut(() => RentalSignatureController());

  runApp(const GarasiInApp());
}

class GarasiInApp extends StatelessWidget {
  const GarasiInApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GarasiIn',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
      defaultTransition: Transition.rightToLeft,
    );
  }
}
