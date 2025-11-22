import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safe_drive/shared/styles/color_style.dart';
import 'package:safe_drive/shared/styles/text_style.dart';

/// A fully customizable button widget that supports various styles and states.
///
/// This widget provides a consistent button design across the application with
/// support for loading states, icons, and different visual styles.
///
/// ## Features
/// - Primary and outlined button styles
/// - Loading state with circular progress indicator
/// - Leading and trailing icon support
/// - Fully customizable colors, sizes, and shapes
/// - Disabled state handling
///
/// ## Usage Examples
///
/// ### Basic Primary Button
/// ```dart
/// CustomButtonWidget(
///   text: 'Submit',
///   onPressed: () => print('Submitted'),
/// )
/// ```
///
/// ### Loading Button
/// ```dart
/// CustomButtonWidget(
///   text: 'Sign In',
///   isLoading: true,
///   onPressed: () => signIn(),
/// )
/// ```
///
/// ### Outlined Button
/// ```dart
/// CustomButtonWidget(
///   text: 'Cancel',
///   isOutlined: true,
///   onPressed: () => Navigator.pop(context),
/// )
/// ```
///
/// ### Button with Leading Icon
/// ```dart
/// CustomButtonWidget(
///   text: 'Continue with Google',
///   leadingIcon: Image.asset('assets/google.png', width: 24, height: 24),
///   backgroundColor: Colors.white,
///   textColor: Colors.black87,
///   borderColor: Colors.grey[300],
///   onPressed: () => signInWithGoogle(),
/// )
/// ```
///
/// ### Button with Trailing Icon
/// ```dart
/// CustomButtonWidget(
///   text: 'Next',
///   trailingIcon: Icon(Icons.arrow_forward, size: 20),
///   onPressed: () => goToNextPage(),
/// )
/// ```
///
/// ### Disabled Button
/// ```dart
/// CustomButtonWidget(
///   text: 'Submit',
///   isDisabled: true,
///   onPressed: () {},
/// )
/// ```
///
/// ### Custom Styled Button
/// ```dart
/// CustomButtonWidget(
///   text: 'Delete',
///   backgroundColor: Colors.red,
///   textColor: Colors.white,
///   borderRadius: 24,
///   height: 56,
///   onPressed: () => deleteItem(),
/// )
/// ```
class CustomButtonWidget extends StatelessWidget {
  /// Creates a customizable button widget.
  ///
  /// The [text] and [onPressed] parameters are required.
  const CustomButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.isOutlined = false,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.disabledBackgroundColor,
    this.disabledTextColor,
    this.loadingIndicatorColor,
    this.leadingIcon,
    this.trailingIcon,
    this.width,
    this.height,
    this.borderRadius,
    this.elevation,
    this.fontSize,
    this.fontWeight,
    this.padding,
    this.iconSpacing,
  });

  /// The text displayed on the button.
  final String text;

  /// Called when the button is tapped.
  ///
  /// If [isLoading] or [isDisabled] is true, this callback will not be invoked.
  final VoidCallback onPressed;

  /// Whether the button is in a loading state.
  ///
  /// When true, displays a circular progress indicator instead of [text]
  /// and disables the button. Defaults to `false`.
  final bool isLoading;

  /// Whether the button is disabled.
  ///
  /// When true, the button will be grayed out and [onPressed] will not be
  /// invoked. Defaults to `false`.
  final bool isDisabled;

  /// Whether to use outlined style instead of filled.
  ///
  /// When true, the button will have a transparent background with a border.
  /// Defaults to `false`.
  final bool isOutlined;

  /// The background color of the button.
  ///
  /// Defaults to `Colors.blue` for filled buttons or `Colors.transparent`
  /// for outlined buttons.
  final Color? backgroundColor;

  /// The color of the button text.
  ///
  /// Defaults to `Colors.white` for filled buttons or `Colors.blue`
  /// for outlined buttons.
  final Color? textColor;

  /// The color of the button border.
  ///
  /// Only visible when [isOutlined] is true or when explicitly set.
  /// Defaults to `Colors.blue` for outlined buttons.
  final Color? borderColor;

  /// The background color when the button is disabled.
  ///
  /// Defaults to `Colors.grey[300]`.
  final Color? disabledBackgroundColor;

  /// The text color when the button is disabled.
  ///
  /// Defaults to `Colors.grey[500]`.
  final Color? disabledTextColor;

  /// The color of the loading indicator.
  ///
  /// Defaults to [textColor] or `Colors.white` for filled buttons.
  final Color? loadingIndicatorColor;

  /// An optional widget to display before the text.
  ///
  /// Typically an [Icon] or [Image] widget.
  final Widget? leadingIcon;

  /// An optional widget to display after the text.
  ///
  /// Typically an [Icon] widget.
  final Widget? trailingIcon;

  /// The width of the button.
  ///
  /// If null, the button will expand to fill its parent width.
  final double? width;

  /// The height of the button.
  ///
  /// Defaults to `52.h` (responsive).
  final double? height;

  /// The border radius of the button.
  ///
  /// Defaults to `12.r` (responsive).
  final double? borderRadius;

  /// The elevation of the button.
  ///
  /// Defaults to `2` for filled buttons or `0` for outlined buttons.
  final double? elevation;

  /// The font size of the button text.
  ///
  /// Defaults to `16.sp` (responsive).
  final double? fontSize;

  /// The font weight of the button text.
  ///
  /// Defaults to `FontWeight.w600`.
  final FontWeight? fontWeight;

  /// The padding inside the button.
  ///
  /// Defaults to `EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h)`.
  final EdgeInsetsGeometry? padding;

  /// The spacing between icon and text.
  ///
  /// Defaults to `8.w` (responsive).
  final double? iconSpacing;

  @override
  Widget build(BuildContext context) {
    final bool effectiveDisabled = isDisabled || isLoading;

    // Determine colors based on state and style
    final Color effectiveBackgroundColor = effectiveDisabled
        ? (disabledBackgroundColor ?? ColorStyle.gray300)
        : (isOutlined
            ? (backgroundColor ?? ColorStyle.transparent)
            : (backgroundColor ?? ColorStyle.primary));

    final Color effectiveTextColor = effectiveDisabled
        ? (disabledTextColor ?? ColorStyle.gray500)
        : (isOutlined
            ? (textColor ?? ColorStyle.primary)
            : (textColor ?? ColorStyle.textOnPrimary));

    final Color effectiveBorderColor = effectiveDisabled
        ? (disabledBackgroundColor ?? ColorStyle.gray300)
        : (borderColor ?? (isOutlined ? ColorStyle.primary : ColorStyle.transparent));

    final Color effectiveLoadingColor =
        loadingIndicatorColor ?? effectiveTextColor;

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 52.h,
      child: ElevatedButton(
        onPressed: effectiveDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: effectiveBackgroundColor,
          foregroundColor: effectiveTextColor,
          disabledBackgroundColor: effectiveBackgroundColor,
          disabledForegroundColor: effectiveTextColor,
          elevation: elevation ?? (isOutlined ? 0 : 2),
          padding: padding ??
              EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 12.r),
            side: BorderSide(
              color: effectiveBorderColor,
              width: isOutlined || borderColor != null ? 1 : 0,
            ),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 20.w,
                height: 20.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(effectiveLoadingColor),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (leadingIcon != null) ...[
                    leadingIcon!,
                    SizedBox(width: iconSpacing ?? 8.w),
                  ],
                  Flexible(
                    child: Text(
                      text,
                      style: TextStyles.buttonLarge.copyWith(
                        fontSize: fontSize ?? 16.sp,
                        fontWeight: fontWeight,
                        color: effectiveTextColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (trailingIcon != null) ...[
                    SizedBox(width: iconSpacing ?? 8.w),
                    trailingIcon!,
                  ],
                ],
              ),
      ),
    );
  }
}
