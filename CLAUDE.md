# CLAUDE CODE INSTRUCTIONS

## Overview
This document contains comprehensive coding guidelines and instructions for Claude to follow when working on the Safe Drive application. The goal is to ensure consistency, maintainability, and adherence to established patterns throughout the codebase.

---

## Table of Contents
1. [Project Structure](#project-structure)
2. [Styling System](#styling-system)
3. [Shared Widgets](#shared-widgets)
4. [Services](#services)
5. [Feature Architecture](#feature-architecture)
6. [Code Generation Guidelines](#code-generation-guidelines)
7. [Best Practices](#best-practices)

---

## Project Structure

```
lib/
├── shared/
│   ├── styles/           # Centralized styling system
│   │   ├── color_style.dart
│   │   ├── text_style.dart
│   │   └── google_text_style.dart
│   └── widgets/          # Reusable UI components
│       ├── custom_button_widget.dart
│       ├── custom_text_form_field_widget.dart
│       ├── custom_dialog_widget.dart
│       ├── custom_toast_widget.dart
│       ├── custom_bottom_sheet_widget.dart
│       ├── custom_app_bar_widget.dart
│       ├── custom_divider_widget.dart
│       ├── custom_empty_widget.dart
│       ├── custom_loading_overlay_widget.dart
│       ├── custom_shimmer_widget.dart
│       ├── custom_offline_banner_widget.dart
│       ├── custom_bottom_navigation_bar_widget.dart
│       ├── custom_fab_bottom_app_bar_widget.dart
│       ├── auth_header_widget.dart
│       ├── auth_footer_widget.dart
│       └── password_requirements_widget.dart
├── utils/
│   └── services/         # Application-wide services
│       ├── logger_service.dart
│       ├── connectivity_service.dart
│       ├── permission_service.dart
│       ├── api_service.dart
│       ├── hive_service.dart
│       ├── supabase_service.dart
│       ├── image_service.dart
│       ├── applink_service.dart
│       └── notification_service/
│           ├── firebase_notification_service.dart
│           └── local_notification_service.dart
└── features/
    └── [feature_name]/
        ├── constants/
        ├── models/
        ├── bindings/
        ├── controllers/
        ├── repositories/
        └── screen/
            ├── ui/
            │   └── [feature_name]_screen.dart
            └── components/
                ├── [feature_name]_header_component.dart
                ├── [feature_name]_form_component.dart
                └── [feature_name]_action_button_component.dart
```

---

## Styling System

### **CRITICAL RULE: ALWAYS USE EXISTING STYLES**

**NEVER** hardcode colors or create TextStyle inline. **ALWAYS** use the centralized styling system.

### Color Usage

**File Location:** `lib/shared/styles/color_style.dart`

#### Available Color Categories:

**Primary Colors:**
```dart
ColorStyle.primary           // Main brand color
ColorStyle.primaryLight
ColorStyle.primaryDark
ColorStyle.primaryContainer
```

**Secondary Colors:**
```dart
ColorStyle.secondary
ColorStyle.secondaryLight
ColorStyle.secondaryDark
ColorStyle.secondaryContainer
```

**Semantic Colors:**
```dart
ColorStyle.success           // For success states
ColorStyle.danger            // For error states
ColorStyle.warning           // For warning states
ColorStyle.info              // For informational states
```

**Text Colors:**
```dart
ColorStyle.textPrimary       // Main text
ColorStyle.textSecondary     // Secondary text
ColorStyle.textTertiary      // Less important text
ColorStyle.textDisabled      // Disabled text
ColorStyle.textHint          // Placeholder/hint text
ColorStyle.textOnPrimary     // Text on colored backgrounds
```

**Background Colors:**
```dart
ColorStyle.background
ColorStyle.backgroundDark
ColorStyle.backgroundGray
ColorStyle.surface
ColorStyle.surfaceVariant
ColorStyle.scaffold
```

**Border Colors:**
```dart
ColorStyle.border
ColorStyle.borderLight
ColorStyle.borderDark
ColorStyle.divider
```

**Gray Scale:**
```dart
ColorStyle.gray50 to ColorStyle.gray900  // Gray palette
```

**Status Colors (Driving):**
```dart
ColorStyle.safe
ColorStyle.moderate
ColorStyle.risky
ColorStyle.dangerous
```

#### **Examples:**

**WRONG ❌:**
```dart
Container(
  color: Color(0xff007bff),  // Never hardcode colors
  child: Text(
    'Hello',
    style: TextStyle(color: Colors.black),  // Never use Colors class directly
  ),
)
```

**CORRECT ✅:**
```dart
Container(
  color: ColorStyle.primary,  // Use ColorStyle
  child: Text(
    'Hello',
    style: TextStyles.bodyMedium.copyWith(
      color: ColorStyle.textPrimary,
    ),
  ),
)
```

### Text Style Usage

**File Location:** `lib/shared/styles/text_style.dart`

#### Available Text Style Categories:

**Display Styles (Large headings):**
```dart
TextStyles.displayLarge      // 36sp, ExtraBold - Splash, onboarding
TextStyles.displayMedium     // 32sp, Bold - Main screen titles
TextStyles.displaySmall      // 28sp, Bold - Dialog titles
```

**Headline Styles (Section headers):**
```dart
TextStyles.headlineLarge     // 24sp, Bold - Screen headers
TextStyles.headlineMedium    // 20sp, Bold - Card headers
TextStyles.headlineSmall     // 18sp, SemiBold - Widget headers
```

**Title Styles (Card titles):**
```dart
TextStyles.titleLarge        // 18sp, SemiBold - Card titles
TextStyles.titleMedium       // 16sp, SemiBold - List titles
TextStyles.titleSmall        // 14sp, SemiBold - Small titles
```

**Body Styles (Main content):**
```dart
TextStyles.bodyLarge         // 16sp, Regular - Main content
TextStyles.bodyMedium        // 14sp, Regular - Default text
TextStyles.bodySmall         // 12sp, Regular - Secondary text
```

**Label Styles (Form labels):**
```dart
TextStyles.labelLarge        // 14sp, Medium - Form labels
TextStyles.labelMedium       // 12sp, Medium - Small labels
TextStyles.labelSmall        // 11sp, Medium - Tiny labels
```

**Button Styles:**
```dart
TextStyles.buttonLarge       // 16sp, SemiBold - Large buttons
TextStyles.buttonMedium      // 14sp, SemiBold - Default buttons
TextStyles.buttonSmall       // 12sp, SemiBold - Small buttons
```

**Caption Styles (Helper text):**
```dart
TextStyles.captionLarge      // 12sp, Regular - Helper text
TextStyles.captionMedium     // 11sp, Regular - Small hints
TextStyles.captionSmall      // 10sp, Regular - Footnotes
```

**Specialized Styles:**
```dart
TextStyles.authTitle         // Authentication headers
TextStyles.authSubtitle      // Authentication subtitles
TextStyles.greeting          // Home screen greetings
TextStyles.statValue         // Dashboard statistics
TextStyles.statLabel         // Stat labels
TextStyles.inputText         // Form input text
TextStyles.inputLabel        // Form labels
TextStyles.inputHint         // Form placeholders
TextStyles.inputError        // Validation errors
TextStyles.link              // Clickable links
TextStyles.linkPlain         // Links without underline
TextStyles.emptyStateTitle   // Empty state messages
TextStyles.toast             // Toast notifications
TextStyles.dialogTitle       // Dialog headers
TextStyles.dialogMessage     // Dialog content
TextStyles.bottomSheetTitle  // Bottom sheet headers
TextStyles.appBarTitle       // AppBar titles
TextStyles.tabLabel          // Tab labels
TextStyles.chipLabel         // Chip/badge text
TextStyles.price             // Monetary values
TextStyles.timestamp         // Time and date
```

**Status Styles:**
```dart
TextStyles.statusSafe
TextStyles.statusModerate
TextStyles.statusRisky
TextStyles.statusDangerous
TextStyles.statusSuccess
TextStyles.statusWarning
TextStyles.statusError
TextStyles.statusInfo
```

#### **Examples:**

**WRONG ❌:**
```dart
Text(
  'Welcome',
  style: TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  ),
)
```

**CORRECT ✅:**
```dart
Text(
  'Welcome',
  style: TextStyles.displayMedium,  // Use predefined style
)

// Or with color override:
Text(
  'Welcome',
  style: TextStyles.displayMedium.copyWith(
    color: ColorStyle.primary,
  ),
)
```

### Google Fonts

**File Location:** `lib/shared/styles/google_text_style.dart`

Only use when you need to apply Roboto font with specific weight:

```dart
Text(
  'Text',
  style: GoogleTextStyle.fw700,  // fw100 to fw900
)
```

---

## Shared Widgets

### **CRITICAL RULE: ALWAYS USE EXISTING WIDGETS**

**NEVER** create custom UI elements from scratch if a shared widget exists. **ALWAYS** check `lib/shared/widgets/` first.

### Available Widgets:

#### 1. CustomButtonWidget

**Purpose:** All button interactions

**File:** `lib/shared/widgets/custom_button_widget.dart`

**Key Features:**
- Primary and outlined styles
- Loading state
- Leading/trailing icons
- Fully customizable colors

**Usage Examples:**

```dart
// Basic button
CustomButtonWidget(
  text: 'Submit',
  onPressed: () => handleSubmit(),
)

// Loading button
CustomButtonWidget(
  text: 'Sign In',
  isLoading: controller.isLoading.value,
  onPressed: () => signIn(),
)

// Outlined button
CustomButtonWidget(
  text: 'Cancel',
  isOutlined: true,
  onPressed: () => Navigator.pop(context),
)

// Button with icon
CustomButtonWidget(
  text: 'Continue with Google',
  leadingIcon: Image.asset('assets/google.png', width: 24, height: 24),
  backgroundColor: ColorStyle.white,
  textColor: ColorStyle.textPrimary,
  onPressed: () => signInWithGoogle(),
)
```

#### 2. CustomTextFormFieldWidget

**Purpose:** All text input fields

**File:** `lib/shared/widgets/custom_text_form_field_widget.dart`

**Key Features:**
- Floating labels
- Password visibility toggle
- Validation support
- Prefix/suffix icons
- Auto-responsive sizing

**Usage Examples:**

```dart
// Basic text field
CustomTextFormFieldWidget(
  label: 'Username',
  hint: 'Enter your username',
)

// Email field with validation
CustomTextFormFieldWidget(
  label: 'Email',
  hint: 'Enter your email',
  keyboardType: TextInputType.emailAddress,
  prefixIcon: Icon(Icons.email_outlined),
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    return null;
  },
)

// Password field
CustomTextFormFieldWidget(
  label: 'Password',
  hint: 'Enter your password',
  isPassword: true,
  prefixIcon: Icon(Icons.lock_outlined),
  validator: controller.validatePassword,
)

// Field with controller
CustomTextFormFieldWidget(
  label: 'Phone Number',
  controller: controller.phoneController,
  keyboardType: TextInputType.phone,
  prefixIcon: Icon(Icons.phone_outlined),
  onChanged: (value) => print('Phone: $value'),
)
```

#### 3. CustomDialogWidget

**Purpose:** All dialog/alert interactions

**File:** `lib/shared/widgets/custom_dialog_widget.dart`

**Key Features:**
- Multiple types (success, error, warning, info, question)
- Smooth animations
- Icon support
- Primary/secondary buttons
- No BuildContext needed (uses GetX)

**Usage Examples:**

```dart
// Success dialog
CustomDialogWidget.show(
  type: DialogType.success,
  title: 'Success!',
  message: 'Your profile has been updated successfully.',
  primaryButtonText: 'Continue',
  onPrimaryPressed: () => Navigator.pop(context),
)

// Error dialog
CustomDialogWidget.show(
  type: DialogType.error,
  title: 'Error',
  message: 'Something went wrong. Please try again.',
  primaryButtonText: 'Retry',
  secondaryButtonText: 'Cancel',
  onPrimaryPressed: () => retryOperation(),
)

// Confirmation dialog
CustomDialogWidget.show(
  type: DialogType.warning,
  title: 'Delete Account?',
  message: 'This action cannot be undone.',
  primaryButtonText: 'Delete',
  secondaryButtonText: 'Cancel',
  primaryButtonColor: ColorStyle.danger,
  onPrimaryPressed: () => deleteAccount(),
)

// Custom icon dialog
CustomDialogWidget.show(
  icon: Icons.celebration,
  iconColor: ColorStyle.primary,
  title: 'Congratulations!',
  message: 'You have earned a new badge.',
  primaryButtonText: 'View Badge',
)
```

#### 4. CustomToast

**Purpose:** Toast notifications

**File:** `lib/shared/widgets/custom_toast_widget.dart`

**Key Features:**
- Multiple types (success, error, warning, info)
- Auto-dismiss
- Custom duration
- Top/bottom positioning
- No BuildContext needed (uses GetX)

**Usage Examples:**

```dart
// Success toast
CustomToast.show(
  message: 'Sign in successful!',
  type: ToastType.success,
)

// Error toast
CustomToast.show(
  message: 'Something went wrong',
  type: ToastType.error,
)

// Warning with custom duration
CustomToast.show(
  message: 'Please check your input',
  type: ToastType.warning,
  duration: Duration(seconds: 5),
)

// Bottom positioned
CustomToast.show(
  message: 'Message sent',
  type: ToastType.success,
  position: ToastPosition.bottom,
)
```

#### 5. CustomBottomSheet

**Purpose:** Bottom sheet modals

**File:** `lib/shared/widgets/custom_bottom_sheet_widget.dart`

**Key Features:**
- Action items with icons
- Custom content support
- Drag handle
- Smooth animations
- No BuildContext needed (uses GetX)

**Usage Examples:**

```dart
// Basic bottom sheet with actions
CustomBottomSheet.show(
  title: 'Choose Option',
  actions: [
    BottomSheetAction(
      icon: Icons.photo_library,
      label: 'Gallery',
      onTap: () => pickFromGallery(),
    ),
    BottomSheetAction(
      icon: Icons.camera_alt,
      label: 'Camera',
      onTap: () => pickFromCamera(),
    ),
  ],
)

// With subtitle
CustomBottomSheet.show(
  title: 'Upload Photo',
  subtitle: 'Choose how you want to upload',
  actions: [
    BottomSheetAction(
      icon: Icons.photo_library,
      label: 'Gallery',
      subtitle: 'Choose from your photos',
      onTap: () => pickFromGallery(),
    ),
  ],
)

// Danger action
CustomBottomSheet.show(
  title: 'Account',
  actions: [
    BottomSheetAction(
      icon: Icons.edit,
      label: 'Edit Profile',
      onTap: () => editProfile(),
    ),
    BottomSheetAction(
      icon: Icons.logout,
      label: 'Sign Out',
      isDanger: true,
      onTap: () => signOut(),
    ),
  ],
)
```

#### 6. CustomAppBarWidget

**Purpose:** Screen app bars

**File:** `lib/shared/widgets/custom_app_bar_widget.dart`

**Key Features:**
- iOS-style back button
- Centered title
- Custom leading/actions
- All AppBar properties exposed

**Usage Examples:**

```dart
// Basic app bar
CustomAppBarWidget(
  title: 'Home',
)

// With actions
CustomAppBarWidget(
  title: 'Settings',
  actions: [
    IconButton(
      icon: Icon(Icons.search),
      onPressed: () => search(),
    ),
  ],
)

// Custom back action
CustomAppBarWidget(
  title: 'Edit',
  onLeadingPressed: () {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Discard changes?'),
      ),
    );
  },
)

// Without back button
CustomAppBarWidget(
  title: 'Dashboard',
  automaticallyImplyLeading: false,
)
```

#### 7. CustomDividerWidget

**Purpose:** Dividers with optional text

**File:** `lib/shared/widgets/custom_divider_widget.dart`

**Usage Examples:**

```dart
// Simple divider
CustomDividerWidget()

// Divider with text
CustomDividerWidget(text: 'OR')

// Custom styled
CustomDividerWidget(
  text: 'OR',
  lineColor: ColorStyle.border,
  textColor: ColorStyle.textSecondary,
)
```

#### 8. CustomEmptyWidget

**Purpose:** Empty state placeholders

**File:** `lib/shared/widgets/custom_empty_widget.dart`

**Usage Examples:**

```dart
// With image
CustomEmptyWidget(
  image: 'assets/images/empty_inbox.png',
  title: 'No Messages',
  subtitle: 'You have no messages yet',
)

// With icon
CustomEmptyWidget.icon(
  icon: Icons.inbox_outlined,
  title: 'No Items',
  subtitle: 'Your cart is empty',
)

// With action
CustomEmptyWidget(
  image: 'assets/images/no_data.png',
  title: 'No Data Found',
  subtitle: 'Try adjusting your search',
  actionText: 'Refresh',
  onActionPressed: () => refreshData(),
)
```

#### 9. CustomLoadingOverlayWidget

**Purpose:** Full-screen loading overlays

**File:** `lib/shared/widgets/custom_loading_overlay_widget.dart`

**Usage Examples:**

```dart
// Show loading
CustomLoadingOverlayWidget.show(
  message: 'Loading your data...',
)

// Hide loading
CustomLoadingOverlayWidget.hide()

// As widget wrapper
CustomLoadingOverlayWidget.wrap(
  isLoading: controller.isLoading.value,
  message: 'Loading...',
  child: YourContentWidget(),
)
```

#### 10. CustomShimmerWidget

**Purpose:** Loading skeleton screens

**File:** `lib/shared/widgets/custom_shimmer_widget.dart`

**Usage Examples:**

```dart
// Rectangle shimmer
CustomShimmerWidget(
  width: 200.w,
  height: 20.h,
)

// Circle shimmer (avatar)
CustomShimmerWidget(
  width: 60.w,
  height: 60.h,
  shape: ShimmerShape.circle,
)

// Rounded rectangle
CustomShimmerWidget(
  width: double.infinity,
  height: 150.h,
  borderRadius: 16,
)

// List loading
ListView.builder(
  itemCount: 5,
  itemBuilder: (context, index) => Row(
    children: [
      CustomShimmerWidget(
        width: 50.w,
        height: 50.h,
        shape: ShimmerShape.circle,
      ),
      SizedBox(width: 12.w),
      Expanded(
        child: Column(
          children: [
            CustomShimmerWidget(width: double.infinity, height: 16.h),
            SizedBox(height: 8.h),
            CustomShimmerWidget(width: 100.w, height: 12.h),
          ],
        ),
      ),
    ],
  ),
)
```

#### 11. CustomOfflineBannerWidget

**Purpose:** Network connectivity banner

**File:** `lib/shared/widgets/custom_offline_banner_widget.dart`

**Usage Examples:**

```dart
// In GetMaterialApp builder
GetMaterialApp(
  builder: (context, child) {
    return CustomOfflineBannerWidget(
      showRetryButton: true,
      showConnectionType: true,
      child: child ?? SizedBox.shrink(),
    );
  },
)
```

#### 12. AuthHeaderWidget

**Purpose:** Authentication screen headers

**File:** `lib/shared/widgets/auth_header_widget.dart`

**Usage:**

```dart
AuthHeaderWidget(
  title: 'Welcome Back',
  subtitle: 'Sign in to continue',
)
```

#### 13. AuthFooterWidget

**Purpose:** Authentication screen footers

**File:** `lib/shared/widgets/auth_footer_widget.dart`

**Usage:**

```dart
AuthFooterWidget(
  text: "Don't have an account? ",
  actionText: 'Sign Up',
  onActionTap: () => Get.toNamed(Routes.signUpRoute),
)
```

#### 14. PasswordRequirementsWidget

**Purpose:** Password validation indicator

**File:** `lib/shared/widgets/password_requirements_widget.dart`

**Usage:**

```dart
PasswordRequirementsWidget(
  isVisible: controller.isPasswordFocused.value,
  shouldShake: controller.shakePasswordRequirements.value,
  hasMinLength: controller.hasMinLength.value,
  hasLowercase: controller.hasLowercase.value,
  hasUppercase: controller.hasUppercase.value,
  hasNumber: controller.hasNumber.value,
  hasSymbol: controller.hasSymbol.value,
)
```

#### 15. CustomBottomNavigationBarWidget

**Purpose:** Modern bottom navigation bar

**File:** `lib/shared/widgets/custom_bottom_navigation_bar_widget.dart`

**Key Features:**
- Modern, elegant design with smooth transitions
- Support for 1-5 navigation items
- Active/inactive states with customizable colors
- Icon and label support
- Badge support for notifications
- Smooth animation on item selection
- Fixed and shifting types
- Fully customizable appearance

**Usage Examples:**

```dart
// Basic usage with 3 items
CustomBottomNavigationBarWidget(
  currentIndex: 0,
  onTap: (index) => controller.changePage(index),
  items: [
    BottomNavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Home',
    ),
    BottomNavItem(
      icon: Icons.search_outlined,
      activeIcon: Icons.search,
      label: 'Search',
    ),
    BottomNavItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'Profile',
    ),
  ],
)

// With badges and custom colors
CustomBottomNavigationBarWidget(
  currentIndex: controller.currentIndex.value,
  onTap: (index) => controller.changePage(index),
  activeColor: ColorStyle.primary,
  inactiveColor: ColorStyle.textSecondary,
  backgroundColor: ColorStyle.white,
  items: [
    BottomNavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Home',
    ),
    BottomNavItem(
      icon: Icons.notifications_outlined,
      activeIcon: Icons.notifications,
      label: 'Notifications',
      badgeCount: 5,
    ),
    BottomNavItem(
      icon: Icons.message_outlined,
      activeIcon: Icons.message,
      label: 'Messages',
      badgeCount: 12,
    ),
    BottomNavItem(
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings,
      label: 'Settings',
    ),
  ],
)

// Without labels
CustomBottomNavigationBarWidget(
  currentIndex: 0,
  showLabels: false,
  onTap: (index) => handleNavigation(index),
  items: [
    BottomNavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
    ),
    BottomNavItem(
      icon: Icons.explore_outlined,
      activeIcon: Icons.explore,
    ),
    BottomNavItem(
      icon: Icons.favorite_outline,
      activeIcon: Icons.favorite,
    ),
  ],
)

// Shifting type with custom styling
CustomBottomNavigationBarWidget(
  currentIndex: 2,
  type: BottomNavType.shifting,
  height: 70.h,
  elevation: 8,
  borderRadius: 24.r,
  activeColor: ColorStyle.primary,
  inactiveColor: ColorStyle.gray400,
  backgroundColor: ColorStyle.white,
  selectedFontSize: 13.sp,
  unselectedFontSize: 11.sp,
  iconSize: 26.sp,
  onTap: (index) => navigateToPage(index),
  items: [
    BottomNavItem(
      icon: Icons.dashboard_outlined,
      activeIcon: Icons.dashboard,
      label: 'Dashboard',
    ),
    BottomNavItem(
      icon: Icons.analytics_outlined,
      activeIcon: Icons.analytics,
      label: 'Analytics',
    ),
    BottomNavItem(
      icon: Icons.add_circle_outline,
      activeIcon: Icons.add_circle,
      label: 'Add',
    ),
    BottomNavItem(
      icon: Icons.notifications_outlined,
      activeIcon: Icons.notifications,
      label: 'Alerts',
      badgeCount: 3,
    ),
    BottomNavItem(
      icon: Icons.menu,
      activeIcon: Icons.menu_open,
      label: 'Menu',
    ),
  ],
)
```

#### 16. CustomFabBottomAppBarWidget

**Purpose:** Bottom app bar with center-docked FAB

**File:** `lib/shared/widgets/custom_fab_bottom_app_bar_widget.dart`

**Key Features:**
- Center-docked FAB with notch
- Support for 2 or 4 navigation items (split on both sides of FAB)
- Active/inactive states with customizable colors
- Icon and optional label support
- Smooth animations
- Fully customizable appearance
- Perfect for scanner/camera features in center

**Usage Examples:**

```dart
// Basic usage with 4 items (2 left, FAB center, 2 right)
Scaffold(
  floatingActionButton: FloatingActionButton(
    onPressed: () => openScanner(),
    backgroundColor: ColorStyle.primary,
    child: Icon(Icons.qr_code_scanner),
  ),
  floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
  bottomNavigationBar: CustomFabBottomAppBarWidget(
    currentIndex: controller.currentIndex.value,
    onTap: (index) => controller.changePage(index),
    onFabPressed: () => openScanner(),
    items: [
      FabBottomNavItem(
        icon: Icons.home_outlined,
        activeIcon: Icons.home,
      ),
      FabBottomNavItem(
        icon: Icons.favorite_outline,
        activeIcon: Icons.favorite,
      ),
      FabBottomNavItem(
        icon: Icons.person_outline,
        activeIcon: Icons.person,
      ),
      FabBottomNavItem(
        icon: Icons.settings_outlined,
        activeIcon: Icons.settings,
      ),
    ],
  ),
)

// With labels
CustomFabBottomAppBarWidget(
  currentIndex: 0,
  showLabels: true,
  activeColor: ColorStyle.primary,
  inactiveColor: ColorStyle.textSecondary,
  backgroundColor: ColorStyle.white,
  onTap: (index) => handleNavigation(index),
  onFabPressed: () => openCamera(),
  items: [
    FabBottomNavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Home',
    ),
    FabBottomNavItem(
      icon: Icons.search_outlined,
      activeIcon: Icons.search,
      label: 'Search',
    ),
    FabBottomNavItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'Profile',
    ),
    FabBottomNavItem(
      icon: Icons.menu,
      activeIcon: Icons.menu_open,
      label: 'Menu',
    ),
  ],
)
```

---

## Services

### **CRITICAL RULE: ALWAYS USE EXISTING SERVICES**

**NEVER** implement functionality that already exists in services. **ALWAYS** check `lib/utils/services/` first.

### Available Services:

#### 1. LoggerService

**Purpose:** Centralized logging with colored output

**File:** `lib/utils/services/logger_service.dart`

**Features:**
- Multiple log levels (debug, info, warning, error)
- Colored console output
- Tag support
- Data logging
- Error & stack trace logging

**Usage Examples:**

```dart
// Basic logging
LoggerService.debug('This is a debug message');
LoggerService.info('This is an info message');
LoggerService.warning('This is a warning message');
LoggerService.error('This is an error message');

// With tags
LoggerService.debug('User logged in', tag: 'Auth');
LoggerService.error('Failed to fetch data', tag: 'API');

// With data
LoggerService.info('User data', data: {'id': 1, 'name': 'John'});

// Error with stack trace
try {
  // some code
} catch (e, stackTrace) {
  LoggerService.error('Error occurred', error: e, stackTrace: stackTrace);
}

// Short aliases
LoggerService.d('Debug');
LoggerService.i('Info');
LoggerService.w('Warning');
LoggerService.e('Error');
```

#### 2. ConnectivityService

**Purpose:** Network connectivity monitoring

**File:** `lib/utils/services/connectivity_service.dart`

**Features:**
- Real-time connection monitoring
- Internet reachability check
- Connection type detection
- Retry mechanism
- GetX reactive state

**Usage Examples:**

```dart
// Check connection status
final isConnected = ConnectivityService.to.isConnected.value;
if (isConnected) {
  // Proceed with network operation
}

// Listen to changes
ever(ConnectivityService.to.isConnected, (isConnected) {
  if (isConnected) {
    LoggerService.i('Internet connection restored');
  } else {
    LoggerService.w('Internet connection lost');
  }
});

// Check connection type
final connectionType = ConnectivityService.to.connectionType.value;
if (connectionType == ConnectivityResult.wifi) {
  // WiFi connection
} else if (connectionType == ConnectivityResult.mobile) {
  // Mobile data
}

// Wait for connection
await ConnectivityService.to.waitForConnection();

// Check actual internet (with ping)
final hasInternet = await ConnectivityService.to.checkInternetConnection();

// Execute with retry
final data = await ConnectivityService.to.executeWithRetry(
  () => apiService.getData(),
  maxRetries: 3,
);

// Check connection quality
final quality = ConnectivityService.to.getConnectionQuality();
if (quality > 70) {
  // Good connection
}

// Get connection type name
final typeName = ConnectivityService.to.getConnectionTypeName();
// Returns: "WiFi", "Mobile Data", "Ethernet", "No Connection"

// Force refresh
await ConnectivityService.to.refresh();
```

#### 3. PermissionService

**Purpose:** App permissions management

**File:** `lib/utils/services/permission_service.dart`

**Features:**
- Single/multiple permission requests
- Permission status check
- Settings dialog on denial
- Convenience methods for common permissions

**Usage Examples:**

```dart
// Check if granted
final hasCamera = await PermissionService.isGranted(Permission.camera);
if (hasCamera) {
  // Use camera
}

// Request permission
final granted = await PermissionService.request(
  Permission.camera,
  title: 'Camera Permission',
  message: 'We need camera access to take photos',
);

if (granted) {
  // Permission granted
}

// Request multiple permissions
final allGranted = await PermissionService.requestMultiple(
  [Permission.camera, Permission.photos],
  title: 'Media Permissions',
  message: 'We need camera and storage access',
);

// With callbacks
await PermissionService.request(
  Permission.location,
  title: 'Location Permission',
  message: 'We need location to track your drive',
  onGranted: () => LoggerService.i('Location granted'),
  onDenied: () => LoggerService.w('Location denied'),
);

// Convenience methods
await PermissionService.requestCamera();
await PermissionService.requestStorage();
await PermissionService.requestLocation();
await PermissionService.requestNotification();
await PermissionService.requestMediaPermissions(); // Camera + Storage

// Open app settings
await PermissionService.openSettings();

// Get status
final status = await PermissionService.getStatus(Permission.camera);
if (status.isGranted) {
  // Use camera
}
```

#### Other Services:

- **ApiService** - HTTP API calls
- **HiveService** - Local database
- **SupabaseService** - Supabase backend
- **ImageService** - Image handling
- **AppLinkService** - Deep linking
- **FirebaseNotificationService** - Push notifications
- **LocalNotificationService** - Local notifications

**ALWAYS** check these services before implementing similar functionality.

---

## Feature Architecture

### Component-Based Screen Structure

**CRITICAL RULE:** When creating a new feature screen, **ALWAYS** split it into separate components.

### Structure Pattern:

```
features/
└── [feature_name]/
    ├── constants/
    │   ├── [feature]_api_constant.dart
    │   └── [feature]_assets_constant.dart
    ├── models/
    │   └── [feature]_model.dart
    ├── bindings/
    │   └── [feature]_binding.dart
    ├── controllers/
    │   └── [feature]_controller.dart
    ├── repositories/
    │   └── [feature]_repository.dart
    └── screen/
        ├── ui/
        │   └── [feature]_screen.dart  // Main screen (minimal code)
        └── components/
            ├── [feature]_header_component.dart
            ├── [feature]_form_component.dart
            ├── [feature]_action_button_component.dart
            └── [other]_component.dart
```

### Real Example: Sign In Feature

**Screen (UI):** `lib/features/sign_in/screen/ui/sign_in_screen.dart`

```dart
class SignInScreen extends GetView<SignInController> {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Form(
            key: controller.formKey.value,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const AuthHeaderWidget(
                  title: 'Welcome Back',
                  subtitle: 'Sign in to continue',
                ),
                const SignInFormComponent(),
                const SignInActionButtonComponent(),
                AuthFooterWidget(
                  text: "Don't have an account? ",
                  actionText: 'Sign Up',
                  onActionTap: () => Get.toNamed(Routes.signUpRoute),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

**Form Component:** `lib/features/sign_in/screen/components/sign_in_form_component.dart`

```dart
class SignInFormComponent extends GetView<SignInController> {
  const SignInFormComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Email Input Field
        CustomTextFormFieldWidget(
          label: 'Email',
          controller: controller.emailController.value,
          hint: 'Enter your email',
          keyboardType: TextInputType.emailAddress,
          prefixIcon: const Icon(Icons.email_outlined),
          validator: controller.validateEmail,
        ),

        SizedBox(height: 16.h),

        // Password Input Field
        Focus(
          onFocusChange: (hasFocus) {
            controller.isPasswordFocused.value = hasFocus;
          },
          child: CustomTextFormFieldWidget(
            label: 'Password',
            controller: controller.passwordController.value,
            hint: 'Enter your password',
            isPassword: true,
            prefixIcon: const Icon(Icons.lock_outlined),
            validator: controller.validatePassword,
          ),
        ),

        // Password Requirements
        Obx(() => PasswordRequirementsWidget(
              isVisible: controller.isPasswordFocused.value,
              shouldShake: controller.shakePasswordRequirements.value,
              hasMinLength: controller.hasMinLength.value,
              hasLowercase: controller.hasLowercase.value,
              hasUppercase: controller.hasUppercase.value,
              hasNumber: controller.hasNumber.value,
              hasSymbol: controller.hasSymbol.value,
            )),
      ],
    );
  }
}
```

**Action Button Component:** `lib/features/sign_in/screen/components/sign_in_action_button_component.dart`

```dart
class SignInActionButtonComponent extends GetView<SignInController> {
  const SignInActionButtonComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 24.h),

        // Sign In Button
        Obx(() => CustomButtonWidget(
              text: 'Sign In',
              isLoading: controller.isLoading.value,
              onPressed: () => controller.signInWithEmail(),
            )),

        SizedBox(height: 24.h),

        // Divider with "OR"
        const CustomDividerWidget(text: 'OR'),

        SizedBox(height: 24.h),

        // Google Sign In Button
        Obx(() => CustomButtonWidget(
              text: controller.isGoogleLoading.value
                  ? 'Signing in...'
                  : 'Continue with Google',
              isLoading: controller.isGoogleLoading.value,
              backgroundColor: ColorStyle.white,
              textColor: ColorStyle.textPrimary,
              borderColor: ColorStyle.border,
              elevation: 1,
              leadingIcon: controller.isGoogleLoading.value
                  ? null
                  : Image.asset(
                      AssetConstants.iconGoogle,
                      width: 24.w,
                      height: 24.h,
                    ),
              onPressed: () => controller.signInWithGoogle(),
            )),
      ],
    );
  }
}
```

### Benefits of Component-Based Architecture:

1. **Modularity** - Each component has a single responsibility
2. **Reusability** - Components can be reused across screens
3. **Maintainability** - Easy to locate and fix issues
4. **Testability** - Components can be tested independently
5. **Readability** - Main screen file is clean and organized
6. **Scalability** - Easy to add/remove features

### Component Naming Convention:

```dart
[Feature]HeaderComponent       // Header sections
[Feature]FormComponent         // Form inputs
[Feature]ActionButtonComponent // Action buttons
[Feature]AvatarComponent       // Avatar/image sections
[Feature]CardComponent         // Card displays
[Feature]ListComponent         // List displays
```

---

## Code Generation Guidelines

### When Creating a New Feature:

#### Step 1: Analyze Requirements

Before writing code, ask:
1. Does a similar widget exist in `lib/shared/widgets/`?
2. Does a similar service exist in `lib/utils/services/`?
3. What colors from `ColorStyle` should I use?
4. What text styles from `TextStyles` should I use?

#### Step 2: Create Feature Structure

```bash
features/
└── new_feature/
    ├── constants/
    ├── models/
    ├── bindings/
    ├── controllers/
    ├── repositories/
    └── screen/
        ├── ui/
        └── components/
```

#### Step 3: Implement Main Screen (Minimal)

```dart
class NewFeatureScreen extends GetView<NewFeatureController> {
  const NewFeatureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget(
        title: 'Feature Title',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              const NewFeatureHeaderComponent(),
              const NewFeatureFormComponent(),
              const NewFeatureActionButtonComponent(),
            ],
          ),
        ),
      ),
    );
  }
}
```

#### Step 4: Create Components

Split the UI into logical components:

- **HeaderComponent** - Title, subtitle, images
- **FormComponent** - Input fields
- **ActionButtonComponent** - Buttons
- **Other components** - Cards, lists, etc.

#### Step 5: Use Shared Widgets

**ALWAYS** use shared widgets:

```dart
// Use CustomTextFormFieldWidget for inputs
CustomTextFormFieldWidget(
  label: 'Field Label',
  controller: controller.fieldController,
  validator: controller.validateField,
)

// Use CustomButtonWidget for buttons
CustomButtonWidget(
  text: 'Submit',
  isLoading: controller.isLoading.value,
  onPressed: () => controller.submit(),
)

// Use CustomDialogWidget for dialogs
CustomDialogWidget.show(
  type: DialogType.success,
  title: 'Success',
  message: 'Operation completed successfully',
)

// Use CustomToast for notifications
CustomToast.show(
  message: 'Changes saved',
  type: ToastType.success,
)
```

#### Step 6: Apply Styling

**ALWAYS** use `ColorStyle` and `TextStyles`:

```dart
Container(
  color: ColorStyle.background,
  child: Text(
    'Hello',
    style: TextStyles.headlineLarge.copyWith(
      color: ColorStyle.primary,
    ),
  ),
)
```

#### Step 7: Use Services

**ALWAYS** leverage existing services:

```dart
// Logging
LoggerService.info('User action', tag: 'Feature');

// Connectivity
if (ConnectivityService.to.isConnected.value) {
  // Make API call
}

// Permissions
final granted = await PermissionService.requestCamera();
if (granted) {
  // Use camera
}
```

---

## Best Practices

### 1. Responsive Design

**ALWAYS** use `flutter_screenutil` for sizing:

```dart
// Spacing
SizedBox(height: 16.h)  // Vertical spacing
SizedBox(width: 16.w)   // Horizontal spacing

// Padding
EdgeInsets.all(16.r)                          // All sides
EdgeInsets.symmetric(horizontal: 24.w)        // Horizontal
EdgeInsets.symmetric(vertical: 20.h)          // Vertical
EdgeInsets.only(top: 10.h, left: 12.w)       // Specific sides

// Font sizes (already handled by TextStyles)
fontSize: 16.sp  // Only if customizing

// Border radius
BorderRadius.circular(12.r)

// Icon sizes
Icon(Icons.menu, size: 24.sp)
```

### 2. State Management

**ALWAYS** use GetX for state management:

```dart
// Reactive variables
final RxBool isLoading = false.obs;
final RxString username = ''.obs;
final Rx<User?> user = Rx<User?>(null);

// Obx for reactive UI
Obx(() => CustomButtonWidget(
      text: 'Submit',
      isLoading: controller.isLoading.value,
      onPressed: () => controller.submit(),
    ))

// ever for listeners
ever(controller.isLoggedIn, (isLoggedIn) {
  if (isLoggedIn) {
    Get.offAllNamed(Routes.homeRoute);
  }
});
```

### 3. Navigation

**ALWAYS** use GetX navigation:

```dart
// Navigate to named route
Get.toNamed(Routes.homeRoute);

// Navigate with arguments
Get.toNamed(Routes.profileRoute, arguments: userId);

// Replace current route
Get.offNamed(Routes.loginRoute);

// Clear stack and navigate
Get.offAllNamed(Routes.homeRoute);

// Go back
Get.back();

// Go back with result
Get.back(result: {'success': true});
```

### 4. Error Handling

**ALWAYS** use try-catch with logging:

```dart
try {
  await controller.performAction();
  CustomToast.show(
    message: 'Action completed successfully',
    type: ToastType.success,
  );
} catch (e, stackTrace) {
  LoggerService.error(
    'Failed to perform action',
    error: e,
    stackTrace: stackTrace,
    tag: 'Feature',
  );

  CustomDialogWidget.show(
    type: DialogType.error,
    title: 'Error',
    message: 'Something went wrong. Please try again.',
    primaryButtonText: 'OK',
  );
}
```

### 5. Form Validation

**ALWAYS** use Form with validators:

```dart
class FeatureScreen extends GetView<FeatureController> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey.value,
      child: Column(
        children: [
          CustomTextFormFieldWidget(
            label: 'Email',
            controller: controller.emailController,
            validator: controller.validateEmail,
          ),
          CustomButtonWidget(
            text: 'Submit',
            onPressed: () {
              if (controller.formKey.value.currentState?.validate() ?? false) {
                controller.submit();
              }
            },
          ),
        ],
      ),
    );
  }
}
```

### 6. Loading States

**ALWAYS** show loading indicators:

```dart
// Button loading
Obx(() => CustomButtonWidget(
      text: 'Submit',
      isLoading: controller.isLoading.value,
      onPressed: () => controller.submit(),
    ))

// Full screen loading
CustomLoadingOverlayWidget.show(
  message: 'Processing...',
);

// Later hide it
CustomLoadingOverlayWidget.hide();

// Shimmer for list loading
ListView.builder(
  itemCount: controller.isLoading.value ? 5 : items.length,
  itemBuilder: (context, index) {
    if (controller.isLoading.value) {
      return CustomShimmerWidget(
        width: double.infinity,
        height: 80.h,
      );
    }
    return ListItem(item: items[index]);
  },
)
```

### 7. Empty States

**ALWAYS** handle empty states:

```dart
Obx(() {
  if (controller.isLoading.value) {
    return CustomLoadingOverlayWidget(message: 'Loading...');
  }

  if (controller.items.isEmpty) {
    return CustomEmptyWidget.icon(
      icon: Icons.inbox_outlined,
      title: 'No Items',
      subtitle: 'You have no items yet',
      actionText: 'Add Item',
      onActionPressed: () => controller.addItem(),
    );
  }

  return ListView.builder(
    itemCount: controller.items.length,
    itemBuilder: (context, index) => ItemWidget(item: controller.items[index]),
  );
})
```

### 8. Connectivity Handling

**ALWAYS** check connectivity for network operations:

```dart
Future<void> fetchData() async {
  if (!ConnectivityService.to.isConnected.value) {
    CustomToast.show(
      message: 'No internet connection',
      type: ToastType.error,
    );
    return;
  }

  // Execute with retry
  final data = await ConnectivityService.to.executeWithRetry(
    () => apiService.getData(),
    maxRetries: 3,
  );
}
```

### 9. Documentation

**ALWAYS** add comprehensive documentation to new widgets/services:

```dart
/// A fully customizable widget for [purpose].
///
/// This widget provides [key features list].
///
/// ## Features
/// - Feature 1
/// - Feature 2
/// - Feature 3
///
/// ## Usage Examples
///
/// ### Basic usage
/// ```dart
/// MyWidget(
///   property: value,
/// )
/// ```
///
/// ### Advanced usage
/// ```dart
/// MyWidget(
///   property: value,
///   customOption: true,
/// )
/// ```
class MyWidget extends StatelessWidget {
  /// Description of this property
  final String property;

  const MyWidget({
    super.key,
    required this.property,
  });

  @override
  Widget build(BuildContext context) {
    // Implementation
  }
}
```

### 10. Code Organization

**ALWAYS** organize imports:

```dart
// 1. Dart imports
import 'dart:async';
import 'dart:io';

// 2. Flutter imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 3. Package imports
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// 4. Project imports
import 'package:safe_drive/shared/styles/color_style.dart';
import 'package:safe_drive/shared/styles/text_style.dart';
import 'package:safe_drive/shared/widgets/custom_button_widget.dart';
```

---

## Common Mistakes to Avoid

### ❌ DON'T:

```dart
// Don't hardcode colors
Container(color: Color(0xff007bff))

// Don't create TextStyle inline
Text('Hello', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))

// Don't create custom buttons from scratch
Container(
  decoration: BoxDecoration(...),
  child: GestureDetector(
    onTap: () {},
    child: Text('Button'),
  ),
)

// Don't implement loading manually
Container(child: CircularProgressIndicator())

// Don't create dialogs manually
showDialog(
  context: context,
  builder: (context) => AlertDialog(...),
)

// Don't put all UI in one file
class FeatureScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 500+ lines of UI code here
        ],
      ),
    );
  }
}
```

### ✅ DO:

```dart
// Use ColorStyle
Container(color: ColorStyle.primary)

// Use TextStyles
Text('Hello', style: TextStyles.titleMedium)

// Use CustomButtonWidget
CustomButtonWidget(
  text: 'Button',
  onPressed: () {},
)

// Use CustomLoadingOverlayWidget
CustomLoadingOverlayWidget.show(message: 'Loading...')

// Use CustomDialogWidget
CustomDialogWidget.show(
  type: DialogType.success,
  title: 'Success',
  message: 'Operation completed',
)

// Split into components
class FeatureScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const FeatureHeaderComponent(),
          const FeatureFormComponent(),
          const FeatureActionButtonComponent(),
        ],
      ),
    );
  }
}
```

---

## Quick Reference Checklist

Before writing any code, verify:

- [ ] Checked `lib/shared/widgets/` for existing widgets
- [ ] Checked `lib/utils/services/` for existing services
- [ ] Using `ColorStyle` for all colors
- [ ] Using `TextStyles` for all text styling
- [ ] Using `flutter_screenutil` for all sizing (.w, .h, .sp, .r)
- [ ] Splitting screen into components
- [ ] Using GetX for state management
- [ ] Using GetX for navigation
- [ ] Adding proper error handling with logging
- [ ] Checking connectivity before network calls
- [ ] Handling loading states
- [ ] Handling empty states
- [ ] Adding comprehensive documentation
- [ ] Organizing imports properly

---

## Summary

This document ensures that when building the Safe Drive application:

1. **Consistency** - All code follows the same patterns
2. **Maintainability** - Easy to understand and modify
3. **Reusability** - Maximum code reuse through shared components
4. **Quality** - Proper error handling, logging, and user feedback
5. **Performance** - Optimized with best practices
6. **Scalability** - Easy to add new features

**ALWAYS refer to this document when creating new features or modifying existing code.**
