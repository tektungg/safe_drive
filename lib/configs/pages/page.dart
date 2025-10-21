import 'package:get/get.dart';
import 'package:safe_drive/configs/routes/route.dart';
import 'package:safe_drive/features/edit_profile/bindings/edit_profile_binding.dart';
import 'package:safe_drive/features/edit_profile/screen/ui/edit_profile_screen.dart';
import 'package:safe_drive/features/home/bindings/home_binding.dart';
import 'package:safe_drive/features/home/screen/ui/home_screen.dart';
import 'package:safe_drive/features/no_connection/view/ui/no_connection_screen.dart';
import 'package:safe_drive/features/scanner/bindings/scanner_binding.dart';
import 'package:safe_drive/features/scanner/screen/ui/scanner_screen.dart';
import 'package:safe_drive/features/setting/bindings/setting_binding.dart';
import 'package:safe_drive/features/setting/screen/ui/setting_screen.dart';
import 'package:safe_drive/features/sign_up/bindings/sign_up_binding.dart';
import 'package:safe_drive/features/sign_up/screen/ui/sign_up_screen.dart';
import 'package:safe_drive/features/splash/bindings/splash_binding.dart';
import 'package:safe_drive/features/splash/view/ui/splash_screen.dart';
import 'package:safe_drive/features/sign_in/bindings/sign_in_binding.dart';
import 'package:safe_drive/features/sign_in/screen/ui/sign_in_screen.dart';

abstract class Pages {
  static final pages = [
    GetPage(
      name: Routes.splashRoute,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.noConnection,
      page: () => const NoConnectionScreen(),
    ),
    GetPage(
      name: Routes.signInRoute,
      page: () => const SignInScreen(),
      binding: SignInBinding(),
    ),
    GetPage(
      name: Routes.settingRoute,
      page: () => const SettingScreen(),
      binding: SettingBinding(),
    ),
    GetPage(
      name: Routes.homeRoute,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.scannerRoute,
      page: () => const ScannerScreen(),
      binding: ScannerBinding(),
    ),
    GetPage(
      name: Routes.editProfileRoute,
      page: () => const EditProfileScreen(),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: Routes.signUpRoute,
      page: () => const SignUpScreen(),
      binding: SignUpBinding(),
    ),
  ];
}
