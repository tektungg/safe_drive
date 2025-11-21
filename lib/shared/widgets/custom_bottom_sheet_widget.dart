import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:safe_drive/shared/widgets/custom_divider_widget.dart';

/// A fully customizable bottom sheet widget with modern styling.
///
/// This widget provides a consistent bottom sheet design across the application
/// with support for custom content, action items, and various styling options.
///
/// ## Features
/// - Modern design with rounded top corners and subtle shadow
/// - Elegant drag handle indicator
/// - Optional title and subtitle with smooth typography
/// - Customizable action items with gradient icon backgrounds
/// - Hover/press animation effects
/// - Support for custom content widget
/// - Configurable colors, padding, and styling
///
/// ## Usage Examples
///
/// ### Basic Bottom Sheet with Actions
/// ```dart
/// CustomBottomSheet.show(
///   title: 'Choose Option',
///   actions: [
///     BottomSheetAction(
///       icon: Icons.photo_library,
///       label: 'Gallery',
///       onTap: () => pickFromGallery(),
///     ),
///     BottomSheetAction(
///       icon: Icons.camera_alt,
///       label: 'Camera',
///       onTap: () => pickFromCamera(),
///     ),
///   ],
/// );
/// ```
///
/// ### Bottom Sheet with Subtitle
/// ```dart
/// CustomBottomSheet.show(
///   title: 'Upload Photo',
///   subtitle: 'Choose how you want to upload your profile picture',
///   actions: [
///     BottomSheetAction(
///       icon: Icons.photo_library,
///       label: 'Gallery',
///       subtitle: 'Choose from your photos',
///       onTap: () => pickFromGallery(),
///     ),
///     BottomSheetAction(
///       icon: Icons.camera_alt,
///       label: 'Camera',
///       subtitle: 'Take a new photo',
///       onTap: () => pickFromCamera(),
///     ),
///   ],
/// );
/// ```
///
/// ### Bottom Sheet with Custom Content
/// ```dart
/// CustomBottomSheet.show(
///   title: 'Settings',
///   child: Column(
///     children: [
///       SwitchListTile(
///         title: Text('Notifications'),
///         value: true,
///         onChanged: (value) {},
///       ),
///       SwitchListTile(
///         title: Text('Dark Mode'),
///         value: false,
///         onChanged: (value) {},
///       ),
///     ],
///   ),
/// );
/// ```
///
/// ### Bottom Sheet with Danger Action
/// ```dart
/// CustomBottomSheet.show(
///   title: 'Account',
///   actions: [
///     BottomSheetAction(
///       icon: Icons.edit,
///       label: 'Edit Profile',
///       onTap: () => editProfile(),
///     ),
///     BottomSheetAction(
///       icon: Icons.logout,
///       label: 'Sign Out',
///       isDanger: true,
///       onTap: () => signOut(),
///     ),
///   ],
/// );
/// ```
///
/// ### Bottom Sheet with Custom Styling
/// ```dart
/// CustomBottomSheet.show(
///   title: 'Choose Color',
///   backgroundColor: Colors.grey[900],
///   titleColor: Colors.white,
///   showDragHandle: false,
///   borderRadius: 24,
///   actions: [...],
/// );
/// ```
///
/// ### Bottom Sheet without Auto Close
/// ```dart
/// CustomBottomSheet.show(
///   title: 'Confirm Action',
///   autoClose: false,
///   actions: [
///     BottomSheetAction(
///       icon: Icons.check,
///       label: 'Confirm',
///       onTap: () {
///         // Do something
///         Get.back(); // Manually close
///       },
///     ),
///   ],
/// );
/// ```

/// Represents an action item in the bottom sheet.
class BottomSheetAction {
  /// Creates a bottom sheet action.
  const BottomSheetAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.subtitle,
    this.iconColor,
    this.labelColor,
    this.isDanger = false,
  });

  /// The icon to display for this action.
  final IconData icon;

  /// The primary label text.
  final String label;

  /// Optional subtitle text below the label.
  final String? subtitle;

  /// Callback when this action is tapped.
  final VoidCallback onTap;

  /// Custom color for the icon.
  ///
  /// If null, uses default color or danger color if [isDanger] is true.
  final Color? iconColor;

  /// Custom color for the label.
  ///
  /// If null, uses default color or danger color if [isDanger] is true.
  final Color? labelColor;

  /// Whether this is a destructive/danger action.
  ///
  /// When true, the action is displayed in red color.
  final bool isDanger;
}

/// A utility class for showing customizable bottom sheets.
class CustomBottomSheet {
  CustomBottomSheet._();

  /// Shows a bottom sheet with the specified configuration.
  ///
  /// Either [actions] or [child] must be provided.
  ///
  /// Parameters:
  /// - [title]: Optional title displayed at the top.
  /// - [subtitle]: Optional subtitle below the title.
  /// - [actions]: List of action items to display.
  /// - [child]: Custom widget content (alternative to actions).
  /// - [backgroundColor]: Background color of the sheet.
  /// - [titleColor]: Color of the title text.
  /// - [subtitleColor]: Color of the subtitle text.
  /// - [borderRadius]: Corner radius of the top corners.
  /// - [showDragHandle]: Whether to show the drag handle indicator.
  /// - [isDismissible]: Whether the sheet can be dismissed by tapping outside.
  /// - [enableDrag]: Whether the sheet can be dragged to dismiss.
  /// - [autoClose]: Whether to automatically close after action tap.
  /// - [padding]: Padding inside the bottom sheet.
  static void show({
    String? title,
    String? subtitle,
    List<BottomSheetAction>? actions,
    Widget? child,
    Color? backgroundColor,
    Color? titleColor,
    Color? subtitleColor,
    double? borderRadius,
    bool showDragHandle = true,
    bool isDismissible = true,
    bool enableDrag = true,
    bool autoClose = true,
    EdgeInsetsGeometry? padding,
  }) {
    assert(
      actions != null || child != null,
      'Either actions or child must be provided',
    );

    Get.bottomSheet(
      _BottomSheetContent(
        title: title,
        subtitle: subtitle,
        actions: actions,
        backgroundColor: backgroundColor,
        titleColor: titleColor,
        subtitleColor: subtitleColor,
        borderRadius: borderRadius,
        showDragHandle: showDragHandle,
        autoClose: autoClose,
        padding: padding,
        child: child,
      ),
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }
}

class _BottomSheetContent extends StatelessWidget {
  const _BottomSheetContent({
    this.title,
    this.subtitle,
    this.actions,
    this.child,
    this.backgroundColor,
    this.titleColor,
    this.subtitleColor,
    this.borderRadius,
    this.showDragHandle = true,
    this.autoClose = true,
    this.padding,
  });

  final String? title;
  final String? subtitle;
  final List<BottomSheetAction>? actions;
  final Widget? child;
  final Color? backgroundColor;
  final Color? titleColor;
  final Color? subtitleColor;
  final double? borderRadius;
  final bool showDragHandle;
  final bool autoClose;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = backgroundColor ?? Colors.white;
    final effectiveTitleColor = titleColor ?? const Color(0xFF1A1A2E);
    final effectiveSubtitleColor = subtitleColor ?? const Color(0xFF6B7280);
    final effectiveBorderRadius = borderRadius ?? 28.r;
    final effectivePadding = padding ??
        EdgeInsets.only(
          left: 24.w,
          right: 24.w,
          top: 12.h,
          bottom: 24.h,
        );

    return Container(
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(effectiveBorderRadius),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, -8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: effectivePadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Drag handle
              if (showDragHandle) ...[
                Center(
                  child: Container(
                    width: 36.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E7EB),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
              ],

              // Title
              if (title != null) ...[
                Text(
                  title!,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: effectiveTitleColor,
                    letterSpacing: -0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (subtitle != null) ...[
                  SizedBox(height: 8.h),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: effectiveSubtitleColor,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
                SizedBox(height: 24.h),
              ],

              // Actions or custom child
              if (child != null)
                child!
              else if (actions != null)
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    children: actions!.asMap().entries.map((entry) {
                      final index = entry.key;
                      final action = entry.value;
                      final isLast = index == actions!.length - 1;
                      return _ActionTile(
                        action: action,
                        autoClose: autoClose,
                        showDivider: !isLast,
                      );
                    }).toList(),
                  ),
                ),

              SizedBox(height: 8.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionTile extends StatefulWidget {
  const _ActionTile({
    required this.action,
    required this.autoClose,
    this.showDivider = true,
  });

  final BottomSheetAction action;
  final bool autoClose;
  final bool showDivider;

  @override
  State<_ActionTile> createState() => _ActionTileState();
}

class _ActionTileState extends State<_ActionTile> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final action = widget.action;

    // Colors based on danger state
    final Color primaryColor =
        action.isDanger ? const Color(0xFFEF4444) : const Color(0xFF3B82F6);
    final Color iconBgColor =
        action.isDanger ? const Color(0xFFFEE2E2) : const Color(0xFFEFF6FF);
    final Color effectiveIconColor = action.iconColor ?? primaryColor;
    final Color effectiveLabelColor = action.labelColor ??
        (action.isDanger ? primaryColor : const Color(0xFF1F2937));

    return Column(
      children: [
        GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) => setState(() => _isPressed = false),
          onTapCancel: () => setState(() => _isPressed = false),
          onTap: () {
            if (widget.autoClose) {
              Get.back();
            }
            action.onTap();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
            padding: EdgeInsets.symmetric(
              vertical: 16.h,
              horizontal: 16.w,
            ),
            decoration: BoxDecoration(
              color: _isPressed ? const Color(0xFFF3F4F6) : Colors.transparent,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                // Icon with gradient background
                Container(
                  width: 48.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Icon(
                    action.icon,
                    color: effectiveIconColor,
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 16.w),
                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        action.label,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: effectiveLabelColor,
                          letterSpacing: -0.2,
                        ),
                      ),
                      if (action.subtitle != null) ...[
                        SizedBox(height: 4.h),
                        Text(
                          action.subtitle!,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF9CA3AF),
                            height: 1.3,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                // Arrow icon
                Container(
                  width: 32.w,
                  height: 32.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: const Color(0xFF9CA3AF),
                    size: 14.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Divider
        if (widget.showDivider)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: const CustomDividerWidget(
              lineColor: Color(0xFFE5E7EB),
              thickness: 1,
            ),
          ),
      ],
    );
  }
}
