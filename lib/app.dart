import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:safe_drive/configs/pages/page.dart';
import 'package:safe_drive/configs/routes/route.dart';
import 'package:safe_drive/configs/themes/theme.dart';
import 'package:safe_drive/shared/widgets/custom_offline_banner_widget.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    /// Screen Util Init berdasarkan ukuran iphone xr
    return ScreenUtilInit(
      designSize: const Size(414, 896),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GestureDetector(
          onTap: () => Get.focusScope?.unfocus(),
          child: GetMaterialApp(
            navigatorKey: Get.key,
            title: 'Safe Drive',
            debugShowCheckedModeBanner: false,
            initialRoute: Routes.splashRoute,
            theme: themeLight,
            defaultTransition: Transition.native,
            getPages: Pages.pages,
            builder: (context, child) {
              return CustomOfflineBannerWidget(
                showRetryButton: true,
                showConnectionType: true,
                child: child ?? const SizedBox.shrink(),
              );
            },
          ),
        );
      },
    );
  }
}
