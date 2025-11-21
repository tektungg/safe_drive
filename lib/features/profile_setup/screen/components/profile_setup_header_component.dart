import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safe_drive/shared/widgets/auth_header_widget.dart';

class ProfileSetupHeaderComponent extends StatelessWidget {
  const ProfileSetupHeaderComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 40.h),
        const AuthHeaderWidget(
          title: 'Setup Your Profile',
          subtitle: 'Add a photo and your name to personalize your account',
        ),
      ],
    );
  }
}
