import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safe_drive/shared/styles/text_style.dart';
import 'package:safe_drive/shared/widgets/custom_empty_widget.dart';

class HomeRecentActivityComponent extends StatelessWidget {
  const HomeRecentActivityComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: TextStyles.headlineMedium,
        ),
        SizedBox(height: 16.h),
        CustomEmptyWidget.icon(
          icon: Icons.history_rounded,
          title: 'No recent activity',
          subtitle: 'Start your first trip to see activity here',
        ),
      ],
    );
  }
}
