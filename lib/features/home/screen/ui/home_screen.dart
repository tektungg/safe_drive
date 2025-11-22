import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:safe_drive/features/home/controllers/home_controller.dart';
import 'package:safe_drive/shared/styles/color_style.dart';
import 'package:safe_drive/shared/styles/text_style.dart';
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
            // Greeting Section
            Obx(() => Column(
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
                )),

            SizedBox(height: 32.h),

            // Quick Stats Cards
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.directions_car_rounded,
                    label: 'Total Trips',
                    value: '0',
                    color: ColorStyle.primary,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: _StatCard(
                    icon: Icons.timer_rounded,
                    label: 'Driving Hours',
                    value: '0h',
                    color: ColorStyle.success,
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.route_rounded,
                    label: 'Distance',
                    value: '0 km',
                    color: ColorStyle.warning,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: _StatCard(
                    icon: Icons.star_rounded,
                    label: 'Safety Score',
                    value: '0',
                    color: ColorStyle.secondary,
                  ),
                ),
              ],
            ),

            SizedBox(height: 32.h),

            // Recent Activity Section
            Text(
              'Recent Activity',
              style: TextStyles.headlineMedium,
            ),
            SizedBox(height: 16.h),

            // Empty State
            Container(
              padding: EdgeInsets.symmetric(vertical: 48.h),
              decoration: BoxDecoration(
                color: ColorStyle.backgroundDark,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: ColorStyle.border,
                  width: 1,
                ),
              ),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.history_rounded,
                      size: 48.sp,
                      color: ColorStyle.gray400,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'No recent activity',
                      style: TextStyles.emptyStateTitle,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Start your first trip to see activity here',
                      style: TextStyles.emptyStateSubtitle,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 32.h),

            // Quick Actions
            Text(
              'Quick Actions',
              style: TextStyles.headlineMedium,
            ),
            SizedBox(height: 16.h),

            _QuickActionCard(
              icon: Icons.camera_alt_rounded,
              title: 'Start Scanner',
              subtitle: 'Scan traffic signs',
              color: ColorStyle.primary,
              onTap: () {},
            ),

            SizedBox(height: 12.h),

            _QuickActionCard(
              icon: Icons.settings_rounded,
              title: 'Settings',
              subtitle: 'Manage your preferences',
              color: ColorStyle.textSecondary,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              icon,
              size: 20.sp,
              color: color,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            label,
            style: TextStyles.statLabel,
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyles.statValue,
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorStyle.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: ColorStyle.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: ColorStyle.border,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: ColorStyle.shadowLight,
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  icon,
                  size: 24.sp,
                  color: color,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyles.titleMedium,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: TextStyles.bodyMedium,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16.sp,
                color: ColorStyle.gray400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
