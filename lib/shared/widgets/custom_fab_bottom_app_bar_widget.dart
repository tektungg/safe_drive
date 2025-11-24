import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safe_drive/shared/styles/color_style.dart';

/// A custom bottom app bar with center-docked FAB and navigation items
///
/// This widget provides a modern bottom navigation bar with a floating action
/// button in the center and navigation items on both sides.
///
/// ## Features
/// - Center-docked FAB with notch
/// - Support for 2 or 4 navigation items (split on both sides of FAB)
/// - Active/inactive states with customizable colors
/// - Icon and optional label support
/// - Smooth animations
/// - Fully customizable appearance
/// - Responsive sizing with flutter_screenutil
///
/// ## Usage Examples
///
/// ### Basic usage with 4 items (2 left, FAB center, 2 right)
/// ```dart
/// CustomFabBottomAppBarWidget(
///   currentIndex: controller.currentIndex.value,
///   onTap: (index) => controller.changePage(index),
///   onFabPressed: () => controller.openScanner(),
///   items: [
///     FabBottomNavItem(icon: Icons.home),
///     FabBottomNavItem(icon: Icons.favorite),
///     // FAB here (index 2)
///     FabBottomNavItem(icon: Icons.person),
///     FabBottomNavItem(icon: Icons.settings),
///   ],
/// )
/// ```
///
/// ### With labels and custom styling
/// ```dart
/// CustomFabBottomAppBarWidget(
///   currentIndex: 0,
///   activeColor: ColorStyle.primary,
///   inactiveColor: ColorStyle.textSecondary,
///   backgroundColor: ColorStyle.white,
///   fabIcon: Icons.qr_code_scanner,
///   fabBackgroundColor: ColorStyle.primary,
///   showLabels: true,
///   onTap: (index) => handleNavigation(index),
///   onFabPressed: () => openScanner(),
///   items: [
///     FabBottomNavItem(
///       icon: Icons.home_outlined,
///       activeIcon: Icons.home,
///       label: 'Home',
///     ),
///     FabBottomNavItem(
///       icon: Icons.favorite_outline,
///       activeIcon: Icons.favorite,
///       label: 'Favorites',
///     ),
///     FabBottomNavItem(
///       icon: Icons.person_outline,
///       activeIcon: Icons.person,
///       label: 'Profile',
///     ),
///     FabBottomNavItem(
///       icon: Icons.settings_outlined,
///       activeIcon: Icons.settings,
///       label: 'Settings',
///     ),
///   ],
/// )
/// ```
class CustomFabBottomAppBarWidget extends StatelessWidget {
  /// List of navigation items (must be 2 or 4 items)
  final List<FabBottomNavItem> items;

  /// Currently selected index (FAB is not counted in index)
  final int currentIndex;

  /// Callback when an item is tapped
  final Function(int) onTap;

  /// Callback when FAB is pressed
  final VoidCallback onFabPressed;

  /// FAB icon
  final IconData fabIcon;

  /// FAB background color
  final Color? fabBackgroundColor;

  /// FAB icon color
  final Color? fabIconColor;

  /// Active item color
  final Color? activeColor;

  /// Inactive item color
  final Color? inactiveColor;

  /// Background color of the bottom app bar
  final Color? backgroundColor;

  /// Whether to show labels
  final bool showLabels;

  /// Height of the bottom app bar
  final double? height;

  /// Elevation of the bottom app bar
  final double elevation;

  /// Icon size
  final double? iconSize;

  /// FAB size
  final double? fabSize;

  /// Animation duration
  final Duration animationDuration;

  /// Notch margin (space between FAB and bottom bar)
  final double notchMargin;

  const CustomFabBottomAppBarWidget({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    required this.onFabPressed,
    this.fabIcon = Icons.add,
    this.fabBackgroundColor,
    this.fabIconColor,
    this.activeColor,
    this.inactiveColor,
    this.backgroundColor,
    this.showLabels = false,
    this.height,
    this.elevation = 8,
    this.iconSize,
    this.fabSize,
    this.animationDuration = const Duration(milliseconds: 300),
    this.notchMargin = 8,
  }) : assert(
          items.length == 2 || items.length == 4,
          'Items must be 2 or 4 (split on both sides of FAB)',
        );

  @override
  Widget build(BuildContext context) {
    final effectiveActiveColor = activeColor ?? ColorStyle.primary;
    final effectiveInactiveColor = inactiveColor ?? ColorStyle.textSecondary;
    final effectiveBackgroundColor = backgroundColor ?? ColorStyle.white;
    final effectiveHeight = height ?? 65.h;
    final effectiveIconSize = iconSize ?? 24.sp;
    final effectiveFabSize = fabSize ?? 56.sp;

    // Split items into left and right
    final int halfLength = items.length ~/ 2;
    final leftItems = items.sublist(0, halfLength);
    final rightItems = items.sublist(halfLength);

    return BottomAppBar(
      elevation: elevation,
      color: effectiveBackgroundColor,
      height: effectiveHeight,
      notchMargin: notchMargin,
      shape: const CircularNotchedRectangle(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Left items
          ...List.generate(
            leftItems.length,
            (index) => _buildNavItem(
              item: leftItems[index],
              index: index,
              isActive: currentIndex == index,
              activeColor: effectiveActiveColor,
              inactiveColor: effectiveInactiveColor,
              iconSize: effectiveIconSize,
            ),
          ),

          // Spacer for FAB
          SizedBox(width: effectiveFabSize + notchMargin * 2),

          // Right items
          ...List.generate(
            rightItems.length,
            (index) {
              final actualIndex = index + halfLength;
              return _buildNavItem(
                item: rightItems[index],
                index: actualIndex,
                isActive: currentIndex == actualIndex,
                activeColor: effectiveActiveColor,
                inactiveColor: effectiveInactiveColor,
                iconSize: effectiveIconSize,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required FabBottomNavItem item,
    required int index,
    required bool isActive,
    required Color activeColor,
    required Color inactiveColor,
    required double iconSize,
  }) {
    final color = isActive ? activeColor : inactiveColor;

    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        borderRadius: BorderRadius.circular(12.r),
        child: AnimatedContainer(
          duration: animationDuration,
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(
            vertical: showLabels ? 8.h : 12.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              AnimatedScale(
                duration: animationDuration,
                scale: isActive ? 1.1 : 1.0,
                child: Icon(
                  isActive ? (item.activeIcon ?? item.icon) : item.icon,
                  size: iconSize,
                  color: color,
                ),
              ),

              // Label
              if (showLabels && item.label != null) ...[
                SizedBox(height: 4.h),
                AnimatedDefaultTextStyle(
                  duration: animationDuration,
                  curve: Curves.easeInOut,
                  style: TextStyle(
                    color: color,
                    fontSize: isActive ? 11.sp : 10.sp,
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
}

/// Bottom navigation item model for FAB bottom app bar
class FabBottomNavItem {
  /// Icon for the navigation item
  final IconData icon;

  /// Active state icon (optional, defaults to icon)
  final IconData? activeIcon;

  /// Label text (optional)
  final String? label;

  const FabBottomNavItem({
    required this.icon,
    this.activeIcon,
    this.label,
  });
}
