import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safe_drive/shared/styles/color_style.dart';
import 'package:safe_drive/shared/styles/text_style.dart';

class HomeQuickActionCardComponent extends StatelessWidget {
  const HomeQuickActionCardComponent({
    super.key,
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
