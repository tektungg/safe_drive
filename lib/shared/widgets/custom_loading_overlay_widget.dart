import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:safe_drive/shared/styles/color_style.dart';
import 'package:safe_drive/shared/styles/text_style.dart';

/// A fully customizable full-screen loading overlay widget with animations.
///
/// This widget provides a consistent loading experience across the application
/// with support for custom indicators, messages, and animations.
///
/// ## Features
/// - Full-screen overlay with customizable background
/// - Multiple loading indicator styles
/// - Optional loading message
/// - Smooth fade animation
/// - Barrier to prevent user interaction
/// - Support for custom loading widgets
///
/// ## Usage Examples
///
/// ### Basic Loading Overlay
/// ```dart
/// CustomLoadingOverlayWidget.show();
///
/// // Later, to hide:
/// CustomLoadingOverlayWidget.hide();
/// ```
///
/// ### Loading with Message
/// ```dart
/// CustomLoadingOverlayWidget.show(
///   message: 'Loading your data...',
/// );
/// ```
///
/// ### Custom Styled Loading
/// ```dart
/// CustomLoadingOverlayWidget.show(
///   message: 'Please wait',
///   indicatorColor: Colors.purple,
///   backgroundColor: Colors.black87,
///   messageStyle: TextStyle(color: Colors.white, fontSize: 16),
/// );
/// ```
///
/// ### Loading with Custom Indicator
/// ```dart
/// CustomLoadingOverlayWidget.show(
///   customIndicator: SpinKitFadingCircle(color: Colors.blue),
///   message: 'Processing...',
/// );
/// ```
///
/// ### Using as Widget (in Stack)
/// ```dart
/// Stack(
///   children: [
///     // Your content
///     MyContentWidget(),
///
///     // Loading overlay
///     if (isLoading)
///       const CustomLoadingOverlayWidget(
///         message: 'Saving...',
///       ),
///   ],
/// )
/// ```
///
/// ### Wrap Widget with Loading
/// ```dart
/// CustomLoadingOverlayWidget.wrap(
///   isLoading: controller.isLoading.value,
///   message: 'Loading...',
///   child: YourContentWidget(),
/// )
/// ```
///
/// See also:
/// - [CustomDialogWidget] - For dialogs
/// - [CustomShimmerWidget] - For skeleton loading
class CustomLoadingOverlayWidget extends StatefulWidget {
  /// Creates a loading overlay widget.
  const CustomLoadingOverlayWidget({
    super.key,
    this.message,
    this.messageStyle,
    this.indicatorColor,
    this.indicatorSize,
    this.backgroundColor,
    this.customIndicator,
    this.showIndicator = true,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  /// Shows the loading overlay as a dialog using GetX.
  ///
  /// No [BuildContext] required - can be called from anywhere (controllers, services).
  /// Use [hide] to dismiss the overlay.
  static Future<void> show({
    String? message,
    TextStyle? messageStyle,
    Color? indicatorColor,
    double? indicatorSize,
    Color? backgroundColor,
    Widget? customIndicator,
    bool showIndicator = true,
    Duration animationDuration = const Duration(milliseconds: 200),
    bool barrierDismissible = false,
  }) {
    return Get.generalDialog(
      barrierDismissible: barrierDismissible,
      barrierLabel: '',
      barrierColor: ColorStyle.transparent,
      transitionDuration: animationDuration,
      pageBuilder: (context, animation, secondaryAnimation) {
        return CustomLoadingOverlayWidget(
          message: message,
          messageStyle: messageStyle,
          indicatorColor: indicatorColor,
          indicatorSize: indicatorSize,
          backgroundColor: backgroundColor,
          customIndicator: customIndicator,
          showIndicator: showIndicator,
          animationDuration: animationDuration,
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  /// Hides the currently shown loading overlay.
  static void hide() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  /// Wraps a child widget with a loading overlay.
  ///
  /// The overlay is shown when [isLoading] is true.
  static Widget wrap({
    required bool isLoading,
    required Widget child,
    String? message,
    TextStyle? messageStyle,
    Color? indicatorColor,
    double? indicatorSize,
    Color? backgroundColor,
    Widget? customIndicator,
    bool showIndicator = true,
  }) {
    return Stack(
      children: [
        child,
        if (isLoading)
          CustomLoadingOverlayWidget(
            message: message,
            messageStyle: messageStyle,
            indicatorColor: indicatorColor,
            indicatorSize: indicatorSize,
            backgroundColor: backgroundColor,
            customIndicator: customIndicator,
            showIndicator: showIndicator,
          ),
      ],
    );
  }

  /// Optional message to display below the loading indicator.
  final String? message;

  /// Custom style for the message text.
  final TextStyle? messageStyle;

  /// Color of the loading indicator.
  ///
  /// Defaults to blue.
  final Color? indicatorColor;

  /// Size of the loading indicator.
  ///
  /// Defaults to 48.
  final double? indicatorSize;

  /// Background color of the overlay.
  ///
  /// Defaults to semi-transparent black.
  final Color? backgroundColor;

  /// Custom loading indicator widget.
  ///
  /// If provided, overrides the default circular progress indicator.
  final Widget? customIndicator;

  /// Whether to show the loading indicator.
  ///
  /// Set to false to show only the message.
  final bool showIndicator;

  /// Duration of the fade animation.
  final Duration animationDuration;

  @override
  State<CustomLoadingOverlayWidget> createState() =>
      _CustomLoadingOverlayWidgetState();
}

class _CustomLoadingOverlayWidgetState
    extends State<CustomLoadingOverlayWidget> {
  @override
  Widget build(BuildContext context) {
    final effectiveIndicatorColor =
        widget.indicatorColor ?? ColorStyle.primary;
    final effectiveIndicatorSize = widget.indicatorSize ?? 48.0;
    final effectiveBackgroundColor =
        widget.backgroundColor ?? ColorStyle.overlayLight;

    return Material(
      color: ColorStyle.transparent,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: effectiveBackgroundColor,
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 32.w,
              vertical: 24.h,
            ),
            decoration: BoxDecoration(
              color: ColorStyle.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: ColorStyle.shadowDark,
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Loading Indicator
                if (widget.showIndicator) ...[
                  widget.customIndicator ??
                      _AnimatedLoadingIndicator(
                        color: effectiveIndicatorColor,
                        size: effectiveIndicatorSize,
                      ),
                  if (widget.message != null) SizedBox(height: 20.h),
                ],

                // Message
                if (widget.message != null)
                  Text(
                    widget.message!,
                    style: widget.messageStyle ?? TextStyles.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedLoadingIndicator extends StatefulWidget {
  const _AnimatedLoadingIndicator({
    required this.color,
    required this.size,
  });

  final Color color;
  final double size;

  @override
  State<_AnimatedLoadingIndicator> createState() =>
      _AnimatedLoadingIndicatorState();
}

class _AnimatedLoadingIndicatorState extends State<_AnimatedLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size.sp,
      height: widget.size.sp,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _LoadingPainter(
              progress: _controller.value,
              color: widget.color,
              strokeWidth: 4.0,
            ),
          );
        },
      ),
    );
  }
}

class _LoadingPainter extends CustomPainter {
  _LoadingPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  final double progress;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background circle
    final backgroundPaint = Paint()
      ..color = color.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Animated arc
    final arcPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final startAngle = 2 * 3.141592653589793 * progress - 3.141592653589793 / 2;
    final sweepAngle =
        3.141592653589793 * 1.5 * (1 - (progress - 0.5).abs() * 2);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle.clamp(0.3, 3.141592653589793 * 1.5),
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _LoadingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
