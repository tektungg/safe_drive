import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:get/get.dart";

class CustomAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final bool centerTitle;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final ShapeBorder? shape;
  final IconThemeData? iconTheme;
  final IconThemeData? actionsIconTheme;
  final TextStyle? titleTextStyle;
  final bool primary;
  final bool? excludeHeaderSemantics;
  final double? titleSpacing;
  final double toolbarOpacity;
  final double bottomOpacity;
  final double? toolbarHeight;
  final double? leadingWidth;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final bool forceMaterialTransparency;
  final Clip? clipBehavior;
  final ScrollNotificationPredicate notificationPredicate;
  final VoidCallback? onLeadingPressed;
  final Widget? flexibleSpace;

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
                        color: foregroundColor ?? Colors.black,
                      ),
                )
              : null),
      backgroundColor: backgroundColor ?? Colors.white,
      foregroundColor: foregroundColor ?? Colors.black,
      elevation: elevation,
      centerTitle: centerTitle,
      leading: leading ??
          (automaticallyImplyLeading && Navigator.canPop(context)
              ? IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: foregroundColor ?? Colors.black,
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
            color: foregroundColor ?? Colors.black,
          ),
      actionsIconTheme: actionsIconTheme ??
          IconThemeData(
            color: foregroundColor ?? Colors.black,
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
