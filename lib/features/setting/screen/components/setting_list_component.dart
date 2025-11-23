import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:safe_drive/features/setting/controllers/setting_controller.dart';
import 'package:safe_drive/shared/styles/color_style.dart';
import 'package:safe_drive/shared/widgets/custom_list_tile_widget.dart';

/// List component for the Settings screen
///
/// Displays all settings options grouped by categories
class SettingListComponent extends GetView<SettingController> {
  const SettingListComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Account Settings Section
        const CustomListTileSectionHeader(title: 'Account'),
        _buildAccountSettings(),

        // App Settings Section
        const CustomListTileSectionHeader(title: 'App Settings'),
        _buildAppSettings(),

        // Driving Settings Section
        const CustomListTileSectionHeader(title: 'Driving'),
        _buildDrivingSettings(),

        // Support Section
        const CustomListTileSectionHeader(title: 'Support'),
        _buildSupportSettings(),

        // About Section
        const CustomListTileSectionHeader(title: 'About'),
        _buildAboutSettings(),

        SizedBox(height: 24.h),

        // Logout Button
        _buildLogoutButton(),

        SizedBox(height: 40.h),
      ],
    );
  }

  /// Account Settings
  Widget _buildAccountSettings() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: ColorStyle.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: ColorStyle.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          CustomListTileWidget(
            leading: Icons.person_outline,
            title: 'Personal Information',
            subtitle: 'Update your personal details',
            showIconBackground: true,
            iconBackgroundColor: ColorStyle.primary.withValues(alpha: 0.1),
            iconColor: ColorStyle.primary,
            showDivider: true,
            onTap: () => controller.navigateToPersonalInfo(),
          ),
          CustomListTileWidget(
            leading: Icons.lock_outline,
            title: 'Change Password',
            subtitle: 'Update your password',
            showIconBackground: true,
            iconBackgroundColor: ColorStyle.info.withValues(alpha: 0.1),
            iconColor: ColorStyle.info,
            showDivider: true,
            onTap: () => controller.navigateToChangePassword(),
          ),
          CustomListTileWidget(
            leading: Icons.shield_outlined,
            title: 'Privacy & Security',
            subtitle: 'Manage your privacy settings',
            showIconBackground: true,
            iconBackgroundColor: ColorStyle.success.withValues(alpha: 0.1),
            iconColor: ColorStyle.success,
            onTap: () => controller.navigateToPrivacySecurity(),
          ),
        ],
      ),
    );
  }

  /// App Settings
  Widget _buildAppSettings() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: ColorStyle.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: ColorStyle.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Obx(
            () => CustomListTileWidget(
              leading: Icons.notifications_outlined,
              title: 'Notifications',
              subtitle: controller.notificationsEnabled.value
                  ? 'Enabled'
                  : 'Disabled',
              showIconBackground: true,
              iconBackgroundColor: ColorStyle.warning.withValues(alpha: 0.1),
              iconColor: ColorStyle.warning,
              showDivider: true,
              trailing: Switch(
                value: controller.notificationsEnabled.value,
                onChanged: (value) => controller.toggleNotifications(value),
                activeThumbColor: ColorStyle.primary,
              ),
            ),
          ),
          Obx(
            () => CustomListTileWidget(
              leading: Icons.volume_up_outlined,
              title: 'Sound Effects',
              subtitle: controller.soundEnabled.value ? 'On' : 'Off',
              showIconBackground: true,
              iconBackgroundColor: ColorStyle.info.withValues(alpha: 0.1),
              iconColor: ColorStyle.info,
              showDivider: true,
              trailing: Switch(
                value: controller.soundEnabled.value,
                onChanged: (value) => controller.toggleSound(value),
                activeThumbColor: ColorStyle.primary,
              ),
            ),
          ),
          CustomListTileWidget(
            leading: Icons.language_outlined,
            title: 'Language',
            subtitle: 'English',
            showIconBackground: true,
            iconBackgroundColor: ColorStyle.secondary.withValues(alpha: 0.1),
            iconColor: ColorStyle.secondary,
            onTap: () => controller.navigateToLanguage(),
          ),
        ],
      ),
    );
  }

  /// Driving Settings
  Widget _buildDrivingSettings() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: ColorStyle.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: ColorStyle.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          CustomListTileWidget(
            leading: Icons.remove_red_eye_outlined,
            title: 'Drowsiness Detection',
            subtitle: 'Configure sensitivity settings',
            showIconBackground: true,
            iconBackgroundColor: ColorStyle.primary.withValues(alpha: 0.1),
            iconColor: ColorStyle.primary,
            showDivider: true,
            onTap: () => controller.navigateToDrowsinessSettings(),
          ),
          CustomListTileWidget(
            leading: Icons.traffic_outlined,
            title: 'Traffic Sign Recognition',
            subtitle: 'Manage sign detection settings',
            showIconBackground: true,
            iconBackgroundColor: ColorStyle.danger.withValues(alpha: 0.1),
            iconColor: ColorStyle.danger,
            showDivider: true,
            onTap: () => controller.navigateToTrafficSignSettings(),
          ),
          Obx(
            () => CustomListTileWidget(
              leading: Icons.location_on_outlined,
              title: 'Location Services',
              subtitle: controller.locationEnabled.value
                  ? 'Enabled'
                  : 'Disabled',
              showIconBackground: true,
              iconBackgroundColor: ColorStyle.success.withValues(alpha: 0.1),
              iconColor: ColorStyle.success,
              trailing: Switch(
                value: controller.locationEnabled.value,
                onChanged: (value) => controller.toggleLocation(value),
                activeThumbColor: ColorStyle.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Support Settings
  Widget _buildSupportSettings() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: ColorStyle.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: ColorStyle.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          CustomListTileWidget(
            leading: Icons.help_outline,
            title: 'Help & FAQ',
            subtitle: 'Get help and support',
            showIconBackground: true,
            iconBackgroundColor: ColorStyle.info.withValues(alpha: 0.1),
            iconColor: ColorStyle.info,
            showDivider: true,
            onTap: () => controller.navigateToHelp(),
          ),
          CustomListTileWidget(
            leading: Icons.feedback_outlined,
            title: 'Send Feedback',
            subtitle: 'Share your thoughts',
            showIconBackground: true,
            iconBackgroundColor: ColorStyle.warning.withValues(alpha: 0.1),
            iconColor: ColorStyle.warning,
            showDivider: true,
            onTap: () => controller.navigateToFeedback(),
          ),
          CustomListTileWidget(
            leading: Icons.star_outline,
            title: 'Rate App',
            subtitle: 'Rate us on the store',
            showIconBackground: true,
            iconBackgroundColor: ColorStyle.warning.withValues(alpha: 0.1),
            iconColor: ColorStyle.warning,
            onTap: () => controller.rateApp(),
          ),
        ],
      ),
    );
  }

  /// About Settings
  Widget _buildAboutSettings() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: ColorStyle.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: ColorStyle.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          CustomListTileWidget(
            leading: Icons.info_outline,
            title: 'About Safe Drive',
            subtitle: 'Learn more about the app',
            showIconBackground: true,
            iconBackgroundColor: ColorStyle.primary.withValues(alpha: 0.1),
            iconColor: ColorStyle.primary,
            showDivider: true,
            onTap: () => controller.navigateToAbout(),
          ),
          CustomListTileWidget(
            leading: Icons.description_outlined,
            title: 'Terms & Conditions',
            showIconBackground: true,
            iconBackgroundColor: ColorStyle.textSecondary.withValues(
              alpha: 0.1,
            ),
            iconColor: ColorStyle.textSecondary,
            showDivider: true,
            onTap: () => controller.navigateToTerms(),
          ),
          CustomListTileWidget(
            leading: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            showIconBackground: true,
            iconBackgroundColor: ColorStyle.textSecondary.withValues(
              alpha: 0.1,
            ),
            iconColor: ColorStyle.textSecondary,
            showDivider: true,
            onTap: () => controller.navigateToPrivacyPolicy(),
          ),
          Obx(
            () => CustomListTileWidget(
              leading: Icons.apps_outlined,
              title: 'App Version',
              subtitle: controller.appVersion.value,
              showIconBackground: true,
              iconBackgroundColor: ColorStyle.textTertiary.withValues(
                alpha: 0.1,
              ),
              iconColor: ColorStyle.textTertiary,
              showTrailingArrow: false,
            ),
          ),
        ],
      ),
    );
  }

  /// Logout Button
  Widget _buildLogoutButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: InkWell(
        onTap: () => controller.logout(),
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          decoration: BoxDecoration(
            color: ColorStyle.danger.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: ColorStyle.danger.withValues(alpha: 0.3),
              width: 1.w,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout, color: ColorStyle.danger, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                'Logout',
                style: TextStyle(
                  color: ColorStyle.danger,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
