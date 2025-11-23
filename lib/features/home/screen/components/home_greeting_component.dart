import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:safe_drive/features/home/controllers/home_controller.dart';
import 'package:safe_drive/shared/styles/text_style.dart';

class HomeGreetingComponent extends GetView<HomeController> {
  const HomeGreetingComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, ${controller.userName.value}! 👋',
              style: TextStyles.greeting,
            ),
            SizedBox(height: 4.h),
            Text(
              controller.getGreeting(),
              style: TextStyles.authSubtitle,
            ),
          ],
        ));
  }
}
