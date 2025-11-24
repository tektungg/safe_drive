import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:safe_drive/features/home/screen/ui/home_screen.dart';
import 'package:safe_drive/features/main/controllers/main_controller.dart';
import 'package:safe_drive/features/scanner/screen/ui/scanner_screen.dart';
import 'package:safe_drive/features/setting/screen/ui/setting_screen.dart';
import 'package:safe_drive/shared/styles/color_style.dart';
import 'package:safe_drive/shared/widgets/custom_bottom_navigation_bar_widget.dart';

/// Main navigation screen with bottom navigation bar
///
/// This screen manages the navigation between Home, Scanner, and Settings
/// using a custom bottom navigation bar.
class MainScreen extends GetView<MainController> {
  const MainScreen({super.key});

  /// List of pages to display
  List<Widget> get _pages => [
    const HomeScreen(),
    const ScannerScreen(),
    const SettingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: _pages,
        ),
      ),
      bottomNavigationBar: Obx(
        () => CustomBottomNavigationBarWidget(
          currentIndex: controller.currentIndex.value,
          onTap: (index) => controller.changePage(index),
          activeColor: ColorStyle.primary,
          inactiveColor: ColorStyle.textSecondary,
          backgroundColor: ColorStyle.white,
          elevation: 8,
          height: 70.h,
          iconSize: 24.sp,
          selectedFontSize: 12.sp,
          unselectedFontSize: 11.sp,
          items: [
            BottomNavItem(
              icon: Icons.home_outlined,
              activeIcon: Icons.home,
              label: 'Home',
            ),
            BottomNavItem(
              icon: Icons.qr_code_scanner_outlined,
              activeIcon: Icons.qr_code_scanner,
              label: 'Scanner',
            ),
            BottomNavItem(
              icon: Icons.account_circle_outlined,
              activeIcon: Icons.account_circle,
              label: 'Account',
            ),
          ],
        ),
      ),
    );
  }
}
