import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:safe_drive/shared/styles/color_style.dart';

/// A fully customizable shimmer loading effect widget.
///
/// This widget provides a consistent shimmer animation for loading states
/// across the application. It supports various shapes, sizes, and color
/// configurations.
///
/// ## Features
/// - Customizable dimensions (width, height)
/// - Multiple shape options (rectangle, circle, rounded rectangle)
/// - Configurable shimmer colors (base, highlight)
/// - Adjustable animation duration and direction
/// - Support for custom child widgets
///
/// ## Usage Examples
///
/// ### Basic Rectangle Shimmer
/// ```dart
/// CustomShimmerWidget(
///   width: 200.w,
///   height: 20.h,
/// )
/// ```
///
/// ### Circle Shimmer (Avatar Placeholder)
/// ```dart
/// CustomShimmerWidget(
///   width: 60.w,
///   height: 60.h,
///   shape: ShimmerShape.circle,
/// )
/// ```
///
/// ### Rounded Rectangle Shimmer
/// ```dart
/// CustomShimmerWidget(
///   width: double.infinity,
///   height: 150.h,
///   borderRadius: 16,
/// )
/// ```
///
/// ### Custom Colors Shimmer
/// ```dart
/// CustomShimmerWidget(
///   width: 100.w,
///   height: 100.h,
///   baseColor: Colors.grey[400]!,
///   highlightColor: Colors.grey[100]!,
/// )
/// ```
///
/// ### Shimmer with Custom Child
/// ```dart
/// CustomShimmerWidget.custom(
///   child: Column(
///     children: [
///       Container(width: 200, height: 20, color: Colors.white),
///       SizedBox(height: 8),
///       Container(width: 150, height: 20, color: Colors.white),
///     ],
///   ),
/// )
/// ```
///
/// ### List Loading Shimmer
/// ```dart
/// ListView.builder(
///   itemCount: 5,
///   itemBuilder: (context, index) => Padding(
///     padding: EdgeInsets.symmetric(vertical: 8.h),
///     child: Row(
///       children: [
///         CustomShimmerWidget(
///           width: 50.w,
///           height: 50.h,
///           shape: ShimmerShape.circle,
///         ),
///         SizedBox(width: 12.w),
///         Expanded(
///           child: Column(
///             crossAxisAlignment: CrossAxisAlignment.start,
///             children: [
///               CustomShimmerWidget(width: double.infinity, height: 16.h),
///               SizedBox(height: 8.h),
///               CustomShimmerWidget(width: 100.w, height: 12.h),
///             ],
///           ),
///         ),
///       ],
///     ),
///   ),
/// )
/// ```
///
/// See also:
/// - [Shimmer] - The underlying shimmer package
/// - [CustomEmptyWidget] - For displaying empty states
class CustomShimmerWidget extends StatelessWidget {
  /// Creates a shimmer widget with specified dimensions.
  ///
  /// The [width] and [height] parameters define the size of the shimmer area.
  const CustomShimmerWidget({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
    this.shape = ShimmerShape.rectangle,
    this.baseColor,
    this.highlightColor,
    this.duration = const Duration(milliseconds: 1500),
    this.direction = ShimmerDirection.ltr,
    this.enabled = true,
  }) : child = null;

  /// Creates a shimmer widget with a custom child.
  ///
  /// Use this constructor when you need complex shimmer layouts.
  const CustomShimmerWidget.custom({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.duration = const Duration(milliseconds: 1500),
    this.direction = ShimmerDirection.ltr,
    this.enabled = true,
  })  : width = 0,
        height = 0,
        borderRadius = null,
        shape = ShimmerShape.rectangle;

  /// The width of the shimmer container.
  ///
  /// Use [double.infinity] to fill available width.
  final double width;

  /// The height of the shimmer container.
  final double height;

  /// The border radius for rounded rectangle shape.
  ///
  /// Only applies when [shape] is [ShimmerShape.rectangle].
  /// Defaults to 8.r if not specified.
  final double? borderRadius;

  /// The shape of the shimmer container.
  ///
  /// Defaults to [ShimmerShape.rectangle].
  final ShimmerShape shape;

  /// The base color of the shimmer effect.
  ///
  /// This is the color shown in non-highlighted areas.
  /// Defaults to grey with 40% opacity.
  final Color? baseColor;

  /// The highlight color of the shimmer effect.
  ///
  /// This is the color of the shimmer wave.
  /// Defaults to white.
  final Color? highlightColor;

  /// The duration of one shimmer animation cycle.
  ///
  /// Defaults to 1500 milliseconds.
  final Duration duration;

  /// The direction of the shimmer animation.
  ///
  /// Defaults to left-to-right ([ShimmerDirection.ltr]).
  final ShimmerDirection direction;

  /// Whether the shimmer animation is enabled.
  ///
  /// Set to false to pause the animation.
  /// Defaults to true.
  final bool enabled;

  /// Custom child widget for complex shimmer layouts.
  ///
  /// When provided, [width], [height], and [shape] are ignored.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final effectiveBaseColor = baseColor ?? ColorStyle.gray300;
    final effectiveHighlightColor = highlightColor ?? ColorStyle.gray100;

    return Shimmer.fromColors(
      baseColor: effectiveBaseColor,
      highlightColor: effectiveHighlightColor,
      period: duration,
      direction: direction,
      enabled: enabled,
      child: child ?? _buildShimmerContainer(),
    );
  }

  Widget _buildShimmerContainer() {
    final effectiveRadius = borderRadius ?? 8.r;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: ColorStyle.white,
        shape: shape == ShimmerShape.circle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: shape == ShimmerShape.rectangle
            ? BorderRadius.circular(effectiveRadius)
            : null,
      ),
    );
  }
}

/// Defines the shape of the shimmer container.
enum ShimmerShape {
  /// Rectangular shape with optional border radius.
  rectangle,

  /// Circular shape, useful for avatar placeholders.
  circle,
}
