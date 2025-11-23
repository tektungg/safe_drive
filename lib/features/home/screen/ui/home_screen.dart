import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:safe_drive/features/home/controllers/home_controller.dart';
import 'package:safe_drive/features/home/screen/components/home_greeting_component.dart';
import 'package:safe_drive/features/home/screen/components/home_quick_actions_component.dart';
import 'package:safe_drive/features/home/screen/components/home_recent_activity_component.dart';
import 'package:safe_drive/features/home/screen/components/home_stats_component.dart';
import 'package:safe_drive/shared/widgets/custom_app_bar_widget.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        centerTitle: false,
        title: 'Safe Drive',
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: controller.signOut,
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HomeGreetingComponent(),
            SizedBox(height: 32.h),
            const HomeStatsComponent(),
            SizedBox(height: 32.h),
            const HomeRecentActivityComponent(),
            SizedBox(height: 32.h),
            const HomeQuickActionsComponent(),
          ],
        ),
      ),
    );
  }
}
