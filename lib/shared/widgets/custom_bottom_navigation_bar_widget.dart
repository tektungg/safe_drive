import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safe_drive/shared/styles/color_style.dart';
import 'package:safe_drive/shared/styles/text_style.dart';

/// A fully customizable modern bottom navigation bar widget.
///
/// This widget provides an elegant bottom navigation bar with smooth animations,
/// customizable colors, icons, labels, and support for up to 5 navigation items.
///
/// ## Features
/// - Modern, elegant design with smooth transitions
/// - Support for 1-5 navigation items
/// - Active/inactive states with customizable colors
/// - Icon and label support
/// - Badge support for notifications
/// - Smooth animation on item selection
/// - Fully customizable appearance
/// - Responsive sizing with flutter_screenutil
/// - Elevation and shadow support
///
/// ## Usage Examples
///
/// ### Basic usage with 3 items
/// ```dart
/// CustomBottomNavigationBarWidget(
///   currentIndex: 0,
///   onTap: (index) => print('Tapped item $index'),
///   items: [
///     BottomNavItem(
///       icon: Icons.home_outlined,
///       activeIcon: Icons.home,
///       label: 'Home',
///     ),
///     BottomNavItem(
///       icon: Icons.search_outlined,
///       activeIcon: Icons.search,
///       label: 'Search',
///     ),
///     BottomNavItem(
///       icon: Icons.person_outline,
///       activeIcon: Icons.person,
///       label: 'Profile',
///     ),
///   ],
/// )
/// ```
///
/// ### With badges and custom colors
/// ```dart
/// CustomBottomNavigationBarWidget(
///   currentIndex: controller.currentIndex.value,
///   onTap: (index) => controller.changePage(index),
///   activeColor: ColorStyle.primary,
///   inactiveColor: ColorStyle.textSecondary,
///   backgroundColor: ColorStyle.white,
///   items: [
///     BottomNavItem(
///       icon: Icons.home_outlined,
///       activeIcon: Icons.home,
///       label: 'Home',
///     ),
///     BottomNavItem(
///       icon: Icons.notifications_outlined,
///       activeIcon: Icons.notifications,
///       label: 'Notifications',
///       badgeCount: 5,
///     ),
///     BottomNavItem(
///       icon: Icons.message_outlined,
///       activeIcon: Icons.message,
///       label: 'Messages',
///       badgeCount: 12,
///     ),
///     BottomNavItem(
///       icon: Icons.settings_outlined,
///       activeIcon: Icons.settings,
///       label: 'Settings',
///     ),
///   ],
/// )
/// ```
///
/// ### Without labels
/// ```dart
/// CustomBottomNavigationBarWidget(
///   currentIndex: 0,
///   showLabels: false,
///   onTap: (index) => handleNavigation(index),
///   items: [
///     BottomNavItem(
///       icon: Icons.home_outlined,
///       activeIcon: Icons.home,
///     ),
///     BottomNavItem(
///       icon: Icons.explore_outlined,
///       activeIcon: Icons.explore,
///     ),
///     BottomNavItem(
///       icon: Icons.favorite_outline,
///       activeIcon: Icons.favorite,
///     ),
///   ],
/// )
/// ```
///
/// ### With custom styling
/// ```dart
/// CustomBottomNavigationBarWidget(
///   currentIndex: 2,
///   height: 70.h,
///   elevation: 8,
///   borderRadius: 24.r,
///   activeColor: ColorStyle.success,
///   inactiveColor: ColorStyle.gray400,
///   backgroundColor: ColorStyle.backgroundDark,
///   selectedFontSize: 13.sp,
///   unselectedFontSize: 11.sp,
///   iconSize: 26.sp,
///   onTap: (index) => navigateToPage(index),
///   items: [
///     BottomNavItem(
///       icon: Icons.dashboard_outlined,
///       activeIcon: Icons.dashboard,
///       label: 'Dashboard',
///     ),
///     BottomNavItem(
///       icon: Icons.analytics_outlined,
///       activeIcon: Icons.analytics,
///       label: 'Analytics',
///     ),
///     BottomNavItem(
///       icon: Icons.add_circle_outline,
///       activeIcon: Icons.add_circle,
///       label: 'Add',
///     ),
///     BottomNavItem(
///       icon: Icons.notifications_outlined,
///       activeIcon: Icons.notifications,
///       label: 'Alerts',
///       badgeCount: 3,
///     ),
///     BottomNavItem(
///       icon: Icons.menu,
///       activeIcon: Icons.menu_open,
///       label: 'Menu',
///     ),
///   ],
/// )
/// ```
class CustomBottomNavigationBarWidget extends StatelessWidget {
  /// List of navigation items (1-5 items supported)
  final List<BottomNavItem> items;

  /// Currently selected index
  final int currentIndex;

  /// Callback when an item is tapped
  final Function(int) onTap;

  /// Active item color
  final Color? activeColor;

  /// Inactive item color
  final Color? inactiveColor;

  /// Background color of the navigation bar
  final Color? backgroundColor;

  /// Whether to show labels
  final bool showLabels;

  /// Height of the navigation bar
  final double? height;

  /// Elevation of the navigation bar
  final double elevation;

  /// Border radius of the navigation bar
  final double? borderRadius;

  /// Font size for selected item label
  final double? selectedFontSize;

  /// Font size for unselected item label
  final double? unselectedFontSize;

  /// Icon size
  final double? iconSize;

  /// Enable haptic feedback on tap
  final bool enableHapticFeedback;

  /// Animation duration
  final Duration animationDuration;

  /// Type of bottom navigation bar
  final BottomNavType type;

  const CustomBottomNavigationBarWidget({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.activeColor,
    this.inactiveColor,
    this.backgroundColor,
    this.showLabels = true,
    this.height,
    this.elevation = 8,
    this.borderRadius,
    this.selectedFontSize,
    this.unselectedFontSize,
    this.iconSize,
    this.enableHapticFeedback = true,
    this.animationDuration = const Duration(milliseconds: 300),
    this.type = BottomNavType.fixed,
  }) : assert(
         items.length >= 1 && items.length <= 5,
         'Bottom navigation bar must have 1-5 items',
       ),
       assert(
         currentIndex >= 0 && currentIndex < items.length,
         'currentIndex must be within items range',
       );

  @override
  Widget build(BuildContext context) {
    final effectiveActiveColor = activeColor ?? ColorStyle.primary;
    final effectiveInactiveColor = inactiveColor ?? ColorStyle.textSecondary;
    final effectiveBackgroundColor = backgroundColor ?? ColorStyle.white;
    final effectiveHeight = height ?? 65.h;
    final effectiveIconSize = iconSize ?? 24.sp;
    final effectiveSelectedFontSize = selectedFontSize ?? 12.sp;
    final effectiveUnselectedFontSize = unselectedFontSize ?? 11.sp;

    return Container(
      height: effectiveHeight,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: borderRadius != null
            ? BorderRadius.vertical(top: Radius.circular(borderRadius!))
            : null,
        boxShadow: [
          BoxShadow(
            color: ColorStyle.black.withValues(alpha: 0.08),
            blurRadius: elevation,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              items.length,
              (index) => _buildNavItem(
                context: context,
                item: items[index],
                index: index,
                isActive: currentIndex == index,
                activeColor: effectiveActiveColor,
                inactiveColor: effectiveInactiveColor,
                iconSize: effectiveIconSize,
                selectedFontSize: effectiveSelectedFontSize,
                unselectedFontSize: effectiveUnselectedFontSize,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required BottomNavItem item,
    required int index,
    required bool isActive,
    required Color activeColor,
    required Color inactiveColor,
    required double iconSize,
    required double selectedFontSize,
    required double unselectedFontSize,
  }) {
    final color = isActive ? activeColor : inactiveColor;

    return Expanded(
      child: InkWell(
        onTap: () {
          if (enableHapticFeedback) {
            // You can add HapticFeedback.lightImpact() here if needed
          }
          onTap(index);
        },
        borderRadius: BorderRadius.circular(12.r),
        child: AnimatedContainer(
          duration: animationDuration,
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(
            horizontal: 8.w,
            vertical: showLabels ? 8.h : 12.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with badge
              Stack(
                clipBehavior: Clip.none,
                children: [
                  // Icon
                  AnimatedContainer(
                    duration: animationDuration,
                    curve: Curves.easeInOut,
                    padding: EdgeInsets.all(
                      type == BottomNavType.shifting && isActive ? 4.r : 0,
                    ),
                    decoration: type == BottomNavType.shifting && isActive
                        ? BoxDecoration(
                            color: activeColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12.r),
                          )
                        : null,
                    child: Icon(
                      isActive ? (item.activeIcon ?? item.icon) : item.icon,
                      size: iconSize,
                      color: color,
                    ),
                  ),

                  // Badge
                  if (item.badgeCount != null && item.badgeCount! > 0)
                    Positioned(
                      right: -6.w,
                      top: -6.h,
                      child: _buildBadge(item.badgeCount!),
                    ),
                ],
              ),

              // Label
              if (showLabels && item.label != null) ...[
                SizedBox(height: 4.h),
                AnimatedDefaultTextStyle(
                  duration: animationDuration,
                  curve: Curves.easeInOut,
                  style: TextStyles.labelSmall.copyWith(
                    color: color,
                    fontSize: isActive ? selectedFontSize : unselectedFontSize,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  ),
                  child: Text(
                    item.label!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(int count) {
    final displayCount = count > 99 ? '99+' : count.toString();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: count > 9 ? 5.w : 6.w,
        vertical: 2.h,
      ),
      decoration: BoxDecoration(
        color: ColorStyle.danger,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: ColorStyle.white, width: 1.5),
      ),
      child: Text(
        displayCount,
        style: TextStyles.captionSmall.copyWith(
          color: ColorStyle.white,
          fontSize: 9.sp,
          fontWeight: FontWeight.w700,
          height: 1,
        ),
      ),
    );
  }
}

/// Bottom navigation item model
class BottomNavItem {
  /// Icon for the navigation item
  final IconData icon;

  /// Active state icon (optional, defaults to icon)
  final IconData? activeIcon;

  /// Label text (optional)
  final String? label;

  /// Badge count (optional, for notifications)
  final int? badgeCount;

  const BottomNavItem({
    required this.icon,
    this.activeIcon,
    this.label,
    this.badgeCount,
  });
}

/// Type of bottom navigation bar
enum BottomNavType {
  /// Fixed type - items maintain their position
  fixed,

  /// Shifting type - active item gets highlighted background
  shifting,
}
