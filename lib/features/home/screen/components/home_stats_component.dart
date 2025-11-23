import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safe_drive/features/home/screen/components/home_stat_card_component.dart';
import 'package:safe_drive/shared/styles/color_style.dart';

class HomeStatsComponent extends StatelessWidget {
  const HomeStatsComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: HomeStatCardComponent(
                icon: Icons.directions_car_rounded,
                label: 'Total Trips',
                value: '0',
                color: ColorStyle.primary,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: HomeStatCardComponent(
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
              child: HomeStatCardComponent(
                icon: Icons.route_rounded,
                label: 'Distance',
                value: '0 km',
                color: ColorStyle.warning,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: HomeStatCardComponent(
                icon: Icons.star_rounded,
                label: 'Safety Score',
                value: '0',
                color: ColorStyle.secondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
