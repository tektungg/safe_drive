import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:safe_drive/shared/styles/color_style.dart';

/// A minimalist and animated toast notification widget.
///
/// This widget provides beautiful toast notifications with smooth slide and
/// fade animations. It supports different types (success, error, warning, info)
/// with appropriate icons and colors.
///
/// ## Features
/// - Smooth slide-in and fade animations
/// - Multiple toast types with predefined styles
/// - Auto-dismiss with configurable duration
/// - Customizable appearance and position
/// - Non-intrusive overlay display
///
/// ## Usage Examples
///
/// ### Success Toast
/// ```dart
/// CustomToast.show(
///   message: 'Sign in successful!',
///   type: ToastType.success,
/// );
/// ```
///
/// ### Error Toast
/// ```dart
/// CustomToast.show(
///   message: 'Something went wrong',
///   type: ToastType.error,
/// );
/// ```
///
/// ### Warning Toast
/// ```dart
/// CustomToast.show(
///   message: 'Please check your input',
///   type: ToastType.warning,
/// );
/// ```
///
/// ### Info Toast
/// ```dart
/// CustomToast.show(
///   message: 'New update available',
///   type: ToastType.info,
/// );
/// ```
///
/// ### Custom Duration
/// ```dart
/// CustomToast.show(
///   message: 'Processing...',
///   type: ToastType.info,
///   duration: Duration(seconds: 5),
/// );
/// ```
///
/// ### Custom Position
/// ```dart
/// CustomToast.show(
///   message: 'Message sent',
///   type: ToastType.success,
///   position: ToastPosition.bottom,
/// );
/// ```

/// Toast notification types with predefined styles.
enum ToastType {
  /// Green toast for successful operations.
  success,

  /// Red toast for errors.
  error,

  /// Orange toast for warnings.
  warning,

  /// Blue toast for informational messages.
  info,
}

/// Toast position on screen.
enum ToastPosition {
  /// Display at the top of the screen.
  top,

  /// Display at the bottom of the screen.
  bottom,
}

/// A utility class for showing minimalist toast notifications.
class CustomToast {
  static OverlayEntry? _currentOverlay;

  /// Shows a toast notification with the specified [message] and [type].
  ///
  /// Parameters:
  /// - [message]: The text to display in the toast.
  /// - [type]: The type of toast (success, error, warning, info).
  /// - [duration]: How long to show the toast. Defaults to 2.5 seconds.
  /// - [position]: Where to show the toast. Defaults to top.
  static void show({
    required String message,
    ToastType type = ToastType.success,
    Duration duration = const Duration(milliseconds: 2500),
    ToastPosition position = ToastPosition.top,
  }) {
    // Remove any existing toast
    _currentOverlay?.remove();
    _currentOverlay = null;

    // Get the navigator's overlay state
    final context = Get.key.currentContext;
    if (context == null) return;

    final navigator = Navigator.of(context);
    final overlayState = navigator.overlay;

    if (overlayState == null) return;

    _currentOverlay = OverlayEntry(
      builder: (context) => _ToastOverlay(
        message: message,
        type: type,
        duration: duration,
        position: position,
        onDismiss: () {
          _currentOverlay?.remove();
          _currentOverlay = null;
        },
      ),
    );

    overlayState.insert(_currentOverlay!);
  }

  /// Dismisses the currently showing toast immediately.
  static void dismiss() {
    _currentOverlay?.remove();
    _currentOverlay = null;
  }
}

class _ToastOverlay extends StatefulWidget {
  final String message;
  final ToastType type;
  final Duration duration;
  final ToastPosition position;
  final VoidCallback onDismiss;

  const _ToastOverlay({
    required this.message,
    required this.type,
    required this.duration,
    required this.position,
    required this.onDismiss,
  });

  @override
  State<_ToastOverlay> createState() => _ToastOverlayState();
}

class _ToastOverlayState extends State<_ToastOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    final slideBegin = widget.position == ToastPosition.top
        ? const Offset(0, -1)
        : const Offset(0, 1);

    _slideAnimation = Tween<Offset>(
      begin: slideBegin,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();

    // Auto dismiss
    Future.delayed(widget.duration - const Duration(milliseconds: 350), () {
      if (mounted) {
        _controller.reverse().then((_) {
          if (mounted) {
            widget.onDismiss();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _backgroundColor {
    switch (widget.type) {
      case ToastType.success:
        return ColorStyle.success;
      case ToastType.error:
        return ColorStyle.danger;
      case ToastType.warning:
        return ColorStyle.warning;
      case ToastType.info:
        return ColorStyle.info;
    }
  }

  IconData get _icon {
    switch (widget.type) {
      case ToastType.success:
        return Icons.check_circle_rounded;
      case ToastType.error:
        return Icons.error_rounded;
      case ToastType.warning:
        return Icons.warning_rounded;
      case ToastType.info:
        return Icons.info_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.position == ToastPosition.top ? 50.h : null,
      bottom: widget.position == ToastPosition.bottom ? 50.h : null,
      left: 20.w,
      right: 20.w,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            color: ColorStyle.transparent,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 14.h,
              ),
              decoration: BoxDecoration(
                color: _backgroundColor,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: _backgroundColor.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    _icon,
                    color: ColorStyle.white,
                    size: 22.sp,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      widget.message,
                      style: TextStyle(
                        color: ColorStyle.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _controller.reverse().then((_) {
                        widget.onDismiss();
                      });
                    },
                    child: Icon(
                      Icons.close_rounded,
                      color: ColorStyle.white.withValues(alpha: 0.8),
                      size: 20.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
