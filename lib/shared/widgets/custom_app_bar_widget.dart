import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:get/get.dart";
import "package:safe_drive/shared/styles/color_style.dart";

/// A fully customizable app bar widget that wraps Flutter's [AppBar].
///
/// This widget provides a consistent app bar design across the application
/// with sensible defaults while allowing full customization of all AppBar
/// properties.
///
/// ## Features
/// - Clean white background with black text by default
/// - iOS-style back arrow (arrow_back_ios) instead of default Android arrow
/// - Centered title by default
/// - Custom leading button callback support
/// - All standard AppBar properties exposed for customization
///
/// ## Usage Examples
///
/// ### Basic App Bar with Title
/// ```dart
/// Scaffold(
///   appBar: const CustomAppBarWidget(
///     title: 'Home',
///   ),
///   body: ...,
/// )
/// ```
///
/// ### App Bar with Custom Title Widget
/// ```dart
/// CustomAppBarWidget(
///   titleWidget: Row(
///     mainAxisSize: MainAxisSize.min,
///     children: [
///       Icon(Icons.star),
///       SizedBox(width: 8),
///       Text('Premium'),
///     ],
///   ),
/// )
/// ```
///
/// ### App Bar with Actions
/// ```dart
/// CustomAppBarWidget(
///   title: 'Settings',
///   actions: [
///     IconButton(
///       icon: Icon(Icons.search),
///       onPressed: () => search(),
///     ),
///     IconButton(
///       icon: Icon(Icons.more_vert),
///       onPressed: () => showMenu(),
///     ),
///   ],
/// )
/// ```
///
/// ### App Bar with Custom Colors
/// ```dart
/// CustomAppBarWidget(
///   title: 'Profile',
///   backgroundColor: Colors.blue,
///   foregroundColor: Colors.white,
/// )
/// ```
///
/// ### App Bar with Custom Back Button Action
/// ```dart
/// CustomAppBarWidget(
///   title: 'Edit',
///   onLeadingPressed: () {
///     showDialog(
///       context: context,
///       builder: (context) => AlertDialog(
///         title: Text('Discard changes?'),
///         actions: [
///           TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
///           TextButton(onPressed: () => Get.back(closeOverlays: true), child: Text('Discard')),
///         ],
///       ),
///     );
///   },
/// )
/// ```
///
/// ### App Bar without Back Button
/// ```dart
/// CustomAppBarWidget(
///   title: 'Dashboard',
///   automaticallyImplyLeading: false,
/// )
/// ```
///
/// ### App Bar with Custom Leading Widget
/// ```dart
/// CustomAppBarWidget(
///   title: 'Menu',
///   leading: IconButton(
///     icon: Icon(Icons.menu),
///     onPressed: () => Scaffold.of(context).openDrawer(),
///   ),
/// )
/// ```
///
/// ### App Bar with Bottom Widget (TabBar)
/// ```dart
/// CustomAppBarWidget(
///   title: 'Categories',
///   bottom: TabBar(
///     tabs: [
///       Tab(text: 'All'),
///       Tab(text: 'Popular'),
///       Tab(text: 'Recent'),
///     ],
///   ),
/// )
/// ```
///
/// ### Transparent App Bar
/// ```dart
/// CustomAppBarWidget(
///   title: 'Gallery',
///   backgroundColor: Colors.transparent,
///   elevation: 0,
///   forceMaterialTransparency: true,
/// )
/// ```
///
/// ### App Bar with Flexible Space (Gradient)
/// ```dart
/// CustomAppBarWidget(
///   title: 'Welcome',
///   foregroundColor: Colors.white,
///   flexibleSpace: Container(
///     decoration: BoxDecoration(
///       gradient: LinearGradient(
///         colors: [Colors.blue, Colors.purple],
///         begin: Alignment.topLeft,
///         end: Alignment.bottomRight,
///       ),
///     ),
///   ),
/// )
/// ```
class CustomAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  /// Creates a customizable app bar widget.
  ///
  /// Either [title] or [titleWidget] can be provided, but not both.
  /// If both are provided, [titleWidget] takes precedence.
  const CustomAppBarWidget({
    super.key,
    this.title,
    this.titleWidget,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.centerTitle = true,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.actions,
    this.bottom,
    this.shape,
    this.iconTheme,
    this.actionsIconTheme,
    this.titleTextStyle,
    this.primary = true,
    this.excludeHeaderSemantics,
    this.titleSpacing,
    this.toolbarOpacity = 1.0,
    this.bottomOpacity = 1.0,
    this.toolbarHeight,
    this.leadingWidth,
    this.systemOverlayStyle,
    this.shadowColor,
    this.surfaceTintColor,
    this.forceMaterialTransparency = false,
    this.clipBehavior,
    this.notificationPredicate = defaultScrollNotificationPredicate,
    this.onLeadingPressed,
    this.flexibleSpace,
  });

  /// The primary text displayed in the app bar.
  ///
  /// If [titleWidget] is provided, this will be ignored.
  final String? title;

  /// A custom widget to display as the title.
  ///
  /// Takes precedence over [title] if both are provided.
  final Widget? titleWidget;

  /// The background color of the app bar.
  ///
  /// Defaults to `Colors.white`.
  final Color? backgroundColor;

  /// The foreground color for text and icons.
  ///
  /// Defaults to `Colors.black`.
  final Color? foregroundColor;

  /// The elevation (shadow) of the app bar.
  ///
  /// Defaults to the theme's default elevation.
  final double? elevation;

  /// Whether the title should be centered.
  ///
  /// Defaults to `true`.
  final bool centerTitle;

  /// A widget to display before the title.
  ///
  /// If null and [automaticallyImplyLeading] is true, an iOS-style
  /// back button will be shown when navigation is possible.
  final Widget? leading;

  /// Whether to automatically show a back button when possible.
  ///
  /// Defaults to `true`.
  final bool automaticallyImplyLeading;

  /// A list of widgets to display after the title.
  ///
  /// Typically [IconButton] widgets for common actions.
  final List<Widget>? actions;

  /// A widget to display at the bottom of the app bar.
  ///
  /// Typically a [TabBar] or [PreferredSize] widget.
  final PreferredSizeWidget? bottom;

  /// The shape of the app bar's material.
  final ShapeBorder? shape;

  /// The theme for icons in the app bar.
  final IconThemeData? iconTheme;

  /// The theme for action icons in the app bar.
  final IconThemeData? actionsIconTheme;

  /// The text style for the title.
  final TextStyle? titleTextStyle;

  /// Whether this app bar is the primary app bar for the scaffold.
  ///
  /// Defaults to `true`.
  final bool primary;

  /// Whether to exclude the app bar from semantics.
  final bool? excludeHeaderSemantics;

  /// The spacing around the title.
  final double? titleSpacing;

  /// The opacity of the toolbar.
  ///
  /// Defaults to `1.0`.
  final double toolbarOpacity;

  /// The opacity of the bottom widget.
  ///
  /// Defaults to `1.0`.
  final double bottomOpacity;

  /// The height of the toolbar.
  final double? toolbarHeight;

  /// The width of the leading widget.
  final double? leadingWidth;

  /// The system UI overlay style.
  final SystemUiOverlayStyle? systemOverlayStyle;

  /// The color of the shadow below the app bar.
  final Color? shadowColor;

  /// The surface tint color for Material 3.
  final Color? surfaceTintColor;

  /// Whether to force material transparency.
  ///
  /// Defaults to `false`.
  final bool forceMaterialTransparency;

  /// The clip behavior for the app bar.
  final Clip? clipBehavior;

  /// A predicate for scroll notifications.
  final ScrollNotificationPredicate notificationPredicate;

  /// Callback when the leading button is pressed.
  ///
  /// If null, defaults to `Get.back()`.
  final VoidCallback? onLeadingPressed;

  /// A widget to display behind the title and actions.
  ///
  /// Typically used for gradient backgrounds.
  final Widget? flexibleSpace;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: titleWidget ??
          (title != null
              ? Text(
                  title!,
                  style: titleTextStyle ??
                      Get.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: foregroundColor ?? ColorStyle.textPrimary,
                      ),
                )
              : null),
      backgroundColor: backgroundColor ?? ColorStyle.white,
      foregroundColor: foregroundColor ?? ColorStyle.textPrimary,
      elevation: elevation,
      centerTitle: centerTitle,
      leading: leading ??
          (automaticallyImplyLeading && Navigator.canPop(context)
              ? IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: foregroundColor ?? ColorStyle.textPrimary,
                  ),
                  onPressed: onLeadingPressed ?? () => Get.back(),
                )
              : null),
      automaticallyImplyLeading: automaticallyImplyLeading,
      actions: actions,
      bottom: bottom,
      shape: shape,
      iconTheme: iconTheme ??
          IconThemeData(
            color: foregroundColor ?? ColorStyle.textPrimary,
          ),
      actionsIconTheme: actionsIconTheme ??
          IconThemeData(
            color: foregroundColor ?? ColorStyle.textPrimary,
          ),
      primary: primary,
      excludeHeaderSemantics: excludeHeaderSemantics ?? false,
      titleSpacing: titleSpacing,
      toolbarOpacity: toolbarOpacity,
      bottomOpacity: bottomOpacity,
      toolbarHeight: toolbarHeight,
      leadingWidth: leadingWidth,
      systemOverlayStyle: systemOverlayStyle,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      forceMaterialTransparency: forceMaterialTransparency,
      clipBehavior: clipBehavior,
      scrolledUnderElevation: elevation,
      notificationPredicate: notificationPredicate,
      flexibleSpace: flexibleSpace,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        toolbarHeight ?? kToolbarHeight + (bottom?.preferredSize.height ?? 0),
      );
}
