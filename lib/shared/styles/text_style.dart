import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safe_drive/shared/styles/color_style.dart';

/// A comprehensive text style system for the Safe Drive application.
///
/// This class provides consistent typography across the entire application
/// with predefined text styles for different use cases.
///
/// ## Categories
/// - Display Styles - Large, prominent text for headers
/// - Headline Styles - Section headers and titles
/// - Title Styles - Card titles and labels
/// - Body Styles - Main content text
/// - Label Styles - Form labels and small text
/// - Button Styles - Button text
/// - Caption Styles - Helper text and captions
///
/// ## Usage
/// ```dart
/// Text(
///   'Hello World',
///   style: TextStyles.displayLarge,
/// )
/// ```
class TextStyles {
  TextStyles._();

  // ==================== Display Styles ====================
  // Used for the largest text on screen (e.g., onboarding titles)

  /// Display large - 36sp, ExtraBold
  /// Use for: Splash screen, onboarding main titles
  static TextStyle displayLarge = TextStyle(
    fontSize: 36.sp,
    fontWeight: FontWeight.w800,
    color: ColorStyle.textPrimary,
    height: 1.2,
    letterSpacing: -0.5,
  );

  /// Display medium - 32sp, Bold
  /// Use for: Main screen titles, feature highlights
  static TextStyle displayMedium = TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.w700,
    color: ColorStyle.textPrimary,
    height: 1.2,
    letterSpacing: -0.5,
  );

  /// Display small - 28sp, Bold
  /// Use for: Dialog titles, important headers
  static TextStyle displaySmall = TextStyle(
    fontSize: 28.sp,
    fontWeight: FontWeight.w700,
    color: ColorStyle.textPrimary,
    height: 1.3,
    letterSpacing: -0.3,
  );

  // ==================== Headline Styles ====================
  // Used for section headers and important titles

  /// Headline large - 24sp, Bold
  /// Use for: Screen headers, section titles
  static TextStyle headlineLarge = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w700,
    color: ColorStyle.textPrimary,
    height: 1.3,
    letterSpacing: -0.2,
  );

  /// Headline medium - 20sp, Bold
  /// Use for: Card headers, subsection titles
  static TextStyle headlineMedium = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w700,
    color: ColorStyle.textPrimary,
    height: 1.4,
    letterSpacing: 0,
  );

  /// Headline small - 18sp, SemiBold
  /// Use for: Widget headers, list section titles
  static TextStyle headlineSmall = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: ColorStyle.textPrimary,
    height: 1.4,
    letterSpacing: 0,
  );

  // ==================== Title Styles ====================
  // Used for card titles and emphasized text

  /// Title large - 18sp, SemiBold
  /// Use for: Card titles, dialog titles
  static TextStyle titleLarge = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: ColorStyle.textPrimary,
    height: 1.4,
    letterSpacing: 0.1,
  );

  /// Title medium - 16sp, SemiBold
  /// Use for: List item titles, form section headers
  static TextStyle titleMedium = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: ColorStyle.textPrimary,
    height: 1.5,
    letterSpacing: 0.1,
  );

  /// Title small - 14sp, SemiBold
  /// Use for: Small card titles, tab labels
  static TextStyle titleSmall = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: ColorStyle.textPrimary,
    height: 1.5,
    letterSpacing: 0.1,
  );

  // ==================== Body Styles ====================
  // Used for main content text

  /// Body large - 16sp, Regular
  /// Use for: Main content, descriptions
  static TextStyle bodyLarge = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: ColorStyle.textPrimary,
    height: 1.5,
    letterSpacing: 0.2,
  );

  /// Body medium - 14sp, Regular
  /// Use for: Default body text, list items
  static TextStyle bodyMedium = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: ColorStyle.textPrimary,
    height: 1.5,
    letterSpacing: 0.2,
  );

  /// Body small - 12sp, Regular
  /// Use for: Secondary text, metadata
  static TextStyle bodySmall = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: ColorStyle.textSecondary,
    height: 1.5,
    letterSpacing: 0.2,
  );

  // ==================== Label Styles ====================
  // Used for form labels and UI labels

  /// Label large - 14sp, Medium
  /// Use for: Form labels, input labels
  static TextStyle labelLarge = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: ColorStyle.textSecondary,
    height: 1.4,
    letterSpacing: 0.1,
  );

  /// Label medium - 12sp, Medium
  /// Use for: Small labels, tags
  static TextStyle labelMedium = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    color: ColorStyle.textSecondary,
    height: 1.4,
    letterSpacing: 0.1,
  );

  /// Label small - 11sp, Medium
  /// Use for: Tiny labels, badges
  static TextStyle labelSmall = TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeight.w500,
    color: ColorStyle.textSecondary,
    height: 1.4,
    letterSpacing: 0.1,
  );

  // ==================== Button Styles ====================
  // Used for button text

  /// Button large - 16sp, SemiBold
  /// Use for: Primary buttons, large CTAs
  static TextStyle buttonLarge = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: ColorStyle.textOnPrimary,
    height: 1.2,
    letterSpacing: 0.3,
  );

  /// Button medium - 14sp, SemiBold
  /// Use for: Default buttons
  static TextStyle buttonMedium = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: ColorStyle.textOnPrimary,
    height: 1.2,
    letterSpacing: 0.3,
  );

  /// Button small - 12sp, SemiBold
  /// Use for: Small buttons, chips
  static TextStyle buttonSmall = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    color: ColorStyle.textOnPrimary,
    height: 1.2,
    letterSpacing: 0.3,
  );

  // ==================== Caption Styles ====================
  // Used for helper text and captions

  /// Caption large - 12sp, Regular
  /// Use for: Helper text, timestamps
  static TextStyle captionLarge = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: ColorStyle.textTertiary,
    height: 1.4,
    letterSpacing: 0.1,
  );

  /// Caption medium - 11sp, Regular
  /// Use for: Small helper text, hints
  static TextStyle captionMedium = TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeight.w400,
    color: ColorStyle.textTertiary,
    height: 1.4,
    letterSpacing: 0.1,
  );

  /// Caption small - 10sp, Regular
  /// Use for: Very small text, footnotes
  static TextStyle captionSmall = TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w400,
    color: ColorStyle.textTertiary,
    height: 1.4,
    letterSpacing: 0.1,
  );

  // ==================== Specialized Styles ====================
  // Context-specific text styles

  /// Authentication header title
  /// Use for: Sign in/up header titles
  static TextStyle authTitle = TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.w700,
    color: ColorStyle.textPrimary,
    height: 1.2,
    letterSpacing: -0.5,
  );

  /// Authentication subtitle
  /// Use for: Sign in/up subtitles
  static TextStyle authSubtitle = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: ColorStyle.textSecondary,
    height: 1.5,
    letterSpacing: 0.2,
  );

  /// Greeting text (e.g., "Hello, User!")
  /// Use for: Home screen greetings
  static TextStyle greeting = TextStyle(
    fontSize: 28.sp,
    fontWeight: FontWeight.w700,
    color: ColorStyle.textPrimary,
    height: 1.3,
    letterSpacing: -0.3,
  );

  /// Stat value (large numbers)
  /// Use for: Dashboard statistics
  static TextStyle statValue = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w700,
    color: ColorStyle.textPrimary,
    height: 1.2,
    letterSpacing: 0,
  );

  /// Stat label (description for stats)
  /// Use for: Labels below stat values
  static TextStyle statLabel = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    color: ColorStyle.textSecondary,
    height: 1.4,
    letterSpacing: 0.1,
  );

  /// Input text
  /// Use for: Text form field input
  static TextStyle inputText = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: ColorStyle.textPrimary,
    height: 1.5,
    letterSpacing: 0.3,
  );

  /// Input label
  /// Use for: Text form field labels
  static TextStyle inputLabel = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: ColorStyle.textSecondary,
    height: 1.4,
    letterSpacing: 0.1,
  );

  /// Input hint
  /// Use for: Text form field hints/placeholders
  static TextStyle inputHint = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: ColorStyle.textHint,
    height: 1.5,
    letterSpacing: 0.2,
  );

  /// Input error
  /// Use for: Form validation errors
  static TextStyle inputError = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    color: ColorStyle.danger,
    height: 1.4,
    letterSpacing: 0.1,
  );

  /// Link text
  /// Use for: Clickable links
  static TextStyle link = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: ColorStyle.link,
    height: 1.5,
    letterSpacing: 0.1,
    decoration: TextDecoration.underline,
  );

  /// Link text (no underline)
  /// Use for: Clickable text without underline
  static TextStyle linkPlain = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: ColorStyle.link,
    height: 1.5,
    letterSpacing: 0.1,
  );

  /// Empty state title
  /// Use for: Empty state messages
  static TextStyle emptyStateTitle = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: ColorStyle.textSecondary,
    height: 1.5,
    letterSpacing: 0.1,
  );

  /// Empty state subtitle
  /// Use for: Empty state descriptions
  static TextStyle emptyStateSubtitle = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: ColorStyle.textTertiary,
    height: 1.5,
    letterSpacing: 0.2,
  );

  /// Toast message
  /// Use for: Toast notifications
  static TextStyle toast = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: ColorStyle.white,
    height: 1.4,
    letterSpacing: 0.2,
  );

  /// Dialog title
  /// Use for: Dialog headers
  static TextStyle dialogTitle = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w700,
    color: ColorStyle.textPrimary,
    height: 1.3,
    letterSpacing: 0,
  );

  /// Dialog message
  /// Use for: Dialog content
  static TextStyle dialogMessage = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: ColorStyle.textSecondary,
    height: 1.5,
    letterSpacing: 0.2,
  );

  /// Bottom sheet title
  /// Use for: Bottom sheet headers
  static TextStyle bottomSheetTitle = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w700,
    color: ColorStyle.textPrimary,
    height: 1.3,
    letterSpacing: 0,
  );

  /// Bottom sheet subtitle
  /// Use for: Bottom sheet descriptions
  static TextStyle bottomSheetSubtitle = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: ColorStyle.textSecondary,
    height: 1.5,
    letterSpacing: 0.2,
  );

  /// App bar title
  /// Use for: AppBar titles
  static TextStyle appBarTitle = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    color: ColorStyle.textPrimary,
    height: 1.2,
    letterSpacing: 0,
  );

  /// Tab label
  /// Use for: Tab bar labels
  static TextStyle tabLabel = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: ColorStyle.textPrimary,
    height: 1.2,
    letterSpacing: 0.2,
  );

  /// Chip label
  /// Use for: Chip/badge text
  static TextStyle chipLabel = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    color: ColorStyle.textPrimary,
    height: 1.2,
    letterSpacing: 0.2,
  );

  /// Price/Money text
  /// Use for: Monetary values
  static TextStyle price = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w700,
    color: ColorStyle.textPrimary,
    height: 1.2,
    letterSpacing: -0.5,
  );

  /// Timestamp
  /// Use for: Time and date displays
  static TextStyle timestamp = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: ColorStyle.textTertiary,
    height: 1.4,
    letterSpacing: 0.1,
  );

  // ==================== Status Styles ====================
  // Used for status indicators (safe, warning, danger, etc.)

  /// Safe status text
  /// Use for: Safe driving indicators
  static TextStyle statusSafe = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: ColorStyle.safe,
    height: 1.4,
    letterSpacing: 0.2,
  );

  /// Moderate status text
  /// Use for: Moderate driving indicators
  static TextStyle statusModerate = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: ColorStyle.moderate,
    height: 1.4,
    letterSpacing: 0.2,
  );

  /// Risky status text
  /// Use for: Risky driving indicators
  static TextStyle statusRisky = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: ColorStyle.risky,
    height: 1.4,
    letterSpacing: 0.2,
  );

  /// Dangerous status text
  /// Use for: Dangerous driving indicators
  static TextStyle statusDangerous = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: ColorStyle.dangerous,
    height: 1.4,
    letterSpacing: 0.2,
  );

  /// Success status text
  /// Use for: Success messages
  static TextStyle statusSuccess = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: ColorStyle.success,
    height: 1.4,
    letterSpacing: 0.2,
  );

  /// Warning status text
  /// Use for: Warning messages
  static TextStyle statusWarning = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: ColorStyle.warning,
    height: 1.4,
    letterSpacing: 0.2,
  );

  /// Error status text
  /// Use for: Error messages
  static TextStyle statusError = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: ColorStyle.danger,
    height: 1.4,
    letterSpacing: 0.2,
  );

  /// Info status text
  /// Use for: Informational messages
  static TextStyle statusInfo = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: ColorStyle.info,
    height: 1.4,
    letterSpacing: 0.2,
  );
}
