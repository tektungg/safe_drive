import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safe_drive/shared/styles/color_style.dart';

/// A fully customizable divider widget with optional text label.
///
/// This widget provides a horizontal divider that can optionally display
/// a text label in the center, commonly used for "OR" separators in
/// authentication flows.
///
/// ## Features
/// - Plain horizontal divider or divider with centered text
/// - Customizable line color, thickness, and indent
/// - Customizable text style and padding
/// - Responsive sizing with ScreenUtil
///
/// ## Usage Examples
///
/// ### Simple Divider
/// ```dart
/// CustomDividerWidget()
/// ```
///
/// ### Divider with Text
/// ```dart
/// CustomDividerWidget(
///   text: 'OR',
/// )
/// ```
///
/// ### Divider with Custom Color
/// ```dart
/// CustomDividerWidget(
///   text: 'OR',
///   lineColor: Colors.blue,
///   textColor: Colors.blue,
/// )
/// ```
///
/// ### Divider with Custom Thickness
/// ```dart
/// CustomDividerWidget(
///   thickness: 2,
///   lineColor: Colors.grey[400],
/// )
/// ```
///
/// ### Divider with Custom Text Style
/// ```dart
/// CustomDividerWidget(
///   text: 'Continue with',
///   fontSize: 16,
///   fontWeight: FontWeight.bold,
///   textColor: Colors.black87,
/// )
/// ```
///
/// ### Divider with Indent
/// ```dart
/// CustomDividerWidget(
///   text: 'OR',
///   indent: 20,
///   endIndent: 20,
/// )
/// ```
///
/// ### Divider with Custom Horizontal Padding
/// ```dart
/// CustomDividerWidget(
///   text: 'OR',
///   horizontalPadding: 24,
/// )
/// ```
class CustomDividerWidget extends StatelessWidget {
  /// Creates a customizable divider widget.
  ///
  /// All parameters are optional. When [text] is null, a simple divider
  /// is displayed without any label.
  const CustomDividerWidget({
    super.key,
    this.text,
    this.lineColor,
    this.textColor,
    this.thickness,
    this.indent,
    this.endIndent,
    this.fontSize,
    this.fontWeight,
    this.horizontalPadding,
    this.height,
  });

  /// The text to display in the center of the divider.
  ///
  /// If null, a plain divider without text is displayed.
  final String? text;

  /// The color of the divider lines.
  ///
  /// Defaults to `Colors.grey[300]`.
  final Color? lineColor;

  /// The color of the text label.
  ///
  /// Defaults to `Colors.grey[600]`.
  final Color? textColor;

  /// The thickness of the divider lines.
  ///
  /// Defaults to `1`.
  final double? thickness;

  /// The amount of empty space to the leading edge of the divider.
  ///
  /// Defaults to `0`.
  final double? indent;

  /// The amount of empty space to the trailing edge of the divider.
  ///
  /// Defaults to `0`.
  final double? endIndent;

  /// The font size of the text label.
  ///
  /// Defaults to `14.sp` (responsive).
  final double? fontSize;

  /// The font weight of the text label.
  ///
  /// Defaults to `FontWeight.w500`.
  final FontWeight? fontWeight;

  /// The horizontal padding around the text label.
  ///
  /// Defaults to `16.w` (responsive).
  final double? horizontalPadding;

  /// The height of the divider widget.
  ///
  /// Only used when [text] is null. Defaults to `1`.
  final double? height;

  @override
  Widget build(BuildContext context) {
    final effectiveLineColor = lineColor ?? ColorStyle.divider;
    final effectiveTextColor = textColor ?? ColorStyle.textSecondary;
    final effectiveThickness = thickness ?? 1;
    final effectiveIndent = indent ?? 0;
    final effectiveEndIndent = endIndent ?? 0;
    final effectiveFontSize = fontSize ?? 14.sp;
    final effectiveFontWeight = fontWeight ?? FontWeight.w500;
    final effectiveHorizontalPadding = horizontalPadding ?? 16.w;

    // Plain divider without text
    if (text == null) {
      return Divider(
        color: effectiveLineColor,
        thickness: effectiveThickness,
        indent: effectiveIndent,
        endIndent: effectiveEndIndent,
        height: height ?? 1,
      );
    }

    // Divider with centered text
    return Row(
      children: [
        if (effectiveIndent > 0) SizedBox(width: effectiveIndent),
        Expanded(
          child: Divider(
            color: effectiveLineColor,
            thickness: effectiveThickness,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: effectiveHorizontalPadding),
          child: Text(
            text!,
            style: TextStyle(
              color: effectiveTextColor,
              fontSize: effectiveFontSize,
              fontWeight: effectiveFontWeight,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: effectiveLineColor,
            thickness: effectiveThickness,
          ),
        ),
        if (effectiveEndIndent > 0) SizedBox(width: effectiveEndIndent),
      ],
    );
  }
}
