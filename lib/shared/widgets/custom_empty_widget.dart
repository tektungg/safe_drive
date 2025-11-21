import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A fully customizable empty state widget for displaying placeholder content.
///
/// This widget provides a consistent empty state design across the application
/// when there's no data to display. It supports images, icons, custom styling,
/// and action buttons.
///
/// ## Features
/// - Support for both image assets and icons
/// - Customizable title and subtitle text
/// - Optional action button
/// - Configurable text styles and colors
/// - Flexible spacing and padding
/// - Animation support
///
/// ## Usage Examples
///
/// ### Basic Empty State with Image
/// ```dart
/// CustomEmptyWidget(
///   image: 'assets/images/empty_inbox.png',
///   title: 'No Messages',
///   subtitle: 'You have no messages yet',
/// )
/// ```
///
/// ### Empty State with Icon
/// ```dart
/// CustomEmptyWidget.icon(
///   icon: Icons.inbox_outlined,
///   title: 'No Items',
///   subtitle: 'Your cart is empty',
/// )
/// ```
///
/// ### Empty State with Action Button
/// ```dart
/// CustomEmptyWidget(
///   image: 'assets/images/no_data.png',
///   title: 'No Data Found',
///   subtitle: 'Try adjusting your search or filters',
///   actionText: 'Refresh',
///   onActionPressed: () => refreshData(),
/// )
/// ```
///
/// ### Custom Styled Empty State
/// ```dart
/// CustomEmptyWidget(
///   image: 'assets/images/error.png',
///   title: 'Something Went Wrong',
///   subtitle: 'Please try again later',
///   titleStyle: TextStyle(
///     fontSize: 20.sp,
///     fontWeight: FontWeight.bold,
///     color: Colors.red,
///   ),
///   imageSize: 180,
/// )
/// ```
///
/// ### Compact Empty State
/// ```dart
/// CustomEmptyWidget.compact(
///   icon: Icons.search_off,
///   title: 'No Results',
/// )
/// ```
///
/// ### Empty State with Custom Widget
/// ```dart
/// CustomEmptyWidget.custom(
///   customWidget: Lottie.asset('assets/animations/empty.json'),
///   title: 'Nothing Here',
///   subtitle: 'Check back later',
/// )
/// ```
///
/// See also:
/// - [CustomShimmerWidget] - For loading states
/// - [CustomButtonWidget] - For action buttons
class CustomEmptyWidget extends StatelessWidget {
  /// Creates an empty state widget with an image.
  const CustomEmptyWidget({
    super.key,
    required this.title,
    this.image,
    this.subtitle,
    this.imageSize,
    this.imageWidth,
    this.imageHeight,
    this.titleStyle,
    this.subtitleStyle,
    this.titleColor,
    this.subtitleColor,
    this.spacing = 16,
    this.padding,
    this.actionText,
    this.onActionPressed,
    this.actionButtonStyle,
    this.compact = false,
  })  : icon = null,
        iconSize = null,
        iconColor = null,
        customWidget = null;

  /// Creates an empty state widget with an icon instead of image.
  const CustomEmptyWidget.icon({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.iconSize,
    this.iconColor,
    this.titleStyle,
    this.subtitleStyle,
    this.titleColor,
    this.subtitleColor,
    this.spacing = 16,
    this.padding,
    this.actionText,
    this.onActionPressed,
    this.actionButtonStyle,
    this.compact = false,
  })  : image = null,
        imageSize = null,
        imageWidth = null,
        imageHeight = null,
        customWidget = null;

  /// Creates an empty state widget with a custom widget (e.g., Lottie animation).
  const CustomEmptyWidget.custom({
    super.key,
    required this.customWidget,
    required this.title,
    this.subtitle,
    this.titleStyle,
    this.subtitleStyle,
    this.titleColor,
    this.subtitleColor,
    this.spacing = 16,
    this.padding,
    this.actionText,
    this.onActionPressed,
    this.actionButtonStyle,
    this.compact = false,
  })  : image = null,
        imageSize = null,
        imageWidth = null,
        imageHeight = null,
        icon = null,
        iconSize = null,
        iconColor = null;

  /// Creates a compact empty state with minimal styling.
  const CustomEmptyWidget.compact({
    super.key,
    this.icon,
    this.image,
    required this.title,
    this.subtitle,
    this.iconColor,
    this.titleColor,
    this.subtitleColor,
  })  : imageSize = 80,
        imageWidth = null,
        imageHeight = null,
        iconSize = 48,
        titleStyle = null,
        subtitleStyle = null,
        spacing = 12,
        padding = null,
        actionText = null,
        onActionPressed = null,
        actionButtonStyle = null,
        customWidget = null,
        compact = true;

  /// The path to the image asset.
  final String? image;

  /// The size of the image (applies to both width and height).
  ///
  /// Use [imageWidth] and [imageHeight] for non-square images.
  /// Defaults to 200.
  final double? imageSize;

  /// The width of the image.
  ///
  /// Overrides [imageSize] for width if specified.
  final double? imageWidth;

  /// The height of the image.
  ///
  /// Overrides [imageSize] for height if specified.
  final double? imageHeight;

  /// The icon to display instead of an image.
  final IconData? icon;

  /// The size of the icon.
  ///
  /// Defaults to 80.
  final double? iconSize;

  /// The color of the icon.
  ///
  /// Defaults to grey.
  final Color? iconColor;

  /// A custom widget to display (e.g., Lottie animation).
  final Widget? customWidget;

  /// The main title text.
  final String title;

  /// The subtitle or description text.
  final String? subtitle;

  /// Custom style for the title text.
  final TextStyle? titleStyle;

  /// Custom style for the subtitle text.
  final TextStyle? subtitleStyle;

  /// Color for the title text.
  ///
  /// Ignored if [titleStyle] is provided with a color.
  final Color? titleColor;

  /// Color for the subtitle text.
  ///
  /// Ignored if [subtitleStyle] is provided with a color.
  final Color? subtitleColor;

  /// The spacing between elements.
  ///
  /// Defaults to 16.
  final double spacing;

  /// Padding around the entire widget.
  ///
  /// Defaults to EdgeInsets.all(24).
  final EdgeInsetsGeometry? padding;

  /// Text for the action button.
  ///
  /// If null, no button is displayed.
  final String? actionText;

  /// Callback when the action button is pressed.
  final VoidCallback? onActionPressed;

  /// Custom style for the action button.
  final ButtonStyle? actionButtonStyle;

  /// Whether to use compact styling.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final effectivePadding = padding ?? EdgeInsets.all(compact ? 16.r : 24.r);
    final effectiveImageSize = imageSize ?? (compact ? 80.0 : 200.0);
    final effectiveIconSize = iconSize ?? (compact ? 48.0 : 80.0);

    final effectiveTitleStyle = titleStyle ??
        TextStyle(
          fontSize: compact ? 14.sp : 18.sp,
          fontWeight: FontWeight.w600,
          color: titleColor ?? const Color(0xFF1F2937),
        );

    final effectiveSubtitleStyle = subtitleStyle ??
        TextStyle(
          fontSize: compact ? 12.sp : 14.sp,
          fontWeight: FontWeight.w400,
          color: subtitleColor ?? const Color(0xFF6B7280),
          height: 1.5,
        );

    return Center(
      child: Padding(
        padding: effectivePadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Visual element (image, icon, or custom widget)
            if (customWidget != null) ...[
              customWidget!,
              SizedBox(height: spacing.h),
            ] else if (icon != null) ...[
              Icon(
                icon,
                size: effectiveIconSize.sp,
                color: iconColor ?? const Color(0xFF9CA3AF),
              ),
              SizedBox(height: spacing.h),
            ] else if (image != null) ...[
              Image.asset(
                image!,
                width: imageWidth ?? effectiveImageSize,
                height: imageHeight ?? effectiveImageSize,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.image_not_supported_outlined,
                  size: effectiveIconSize.sp,
                  color: const Color(0xFF9CA3AF),
                ),
              ),
              SizedBox(height: spacing.h),
            ],

            // Title
            Text(
              title,
              style: effectiveTitleStyle,
              textAlign: TextAlign.center,
            ),

            // Subtitle
            if (subtitle != null && subtitle!.isNotEmpty) ...[
              SizedBox(height: (spacing / 2).h),
              Text(
                subtitle!,
                style: effectiveSubtitleStyle,
                textAlign: TextAlign.center,
              ),
            ],

            // Action button
            if (actionText != null && onActionPressed != null) ...[
              SizedBox(height: (spacing * 1.5).h),
              ElevatedButton(
                onPressed: onActionPressed,
                style: actionButtonStyle ??
                    ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 12.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      elevation: 0,
                    ),
                child: Text(
                  actionText!,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
