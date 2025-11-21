import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthHeaderWidget extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthHeaderWidget({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 40.h),
        Text(
          title,
          style: TextStyle(
            fontSize: 32.sp,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 12.h),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 60.h),
      ],
    );
  }
}
