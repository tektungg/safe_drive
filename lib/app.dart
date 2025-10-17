import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:safe_drive/configs/pages/page.dart';
import 'package:safe_drive/configs/routes/route.dart';
import 'package:safe_drive/configs/themes/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    /// Screen Util Init berdasarkan ukuran iphone xr
    return ScreenUtilInit(
      designSize: const Size(414, 896),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GestureDetector(
          onTap: () => Get.focusScope?.unfocus(),
          child: GetMaterialApp(
            title: 'Safe Drive',
            debugShowCheckedModeBanner: false,
            initialRoute: Routes.splashRoute,
            theme: themeLight,
            defaultTransition: Transition.native,
            getPages: Pages.pages,
          ),
        );
      },
    );
  }
}
