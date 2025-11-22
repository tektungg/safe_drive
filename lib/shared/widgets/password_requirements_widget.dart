import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safe_drive/shared/styles/color_style.dart';

class PasswordRequirementsWidget extends StatelessWidget {
  final bool isVisible;
  final bool shouldShake;
  final bool hasMinLength;
  final bool hasLowercase;
  final bool hasUppercase;
  final bool hasNumber;
  final bool hasSymbol;

  const PasswordRequirementsWidget({
    super.key,
    required this.isVisible,
    required this.shouldShake,
    required this.hasMinLength,
    required this.hasLowercase,
    required this.hasUppercase,
    required this.hasNumber,
    required this.hasSymbol,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: isVisible
          ? Column(
              children: [
                SizedBox(height: 12.h),
                TweenAnimationBuilder<double>(
                  tween: Tween(
                    begin: 0.0,
                    end: shouldShake ? 1.0 : 0.0,
                  ),
                  duration: const Duration(milliseconds: 300),
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(
                        10 * sin(value * pi * 2),
                        0,
                      ),
                      child: child,
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: ColorStyle.backgroundGray,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Password should contain',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: ColorStyle.textSecondary,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        _RequirementRow(
                          text: 'At least 6 characters',
                          isMet: hasMinLength,
                        ),
                        _RequirementRow(
                          text: 'At least 1 lowercase letter (a..z)',
                          isMet: hasLowercase,
                        ),
                        _RequirementRow(
                          text: 'At least 1 uppercase letter (A..Z)',
                          isMet: hasUppercase,
                        ),
                        _RequirementRow(
                          text: 'At least 1 number (0..9)',
                          isMet: hasNumber,
                        ),
                        _RequirementRow(
                          text: 'At least 1 symbol (!@#\$%^&*)',
                          isMet: hasSymbol,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : const SizedBox.shrink(),
    );
  }
}

class _RequirementRow extends StatelessWidget {
  final String text;
  final bool isMet;

  const _RequirementRow({
    required this.text,
    required this.isMet,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check : Icons.close,
            size: 16.sp,
            color: isMet ? ColorStyle.success : ColorStyle.danger,
          ),
          SizedBox(width: 8.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 12.sp,
              color: isMet ? ColorStyle.success : ColorStyle.danger,
            ),
          ),
        ],
      ),
    );
  }
}
