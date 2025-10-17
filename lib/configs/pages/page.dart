import 'package:get/get.dart';
import 'package:safe_drive/configs/routes/route.dart';
import 'package:safe_drive/features/no_connection/view/ui/no_connection_screen.dart';
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
  ];
}
