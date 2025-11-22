import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:safe_drive/shared/styles/color_style.dart';

/// A fully customizable dialog widget with consistent styling and animations.
///
/// This widget provides a modern, animated dialog design for alerts,
/// confirmations, and custom content across the application.
///
/// ## Features
/// - Multiple dialog types (alert, confirmation, custom)
/// - Smooth scale and fade animations
/// - Customizable icons with colored backgrounds
/// - Primary and secondary action buttons
/// - Support for custom content
/// - Barrier dismissible option
///
/// ## Usage Examples
///
/// ### Basic Alert Dialog
/// ```dart
/// CustomDialogWidget.show(
///   context: context,
///   type: DialogType.info,
///   title: 'Information',
///   message: 'This is an informational message.',
///   primaryButtonText: 'OK',
/// );
/// ```
///
/// ### Success Dialog
/// ```dart
/// CustomDialogWidget.show(
///   context: context,
///   type: DialogType.success,
///   title: 'Success!',
///   message: 'Your profile has been updated successfully.',
///   primaryButtonText: 'Continue',
///   onPrimaryPressed: () => Navigator.pop(context),
/// );
/// ```
///
/// ### Error Dialog
/// ```dart
/// CustomDialogWidget.show(
///   context: context,
///   type: DialogType.error,
///   title: 'Error',
///   message: 'Something went wrong. Please try again.',
///   primaryButtonText: 'Retry',
///   secondaryButtonText: 'Cancel',
///   onPrimaryPressed: () => retryOperation(),
///   onSecondaryPressed: () => Navigator.pop(context),
/// );
/// ```
///
/// ### Confirmation Dialog
/// ```dart
/// CustomDialogWidget.show(
///   context: context,
///   type: DialogType.warning,
///   title: 'Delete Account?',
///   message: 'This action cannot be undone. Are you sure you want to delete your account?',
///   primaryButtonText: 'Delete',
///   secondaryButtonText: 'Cancel',
///   primaryButtonColor: Colors.red,
///   onPrimaryPressed: () => deleteAccount(),
/// );
/// ```
///
/// ### Custom Content Dialog
/// ```dart
/// CustomDialogWidget.show(
///   context: context,
///   title: 'Select Option',
///   customContent: Column(
///     children: [
///       ListTile(title: Text('Option 1'), onTap: () {}),
///       ListTile(title: Text('Option 2'), onTap: () {}),
///     ],
///   ),
///   primaryButtonText: 'Done',
/// );
/// ```
///
/// ### Dialog with Custom Icon
/// ```dart
/// CustomDialogWidget.show(
///   context: context,
///   icon: Icons.celebration,
///   iconColor: Colors.purple,
///   iconBackgroundColor: Colors.purple.withValues(alpha: 0.1),
///   title: 'Congratulations!',
///   message: 'You have earned a new badge.',
///   primaryButtonText: 'View Badge',
/// );
/// ```
///
/// See also:
/// - [CustomBottomSheetWidget] - For bottom sheet dialogs
/// - [CustomToastWidget] - For toast notifications
class CustomDialogWidget extends StatefulWidget {
  const CustomDialogWidget({
    super.key,
    this.type,
    this.icon,
    this.iconColor,
    this.iconBackgroundColor,
    this.iconSize,
    this.title,
    this.titleStyle,
    this.message,
    this.messageStyle,
    this.customContent,
    this.primaryButtonText,
    this.secondaryButtonText,
    this.primaryButtonColor,
    this.secondaryButtonColor,
    this.onPrimaryPressed,
    this.onSecondaryPressed,
    this.barrierDismissible = true,
    this.showCloseButton = false,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  /// Shows the dialog with the specified parameters using GetX.
  ///
  /// Returns a [Future] that resolves when the dialog is dismissed.
  /// No [BuildContext] required - can be called from anywhere (controllers, services).
  static Future<T?> show<T>({
    DialogType? type,
    IconData? icon,
    Color? iconColor,
    Color? iconBackgroundColor,
    double? iconSize,
    String? title,
    TextStyle? titleStyle,
    String? message,
    TextStyle? messageStyle,
    Widget? customContent,
    String? primaryButtonText,
    String? secondaryButtonText,
    Color? primaryButtonColor,
    Color? secondaryButtonColor,
    VoidCallback? onPrimaryPressed,
    VoidCallback? onSecondaryPressed,
    bool barrierDismissible = true,
    bool showCloseButton = false,
    Duration animationDuration = const Duration(milliseconds: 200),
  }) {
    return Get.generalDialog<T>(
      barrierDismissible: barrierDismissible,
      barrierLabel: 'Dialog',
      barrierColor: ColorStyle.overlay,
      transitionDuration: animationDuration,
      pageBuilder: (context, animation, secondaryAnimation) {
        return CustomDialogWidget(
          type: type,
          icon: icon,
          iconColor: iconColor,
          iconBackgroundColor: iconBackgroundColor,
          iconSize: iconSize,
          title: title,
          titleStyle: titleStyle,
          message: message,
          messageStyle: messageStyle,
          customContent: customContent,
          primaryButtonText: primaryButtonText,
          secondaryButtonText: secondaryButtonText,
          primaryButtonColor: primaryButtonColor,
          secondaryButtonColor: secondaryButtonColor,
          onPrimaryPressed: onPrimaryPressed,
          onSecondaryPressed: onSecondaryPressed,
          barrierDismissible: barrierDismissible,
          showCloseButton: showCloseButton,
          animationDuration: animationDuration,
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutBack,
          ),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }

  /// Closes the currently open dialog.
  ///
  /// Optionally pass a [result] to return to the caller.
  static void close<T>([T? result]) {
    if (Get.isDialogOpen ?? false) {
      Get.back<T>(result: result);
    }
  }

  /// The type of dialog, which determines the icon and color scheme.
  final DialogType? type;

  /// Custom icon to display. Overrides [type] icon if provided.
  final IconData? icon;

  /// Color of the icon.
  final Color? iconColor;

  /// Background color of the icon container.
  final Color? iconBackgroundColor;

  /// Size of the icon.
  final double? iconSize;

  /// The title text of the dialog.
  final String? title;

  /// Custom style for the title.
  final TextStyle? titleStyle;

  /// The message/body text of the dialog.
  final String? message;

  /// Custom style for the message.
  final TextStyle? messageStyle;

  /// Custom content widget to display instead of message.
  final Widget? customContent;

  /// Text for the primary (right) action button.
  final String? primaryButtonText;

  /// Text for the secondary (left) action button.
  final String? secondaryButtonText;

  /// Background color for the primary button.
  final Color? primaryButtonColor;

  /// Background color for the secondary button.
  final Color? secondaryButtonColor;

  /// Callback when primary button is pressed.
  final VoidCallback? onPrimaryPressed;

  /// Callback when secondary button is pressed.
  final VoidCallback? onSecondaryPressed;

  /// Whether tapping outside the dialog dismisses it.
  final bool barrierDismissible;

  /// Whether to show a close button in the top-right corner.
  final bool showCloseButton;

  /// Duration of the dialog animation.
  final Duration animationDuration;

  @override
  State<CustomDialogWidget> createState() => _CustomDialogWidgetState();
}

class _CustomDialogWidgetState extends State<CustomDialogWidget> {
  @override
  Widget build(BuildContext context) {
    final dialogConfig = _getDialogConfig();

    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 24.w),
        constraints: BoxConstraints(maxWidth: 340.w),
        decoration: BoxDecoration(
          color: ColorStyle.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: ColorStyle.shadowDark,
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Material(
          color: ColorStyle.transparent,
          child: Padding(
            padding: EdgeInsets.all(24.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Close button
                if (widget.showCloseButton) ...[
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: EdgeInsets.all(4.r),
                        decoration: BoxDecoration(
                          color: ColorStyle.gray100,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.close_rounded,
                          size: 20.sp,
                          color: ColorStyle.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                ],

                // Icon
                if (dialogConfig.icon != null) ...[
                  Container(
                    padding: EdgeInsets.all(16.r),
                    decoration: BoxDecoration(
                      color: dialogConfig.iconBackgroundColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      dialogConfig.icon,
                      size: widget.iconSize ?? 32.sp,
                      color: dialogConfig.iconColor,
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],

                // Title
                if (widget.title != null) ...[
                  Text(
                    widget.title!,
                    style: widget.titleStyle ??
                        TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          color: ColorStyle.textPrimary,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12.h),
                ],

                // Message or Custom Content
                if (widget.customContent != null)
                  widget.customContent!
                else if (widget.message != null)
                  Text(
                    widget.message!,
                    style: widget.messageStyle ??
                        TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: ColorStyle.textSecondary,
                          height: 1.5,
                        ),
                    textAlign: TextAlign.center,
                  ),

                // Buttons
                if (widget.primaryButtonText != null ||
                    widget.secondaryButtonText != null) ...[
                  SizedBox(height: 24.h),
                  Row(
                    children: [
                      // Secondary Button
                      if (widget.secondaryButtonText != null) ...[
                        Expanded(
                          child: _DialogButton(
                            text: widget.secondaryButtonText!,
                            onPressed: widget.onSecondaryPressed ??
                                () => Get.back(),
                            backgroundColor: widget.secondaryButtonColor ??
                                ColorStyle.gray100,
                            textColor: ColorStyle.textPrimary,
                            isOutlined: true,
                          ),
                        ),
                        SizedBox(width: 12.w),
                      ],

                      // Primary Button
                      if (widget.primaryButtonText != null)
                        Expanded(
                          child: _DialogButton(
                            text: widget.primaryButtonText!,
                            onPressed: widget.onPrimaryPressed ??
                                () => Get.back(),
                            backgroundColor: widget.primaryButtonColor ??
                                dialogConfig.primaryButtonColor,
                            textColor: ColorStyle.white,
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  _DialogConfig _getDialogConfig() {
    final effectiveIcon = widget.icon;
    final effectiveIconColor = widget.iconColor;
    final effectiveIconBgColor = widget.iconBackgroundColor;

    if (widget.type == null && effectiveIcon == null) {
      return _DialogConfig(
        icon: null,
        iconColor: null,
        iconBackgroundColor: null,
        primaryButtonColor: ColorStyle.primary,
      );
    }

    if (effectiveIcon != null) {
      return _DialogConfig(
        icon: effectiveIcon,
        iconColor: effectiveIconColor ?? ColorStyle.primary,
        iconBackgroundColor:
            effectiveIconBgColor ?? ColorStyle.primaryContainer,
        primaryButtonColor: widget.primaryButtonColor ?? ColorStyle.primary,
      );
    }

    switch (widget.type!) {
      case DialogType.success:
        return _DialogConfig(
          icon: Icons.check_circle_rounded,
          iconColor: ColorStyle.success,
          iconBackgroundColor: ColorStyle.successContainer,
          primaryButtonColor: ColorStyle.success,
        );
      case DialogType.error:
        return _DialogConfig(
          icon: Icons.error_rounded,
          iconColor: ColorStyle.danger,
          iconBackgroundColor: ColorStyle.dangerContainer,
          primaryButtonColor: ColorStyle.danger,
        );
      case DialogType.warning:
        return _DialogConfig(
          icon: Icons.warning_rounded,
          iconColor: ColorStyle.warning,
          iconBackgroundColor: ColorStyle.warningContainer,
          primaryButtonColor: ColorStyle.warning,
        );
      case DialogType.info:
        return _DialogConfig(
          icon: Icons.info_rounded,
          iconColor: ColorStyle.info,
          iconBackgroundColor: ColorStyle.infoContainer,
          primaryButtonColor: ColorStyle.info,
        );
      case DialogType.question:
        return _DialogConfig(
          icon: Icons.help_rounded,
          iconColor: ColorStyle.primary,
          iconBackgroundColor: ColorStyle.primaryContainer,
          primaryButtonColor: ColorStyle.primary,
        );
    }
  }
}

class _DialogButton extends StatelessWidget {
  const _DialogButton({
    required this.text,
    required this.onPressed,
    required this.backgroundColor,
    required this.textColor,
    this.isOutlined = false,
  });

  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final bool isOutlined;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorStyle.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14.h),
          decoration: BoxDecoration(
            color: isOutlined ? ColorStyle.transparent : backgroundColor,
            borderRadius: BorderRadius.circular(12.r),
            border: isOutlined
                ? Border.all(color: ColorStyle.border, width: 1.5)
                : null,
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: isOutlined ? textColor : ColorStyle.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DialogConfig {
  const _DialogConfig({
    required this.icon,
    required this.iconColor,
    required this.iconBackgroundColor,
    required this.primaryButtonColor,
  });

  final IconData? icon;
  final Color? iconColor;
  final Color? iconBackgroundColor;
  final Color primaryButtonColor;
}

/// The type of dialog to display.
enum DialogType {
  /// Success dialog with green checkmark icon.
  success,

  /// Error dialog with red error icon.
  error,

  /// Warning dialog with amber warning icon.
  warning,

  /// Info dialog with blue info icon.
  info,

  /// Question/confirmation dialog with purple question icon.
  question,
}
