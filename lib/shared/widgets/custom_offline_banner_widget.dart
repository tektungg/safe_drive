import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:safe_drive/shared/styles/color_style.dart';
import 'package:safe_drive/utils/services/connectivity_service.dart';
import 'package:safe_drive/utils/services/logger_service.dart';

/// A fully customizable offline banner widget that shows/hides based on connectivity.
///
/// This widget automatically listens to connectivity changes and displays
/// a banner when the device loses internet connection.
///
/// ## Features
/// - Automatic show/hide based on connectivity status
/// - Smooth slide animation
/// - Color transition when connection is restored (red → green)
/// - Auto-hide after connection restored with delay
/// - Loading indicator on retry button
/// - Customizable colors, text, and styling
/// - Connection type indicator
/// - Retry button option
/// - Dismissible option
///
/// ## Usage
///
/// ### Basic usage (in GetMaterialApp builder)
/// ```dart
/// GetMaterialApp(
///   builder: (context, child) {
///     return CustomOfflineBannerWidget(
///       showRetryButton: true,
///       showConnectionType: true,
///       child: child ?? SizedBox.shrink(),
///     );
///   },
/// );
/// ```
///
/// ### Custom styling
/// ```dart
/// CustomOfflineBannerWidget(
///   backgroundColor: Colors.red.shade900,
///   textColor: Colors.white,
///   message: 'No Internet Connection',
///   showConnectionType: true,
///   showRetryButton: true,
///   connectionRestoredDelay: Duration(seconds: 3),
///   child: YourScreen(),
/// );
/// ```
class CustomOfflineBannerWidget extends StatefulWidget {
  /// The child widget to wrap
  final Widget child;

  /// Banner background color when offline
  final Color? offlineBackgroundColor;

  /// Banner background color when connection restored
  final Color? onlineBackgroundColor;

  /// Text color
  final Color? textColor;

  /// Icon color
  final Color? iconColor;

  /// Banner message when offline
  final String? offlineMessage;

  /// Banner message when connection restored
  final String? onlineMessage;

  /// Banner position (top or bottom)
  final BannerPosition position;

  /// Show connection type (WiFi, Mobile, etc.)
  final bool showConnectionType;

  /// Show retry button
  final bool showRetryButton;

  /// Allow user to dismiss banner
  final bool dismissible;

  /// Banner height
  final double? height;

  /// Animation duration
  final Duration animationDuration;

  /// Delay before hiding banner after connection restored
  final Duration connectionRestoredDelay;

  /// Custom retry callback
  final VoidCallback? onRetry;

  /// Custom dismiss callback
  final VoidCallback? onDismiss;

  const CustomOfflineBannerWidget({
    super.key,
    required this.child,
    this.offlineBackgroundColor,
    this.onlineBackgroundColor,
    this.textColor,
    this.iconColor,
    this.offlineMessage,
    this.onlineMessage,
    this.position = BannerPosition.top,
    this.showConnectionType = true,
    this.showRetryButton = false,
    this.dismissible = false,
    this.height,
    this.animationDuration = const Duration(milliseconds: 300),
    this.connectionRestoredDelay = const Duration(seconds: 2),
    this.onRetry,
    this.onDismiss,
  });

  @override
  State<CustomOfflineBannerWidget> createState() =>
      _CustomOfflineBannerWidgetState();
}

class _CustomOfflineBannerWidgetState extends State<CustomOfflineBannerWidget> {
  final RxBool _isRetrying = false.obs;
  final Rx<BannerState> _bannerState = BannerState.hidden.obs;
  Timer? _hideTimer;
  bool _previousConnectionState = true;

  @override
  void initState() {
    super.initState();
    _initConnectivityListener();
  }

  void _initConnectivityListener() {
    // Check if ConnectivityService is available
    if (!Get.isRegistered<ConnectivityService>()) {
      return;
    }

    // Listen to connectivity changes
    ever(ConnectivityService.to.isConnected, (isConnected) {
      _handleConnectivityChange(isConnected);
    });

    // Set initial state
    final isConnected = ConnectivityService.to.isConnected.value;
    _bannerState.value = isConnected ? BannerState.hidden : BannerState.offline;
    _previousConnectionState = isConnected;
  }

  void _handleConnectivityChange(bool isConnected) {
    // Cancel any pending hide timer
    _hideTimer?.cancel();

    if (!_previousConnectionState && isConnected) {
      // Connection restored: offline → online
      LoggerService.i('Connection restored - showing success banner');
      _bannerState.value = BannerState.online;

      // Auto-hide after delay
      _hideTimer = Timer(widget.connectionRestoredDelay, () {
        if (mounted) {
          LoggerService.d('Auto-hiding banner after connection restored');
          _bannerState.value = BannerState.hidden;
        }
      });
    } else if (_previousConnectionState && !isConnected) {
      // Connection lost: online → offline
      LoggerService.w('Connection lost - showing offline banner');
      _bannerState.value = BannerState.offline;
    }

    _previousConnectionState = isConnected;
  }

  Future<void> _handleRetry() async {
    if (_isRetrying.value) return;

    try {
      _isRetrying.value = true;
      LoggerService.i('Manual retry triggered');

      // Call custom retry callback if provided
      widget.onRetry?.call();

      // Refresh connectivity status
      await ConnectivityService.to.refresh();

      // Wait a bit to show the loading state
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      LoggerService.e('Error during retry', error: e);
    } finally {
      if (mounted) {
        _isRetrying.value = false;
      }
    }
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check if ConnectivityService is available
    if (!Get.isRegistered<ConnectivityService>()) {
      return widget.child;
    }

    return Stack(
      children: [
        widget.child,
        Obx(() {
          final state = _bannerState.value;
          final shouldShow = state != BannerState.hidden;

          return AnimatedPositioned(
            duration: widget.animationDuration,
            curve: Curves.easeInOut,
            top: widget.position == BannerPosition.top && shouldShow ? 0 : null,
            bottom: widget.position == BannerPosition.bottom && shouldShow
                ? 0
                : null,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              duration: widget.animationDuration,
              opacity: shouldShow ? 1 : 0,
              child: IgnorePointer(
                ignoring: !shouldShow,
                child: _BannerContent(
                  state: state,
                  offlineBackgroundColor: widget.offlineBackgroundColor,
                  onlineBackgroundColor: widget.onlineBackgroundColor,
                  textColor: widget.textColor,
                  iconColor: widget.iconColor,
                  offlineMessage: widget.offlineMessage,
                  onlineMessage: widget.onlineMessage,
                  showConnectionType: widget.showConnectionType,
                  showRetryButton: widget.showRetryButton,
                  dismissible: widget.dismissible,
                  height: widget.height,
                  isRetrying: _isRetrying.value,
                  onRetry: _handleRetry,
                  onDismiss: widget.onDismiss,
                  animationDuration: widget.animationDuration,
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _BannerContent extends StatelessWidget {
  final BannerState state;
  final Color? offlineBackgroundColor;
  final Color? onlineBackgroundColor;
  final Color? textColor;
  final Color? iconColor;
  final String? offlineMessage;
  final String? onlineMessage;
  final bool showConnectionType;
  final bool showRetryButton;
  final bool dismissible;
  final double? height;
  final bool isRetrying;
  final VoidCallback? onRetry;
  final VoidCallback? onDismiss;
  final Duration animationDuration;

  const _BannerContent({
    required this.state,
    this.offlineBackgroundColor,
    this.onlineBackgroundColor,
    this.textColor,
    this.iconColor,
    this.offlineMessage,
    this.onlineMessage,
    required this.showConnectionType,
    required this.showRetryButton,
    required this.dismissible,
    this.height,
    required this.isRetrying,
    this.onRetry,
    this.onDismiss,
    required this.animationDuration,
  });

  Color _getBackgroundColor() {
    switch (state) {
      case BannerState.offline:
        return offlineBackgroundColor ?? ColorStyle.danger;
      case BannerState.online:
      case BannerState.hidden:
        return onlineBackgroundColor ?? ColorStyle.success;
    }
  }

  IconData _getIcon() {
    switch (state) {
      case BannerState.offline:
        return Icons.wifi_off_rounded;
      case BannerState.online:
      case BannerState.hidden:
        return Icons.wifi_rounded;
    }
  }

  String _getMessage() {
    switch (state) {
      case BannerState.offline:
        return offlineMessage ?? 'No Internet Connection';
      case BannerState.online:
      case BannerState.hidden:
        return onlineMessage ?? 'Connection Restored';
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultTextColor = ColorStyle.white;
    final defaultIconColor = ColorStyle.white;

    return AnimatedContainer(
      duration: animationDuration,
      curve: Curves.easeInOut,
      color: _getBackgroundColor(),
      child: Material(
        color: ColorStyle.transparent,
        elevation: 4,
        child: SafeArea(
          child: Container(
            height: height ?? 56.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              children: [
                // Icon with animation
                AnimatedSwitcher(
                  duration: animationDuration,
                  child: Icon(
                    _getIcon(),
                    key: ValueKey(state),
                    color: iconColor ?? defaultIconColor,
                    size: 20.sp,
                  ),
                ),
                SizedBox(width: 12.w),

                // Message and connection type
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedSwitcher(
                        duration: animationDuration,
                        child: Text(
                          _getMessage(),
                          key: ValueKey(state),
                          style: TextStyle(
                            color: textColor ?? defaultTextColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (showConnectionType) ...[
                        SizedBox(height: 2.h),
                        Obx(() {
                          final typeName =
                              ConnectivityService.to.getConnectionTypeName();
                          return Text(
                            'Connection: $typeName',
                            style: TextStyle(
                              color: (textColor ?? defaultTextColor)
                                  .withValues(alpha: 0.8),
                              fontSize: 11.sp,
                            ),
                          );
                        }),
                      ],
                    ],
                  ),
                ),

                // Retry button (only show when offline)
                if (showRetryButton && state == BannerState.offline) ...[
                  SizedBox(width: 8.w),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: isRetrying
                        ? SizedBox(
                            width: 20.w,
                            height: 20.h,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                textColor ?? defaultTextColor,
                              ),
                            ),
                          )
                        : TextButton(
                            onPressed: onRetry,
                            style: TextButton.styleFrom(
                              foregroundColor: textColor ?? defaultTextColor,
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 4.h,
                              ),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Retry',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                  ),
                ],

                // Dismiss button
                if (dismissible) ...[
                  SizedBox(width: 4.w),
                  IconButton(
                    onPressed: onDismiss,
                    icon: Icon(
                      Icons.close_rounded,
                      color: iconColor ?? defaultIconColor,
                      size: 18.sp,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Banner state enum
enum BannerState {
  /// Banner is hidden
  hidden,

  /// Showing offline state (red)
  offline,

  /// Showing online/restored state (green)
  online,
}

/// Banner position enum
enum BannerPosition {
  /// Show at top of screen
  top,

  /// Show at bottom of screen
  bottom,
}
