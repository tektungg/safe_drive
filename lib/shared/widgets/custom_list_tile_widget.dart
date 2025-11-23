import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safe_drive/shared/styles/color_style.dart';
import 'package:safe_drive/shared/styles/text_style.dart';
import 'package:safe_drive/shared/widgets/custom_divider_widget.dart';

/// A fully customizable list tile widget for settings and menu items.
///
/// This widget provides a consistent list tile design across the app with support for:
/// - Leading icons
/// - Title and subtitle text
/// - Trailing widgets (icons, switches, badges)
/// - Tap interactions
/// - Custom styling
///
/// ## Features
/// - Consistent padding and spacing
/// - Icon support with customizable colors and sizes
/// - Title and subtitle with predefined text styles
/// - Trailing widgets (arrows, switches, badges, custom widgets)
/// - Tap handling with visual feedback
/// - Divider support
/// - Fully customizable colors and styling
///
/// ## Usage Examples
///
/// ### Basic list tile
/// ```dart
/// CustomListTileWidget(
///   leading: Icons.person,
///   title: 'Profile',
///   onTap: () => navigateToProfile(),
/// )
/// ```
///
/// ### With subtitle
/// ```dart
/// CustomListTileWidget(
///   leading: Icons.notifications,
///   title: 'Notifications',
///   subtitle: 'Manage notification settings',
///   onTap: () => navigateToNotifications(),
/// )
/// ```
///
/// ### With switch
/// ```dart
/// CustomListTileWidget(
///   leading: Icons.dark_mode,
///   title: 'Dark Mode',
///   trailing: Switch(
///     value: isDarkMode,
///     onChanged: (value) => toggleDarkMode(value),
///   ),
/// )
/// ```
///
/// ### With badge
/// ```dart
/// CustomListTileWidget(
///   leading: Icons.message,
///   title: 'Messages',
///   badge: '3',
///   onTap: () => navigateToMessages(),
/// )
/// ```
///
/// ### Without trailing arrow
/// ```dart
/// CustomListTileWidget(
///   leading: Icons.info,
///   title: 'Version',
///   subtitle: '1.0.0',
///   showTrailingArrow: false,
/// )
/// ```
class CustomListTileWidget extends StatelessWidget {
  /// The icon to display at the start of the tile
  final IconData? leading;

  /// Custom widget to display at the start (overrides leading icon)
  final Widget? leadingWidget;

  /// The primary text to display
  final String title;

  /// Optional secondary text to display below the title
  final String? subtitle;

  /// Custom trailing widget (overrides default trailing arrow)
  final Widget? trailing;

  /// Badge text to display next to the title
  final String? badge;

  /// Whether to show the default trailing arrow
  final bool showTrailingArrow;

  /// Callback when the tile is tapped
  final VoidCallback? onTap;

  /// Background color of the tile
  final Color? backgroundColor;

  /// Icon color
  final Color? iconColor;

  /// Icon size
  final double? iconSize;

  /// Icon background color (for circular background)
  final Color? iconBackgroundColor;

  /// Whether to show icon with circular background
  final bool showIconBackground;

  /// Title text color
  final Color? titleColor;

  /// Subtitle text color
  final Color? subtitleColor;

  /// Whether to show divider at the bottom
  final bool showDivider;

  /// Divider color
  final Color? dividerColor;

  /// Vertical padding
  final double? verticalPadding;

  /// Horizontal padding
  final double? horizontalPadding;

  const CustomListTileWidget({
    super.key,
    this.leading,
    this.leadingWidget,
    required this.title,
    this.subtitle,
    this.trailing,
    this.badge,
    this.showTrailingArrow = true,
    this.onTap,
    this.backgroundColor,
    this.iconColor,
    this.iconSize,
    this.iconBackgroundColor,
    this.showIconBackground = false,
    this.titleColor,
    this.subtitleColor,
    this.showDivider = false,
    this.dividerColor,
    this.verticalPadding,
    this.horizontalPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: backgroundColor ?? Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding ?? 20.w,
                vertical: verticalPadding ?? 16.h,
              ),
              child: Row(
                children: [
                  // Leading icon or widget
                  if (leadingWidget != null)
                    leadingWidget!
                  else if (leading != null)
                    _buildLeadingIcon(),

                  if (leadingWidget != null || leading != null)
                    SizedBox(width: 16.w),

                  // Title and subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                title,
                                style: TextStyles.titleMedium.copyWith(
                                  color: titleColor ?? ColorStyle.textPrimary,
                                ),
                              ),
                            ),
                            if (badge != null) ...[
                              SizedBox(width: 8.w),
                              _buildBadge(),
                            ],
                          ],
                        ),
                        if (subtitle != null) ...[
                          SizedBox(height: 4.h),
                          Text(
                            subtitle!,
                            style: TextStyles.bodySmall.copyWith(
                              color: subtitleColor ?? ColorStyle.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Trailing widget or arrow
                  if (trailing != null)
                    trailing!
                  else if (showTrailingArrow)
                    Icon(
                      Icons.chevron_right,
                      color: ColorStyle.textTertiary,
                      size: 24.sp,
                    ),
                ],
              ),
            ),
          ),
        ),
        if (showDivider)
          CustomDividerWidget(
            height: 1.h,
            thickness: 1,
            lineColor: dividerColor ?? ColorStyle.divider,
            indent: horizontalPadding ?? 20.w,
            endIndent: horizontalPadding ?? 20.w,
          ),
      ],
    );
  }

  /// Builds the leading icon with optional circular background
  Widget _buildLeadingIcon() {
    final icon = Icon(
      leading,
      color: iconColor ?? ColorStyle.primary,
      size: iconSize ?? 24.sp,
    );

    if (showIconBackground) {
      return Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
          color:
              iconBackgroundColor ?? ColorStyle.primary.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Center(child: icon),
      );
    }

    return icon;
  }

  /// Builds the badge widget
  Widget _buildBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: ColorStyle.danger,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        badge!,
        style: TextStyles.captionSmall.copyWith(
          color: ColorStyle.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// A section header widget for grouping list tiles
///
/// ## Usage Example
///
/// ```dart
/// CustomListTileSectionHeader(
///   title: 'Account Settings',
/// )
/// ```
class CustomListTileSectionHeader extends StatelessWidget {
  /// The section title text
  final String title;

  /// Title text color
  final Color? titleColor;

  /// Top padding
  final double? topPadding;

  /// Bottom padding
  final double? bottomPadding;

  /// Horizontal padding
  final double? horizontalPadding;

  const CustomListTileSectionHeader({
    super.key,
    required this.title,
    this.titleColor,
    this.topPadding,
    this.bottomPadding,
    this.horizontalPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: horizontalPadding ?? 20.w,
        right: horizontalPadding ?? 20.w,
        top: topPadding ?? 24.h,
        bottom: bottomPadding ?? 8.h,
      ),
      child: Text(
        title.toUpperCase(),
        style: TextStyles.labelSmall.copyWith(
          color: titleColor ?? ColorStyle.textSecondary,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
