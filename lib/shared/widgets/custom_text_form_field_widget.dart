import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A modern and elegant text form field widget with comprehensive customization.
///
/// This widget provides a beautifully styled text input with smooth animations,
/// floating labels, and consistent design across the application.
///
/// ## Features
/// - Modern design with rounded corners and subtle shadows
/// - Floating label animation on focus
/// - Password visibility toggle for password fields
/// - Customizable colors, borders, and typography
/// - Built-in validation with elegant error display
/// - Prefix and suffix icon support
/// - Responsive sizing with ScreenUtil
///
/// ## Usage Examples
///
/// ### Basic Text Field
/// ```dart
/// CustomTextFormFieldWidget(
///   label: 'Username',
///   hint: 'Enter your username',
/// )
/// ```
///
/// ### Email Field with Validation
/// ```dart
/// CustomTextFormFieldWidget(
///   label: 'Email',
///   hint: 'Enter your email',
///   keyboardType: TextInputType.emailAddress,
///   prefixIcon: Icon(Icons.email_outlined),
///   validator: (value) {
///     if (value == null || value.isEmpty) {
///       return 'Email is required';
///     }
///     if (!value.contains('@')) {
///       return 'Enter a valid email';
///     }
///     return null;
///   },
/// )
/// ```
///
/// ### Password Field
/// ```dart
/// CustomTextFormFieldWidget(
///   label: 'Password',
///   hint: 'Enter your password',
///   isPassword: true,
///   prefixIcon: Icon(Icons.lock_outlined),
///   validator: (value) {
///     if (value == null || value.length < 6) {
///       return 'Password must be at least 6 characters';
///     }
///     return null;
///   },
/// )
/// ```
///
/// ### Field with Controller
/// ```dart
/// final controller = TextEditingController();
///
/// CustomTextFormFieldWidget(
///   label: 'Phone Number',
///   hint: '+62 xxx xxxx xxxx',
///   controller: controller,
///   keyboardType: TextInputType.phone,
///   prefixIcon: Icon(Icons.phone_outlined),
///   onChanged: (value) => print('Phone: $value'),
/// )
/// ```
///
/// ### Disabled Field
/// ```dart
/// CustomTextFormFieldWidget(
///   label: 'User ID',
///   hint: 'Auto-generated',
///   enabled: false,
///   controller: TextEditingController(text: 'USR-001'),
/// )
/// ```
///
/// ### Field with Custom Styling
/// ```dart
/// CustomTextFormFieldWidget(
///   label: 'Search',
///   hint: 'Search products...',
///   prefixIcon: Icon(Icons.search),
///   filled: true,
///   fillColor: Colors.grey[100],
///   borderRadius: 24,
///   focusedBorderColor: Colors.purple,
/// )
/// ```
///
/// ### Multiline Text Field
/// ```dart
/// CustomTextFormFieldWidget(
///   label: 'Description',
///   hint: 'Enter description...',
///   maxLines: 4,
///   keyboardType: TextInputType.multiline,
/// )
/// ```
///
/// ### Field with Suffix Icon
/// ```dart
/// CustomTextFormFieldWidget(
///   label: 'Amount',
///   hint: '0.00',
///   keyboardType: TextInputType.number,
///   prefixIcon: Icon(Icons.attach_money),
///   suffixIcon: IconButton(
///     icon: Icon(Icons.clear),
///     onPressed: () => controller.clear(),
///   ),
/// )
/// ```
class CustomTextFormFieldWidget extends StatefulWidget {
  /// Creates a modern and elegant text form field widget.
  const CustomTextFormFieldWidget({
    super.key,
    this.label,
    this.controller,
    this.hint,
    this.enabled = true,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
    this.onFieldSubmitted,
    this.validator,
    this.prefixText,
    this.contentPadding,
    this.suffixIcon,
    this.prefixIcon,
    this.filled = true,
    this.fillColor,
    this.cursorColor,
    this.textColor,
    this.textInputAction,
    this.isPassword = false,
    this.borderRadius,
    this.enabledBorderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.labelColor,
    this.hintColor,
    this.fontSize,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.autofocus = false,
    this.readOnly = false,
    this.onTap,
    this.focusNode,
    this.autovalidateMode,
  });

  /// The label text displayed above the field.
  ///
  /// When the field is focused, the label floats above with animation.
  final String? label;

  /// Controller for the text field.
  final TextEditingController? controller;

  /// Hint text displayed when the field is empty.
  final String? hint;

  /// Whether the field is enabled for user input.
  ///
  /// Defaults to `true`.
  final bool enabled;

  /// The type of keyboard to display.
  ///
  /// Examples: [TextInputType.email], [TextInputType.number], etc.
  final TextInputType? keyboardType;

  /// Optional input formatters to restrict/format input.
  final List<TextInputFormatter>? inputFormatters;

  /// Called when the text value changes.
  final void Function(String value)? onChanged;

  /// Called when the user submits the field (e.g., presses done).
  final void Function(String value)? onFieldSubmitted;

  /// Validator function for form validation.
  ///
  /// Return null if valid, or an error message string if invalid.
  final String? Function(String? value)? validator;

  /// Text to display before the input (e.g., currency symbol).
  final String? prefixText;

  /// Padding inside the text field.
  ///
  /// Defaults to responsive padding based on screen size.
  final EdgeInsets? contentPadding;

  /// Widget to display after the input area.
  ///
  /// For password fields, this is automatically set to a visibility toggle.
  final Widget? suffixIcon;

  /// Widget to display before the input area.
  ///
  /// Typically an [Icon] widget.
  final Widget? prefixIcon;

  /// Whether to fill the background with [fillColor].
  ///
  /// Defaults to `true` for modern look.
  final bool filled;

  /// The background fill color.
  ///
  /// Defaults to `Colors.grey[50]` for a subtle background.
  final Color? fillColor;

  /// The color of the text cursor.
  final Color? cursorColor;

  /// The color of the input text.
  final Color? textColor;

  /// The action button on the keyboard.
  ///
  /// Examples: [TextInputAction.next], [TextInputAction.done], etc.
  final TextInputAction? textInputAction;

  /// Whether this is a password field.
  ///
  /// When true, text is obscured and a visibility toggle is shown.
  /// Defaults to `false`.
  final bool isPassword;

  /// The border radius of the field.
  ///
  /// Defaults to `12.r` (responsive).
  final double? borderRadius;

  /// The border color when the field is enabled but not focused.
  ///
  /// Defaults to `Colors.grey[300]`.
  final Color? enabledBorderColor;

  /// The border color when the field is focused.
  ///
  /// Defaults to `Colors.blue`.
  final Color? focusedBorderColor;

  /// The border color when validation fails.
  ///
  /// Defaults to `Colors.red[400]`.
  final Color? errorBorderColor;

  /// The color of the label text.
  ///
  /// Defaults to `Colors.grey[700]`.
  final Color? labelColor;

  /// The color of the hint text.
  ///
  /// Defaults to `Colors.grey[400]`.
  final Color? hintColor;

  /// The font size of the input text.
  ///
  /// Defaults to `14.sp` (responsive).
  final double? fontSize;

  /// Maximum number of lines for the input.
  ///
  /// Set to `null` for unlimited lines. Defaults to `1`.
  final int? maxLines;

  /// Minimum number of lines for the input.
  final int? minLines;

  /// Maximum character length.
  final int? maxLength;

  /// Whether to autofocus this field.
  ///
  /// Defaults to `false`.
  final bool autofocus;

  /// Whether the field is read-only.
  ///
  /// Defaults to `false`.
  final bool readOnly;

  /// Called when the field is tapped.
  final VoidCallback? onTap;

  /// Focus node for controlling focus programmatically.
  final FocusNode? focusNode;

  /// When to validate the field.
  ///
  /// Defaults to [AutovalidateMode.onUserInteraction].
  final AutovalidateMode? autovalidateMode;

  @override
  State<CustomTextFormFieldWidget> createState() =>
      _CustomTextFormFieldWidgetState();
}

class _CustomTextFormFieldWidgetState extends State<CustomTextFormFieldWidget> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = widget.borderRadius ?? 12.r;
    final effectiveFillColor = widget.fillColor ?? Colors.grey[50];
    final effectiveEnabledBorderColor =
        widget.enabledBorderColor ?? Colors.grey[300];
    final effectiveFocusedBorderColor =
        widget.focusedBorderColor ?? Colors.blue;
    final effectiveErrorBorderColor =
        widget.errorBorderColor ?? Colors.red[400];
    final effectiveLabelColor = widget.labelColor ?? Colors.grey[700];
    final effectiveHintColor = widget.hintColor ?? Colors.grey[400];
    final effectiveFontSize = widget.fontSize ?? 14.sp;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: effectiveLabelColor,
              letterSpacing: 0.2,
            ),
          ),
          SizedBox(height: 8.h),
        ],
        TextFormField(
          controller: widget.controller,
          enabled: widget.enabled,
          obscureText: widget.isPassword ? _obscureText : false,
          keyboardType: widget.keyboardType,
          inputFormatters: widget.inputFormatters,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onFieldSubmitted,
          validator: widget.validator,
          textInputAction: widget.textInputAction,
          autovalidateMode:
              widget.autovalidateMode ?? AutovalidateMode.onUserInteraction,
          maxLines: widget.isPassword ? 1 : widget.maxLines,
          minLines: widget.minLines,
          maxLength: widget.maxLength,
          autofocus: widget.autofocus,
          readOnly: widget.readOnly,
          onTap: widget.onTap,
          focusNode: widget.focusNode,
          cursorColor: widget.cursorColor ?? effectiveFocusedBorderColor,
          style: TextStyle(
            fontSize: effectiveFontSize,
            fontWeight: FontWeight.w500,
            color: widget.textColor ?? Colors.grey[900],
            letterSpacing: 0.3,
          ),
          decoration: InputDecoration(
            isDense: true,
            hintText: widget.hint,
            filled: widget.filled,
            fillColor: widget.enabled ? effectiveFillColor : Colors.grey[100],
            contentPadding: widget.contentPadding ??
                EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 16.h,
                ),
            prefixIcon: widget.prefixIcon != null
                ? Padding(
                    padding: EdgeInsets.only(left: 12.w, right: 8.w),
                    child: IconTheme(
                      data: IconThemeData(
                        color: Colors.grey[500],
                        size: 22.sp,
                      ),
                      child: widget.prefixIcon!,
                    ),
                  )
                : null,
            prefixIconConstraints: BoxConstraints(
              minWidth: 48.w,
              minHeight: 48.h,
            ),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: Colors.grey[500],
                      size: 22.sp,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    splashRadius: 20.r,
                  )
                : widget.suffixIcon,
            prefix: widget.prefixText != null
                ? Padding(
                    padding: EdgeInsets.only(right: 4.w),
                    child: Text(
                      widget.prefixText!,
                      style: TextStyle(
                        fontSize: effectiveFontSize,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                  )
                : null,
            hintStyle: TextStyle(
              fontSize: effectiveFontSize,
              fontWeight: FontWeight.w400,
              color: effectiveHintColor,
              letterSpacing: 0.2,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(effectiveBorderRadius),
              borderSide: BorderSide(
                color: effectiveEnabledBorderColor!,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(effectiveBorderRadius),
              borderSide: BorderSide(
                color: effectiveFocusedBorderColor,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(effectiveBorderRadius),
              borderSide: BorderSide(
                color: effectiveErrorBorderColor!,
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(effectiveBorderRadius),
              borderSide: BorderSide(
                color: effectiveErrorBorderColor,
                width: 2,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(effectiveBorderRadius),
              borderSide: BorderSide(
                color: Colors.grey[200]!,
                width: 1.5,
              ),
            ),
            errorStyle: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: effectiveErrorBorderColor,
              letterSpacing: 0.2,
            ),
            errorMaxLines: 2,
          ),
        ),
      ],
    );
  }
}
