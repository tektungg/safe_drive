import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safe_drive/features/home/screen/components/home_quick_action_card_component.dart';
import 'package:safe_drive/shared/styles/color_style.dart';
import 'package:safe_drive/shared/styles/text_style.dart';

class HomeQuickActionsComponent extends StatelessWidget {
  const HomeQuickActionsComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyles.headlineMedium,
        ),
        SizedBox(height: 16.h),
        HomeQuickActionCardComponent(
          icon: Icons.camera_alt_rounded,
          title: 'Start Scanner',
          subtitle: 'Scan traffic signs',
          color: ColorStyle.primary,
          onTap: () {
            // TODO: Navigate to scanner screen
          },
        ),
        SizedBox(height: 12.h),
        HomeQuickActionCardComponent(
          icon: Icons.settings_rounded,
          title: 'Settings',
          subtitle: 'Manage your preferences',
          color: ColorStyle.textSecondary,
          onTap: () {
            // TODO: Navigate to settings screen
          },
        ),
      ],
    );
  }
}
