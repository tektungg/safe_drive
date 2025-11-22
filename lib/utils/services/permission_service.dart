import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safe_drive/shared/widgets/custom_dialog_widget.dart';
import 'package:safe_drive/utils/services/logger_service.dart';

/// A fully customizable permission service for handling app permissions.
///
/// This service provides a centralized way to manage permissions with features like:
/// - Request single or multiple permissions
/// - Check permission status
/// - Handle permission denials with custom dialogs
/// - Open app settings when permission is permanently denied
/// - Comprehensive logging for debugging
///
/// ## Usage
///
/// ### Check if permission is granted
/// ```dart
/// final hasCamera = await PermissionService.isGranted(Permission.camera);
/// if (hasCamera) {
///   // Use camera
/// }
/// ```
///
/// ### Request single permission
/// ```dart
/// final granted = await PermissionService.request(
///   Permission.camera,
///   title: 'Camera Permission',
///   message: 'We need camera access to take photos',
/// );
///
/// if (granted) {
///   // Permission granted, proceed
/// } else {
///   // Permission denied
/// }
/// ```
///
/// ### Request multiple permissions
/// ```dart
/// final allGranted = await PermissionService.requestMultiple(
///   [Permission.camera, Permission.storage],
///   title: 'Media Permissions',
///   message: 'We need camera and storage access',
/// );
///
/// if (allGranted) {
///   // All permissions granted
/// }
/// ```
///
/// ### Request with custom permission denial handling
/// ```dart
/// await PermissionService.request(
///   Permission.location,
///   title: 'Location Permission',
///   message: 'We need location to track your drive',
///   showSettingsDialog: true,
///   onGranted: () {
///     LoggerService.i('Location permission granted');
///   },
///   onDenied: () {
///     LoggerService.w('Location permission denied');
///   },
/// );
/// ```
///
/// ### Open app settings
/// ```dart
/// await PermissionService.openSettings();
/// ```
class PermissionService {
  PermissionService._();

  /// Check if a permission is granted
  ///
  /// Returns `true` if the permission is granted, `false` otherwise
  ///
  /// Example:
  /// ```dart
  /// final hasCamera = await PermissionService.isGranted(Permission.camera);
  /// ```
  static Future<bool> isGranted(Permission permission) async {
    try {
      final status = await permission.status;
      LoggerService.d(
        'Permission check: ${permission.toString().split('.').last} = ${status.isGranted}',
        tag: 'Permission',
      );
      return status.isGranted;
    } catch (e) {
      LoggerService.e(
        'Error checking permission: ${permission.toString().split('.').last}',
        error: e,
        tag: 'Permission',
      );
      return false;
    }
  }

  /// Check if a permission is denied
  ///
  /// Returns `true` if the permission is denied, `false` otherwise
  static Future<bool> isDenied(Permission permission) async {
    try {
      final status = await permission.status;
      return status.isDenied;
    } catch (e) {
      LoggerService.e(
        'Error checking permission denial: ${permission.toString().split('.').last}',
        error: e,
        tag: 'Permission',
      );
      return false;
    }
  }

  /// Check if a permission is permanently denied
  ///
  /// Returns `true` if the permission is permanently denied, `false` otherwise
  static Future<bool> isPermanentlyDenied(Permission permission) async {
    try {
      final status = await permission.status;
      return status.isPermanentlyDenied;
    } catch (e) {
      LoggerService.e(
        'Error checking permanent denial: ${permission.toString().split('.').last}',
        error: e,
        tag: 'Permission',
      );
      return false;
    }
  }

  /// Request a single permission
  ///
  /// Returns `true` if permission is granted, `false` otherwise
  ///
  /// Parameters:
  /// - [permission]: The permission to request
  /// - [title]: Optional dialog title when permission is denied
  /// - [message]: Optional dialog message when permission is denied
  /// - [showSettingsDialog]: Whether to show dialog to open settings if permanently denied
  /// - [onGranted]: Callback when permission is granted
  /// - [onDenied]: Callback when permission is denied
  /// - [onPermanentlyDenied]: Callback when permission is permanently denied
  ///
  /// Example:
  /// ```dart
  /// final granted = await PermissionService.request(
  ///   Permission.camera,
  ///   title: 'Camera Permission',
  ///   message: 'We need camera access to take photos',
  ///   showSettingsDialog: true,
  ///   onGranted: () => LoggerService.i('Camera granted'),
  /// );
  /// ```
  static Future<bool> request(
    Permission permission, {
    String? title,
    String? message,
    bool showSettingsDialog = true,
    VoidCallback? onGranted,
    VoidCallback? onDenied,
    VoidCallback? onPermanentlyDenied,
  }) async {
    try {
      // Check if already granted
      if (await isGranted(permission)) {
        LoggerService.i(
          'Permission already granted: ${permission.toString().split('.').last}',
          tag: 'Permission',
        );
        onGranted?.call();
        return true;
      }

      // Request permission
      final status = await permission.request();

      LoggerService.i(
        'Permission requested: ${permission.toString().split('.').last} = ${status.name}',
        tag: 'Permission',
      );

      if (status.isGranted) {
        onGranted?.call();
        return true;
      } else if (status.isPermanentlyDenied) {
        onPermanentlyDenied?.call();
        if (showSettingsDialog) {
          await _showSettingsDialog(
            title: title ?? 'Permission Required',
            message: message ??
                'This permission is required. Please enable it in settings.',
          );
        }
        return false;
      } else {
        onDenied?.call();
        return false;
      }
    } catch (e) {
      LoggerService.e(
        'Error requesting permission: ${permission.toString().split('.').last}',
        error: e,
        tag: 'Permission',
      );
      return false;
    }
  }

  /// Request multiple permissions
  ///
  /// Returns `true` if ALL permissions are granted, `false` otherwise
  ///
  /// Parameters:
  /// - [permissions]: List of permissions to request
  /// - [title]: Optional dialog title when any permission is denied
  /// - [message]: Optional dialog message when any permission is denied
  /// - [showSettingsDialog]: Whether to show dialog to open settings if any permanently denied
  /// - [requireAll]: If true, requires all permissions. If false, returns true if any granted
  ///
  /// Example:
  /// ```dart
  /// final allGranted = await PermissionService.requestMultiple(
  ///   [Permission.camera, Permission.storage],
  ///   title: 'Media Permissions',
  ///   message: 'We need camera and storage access',
  /// );
  /// ```
  static Future<bool> requestMultiple(
    List<Permission> permissions, {
    String? title,
    String? message,
    bool showSettingsDialog = true,
    bool requireAll = true,
  }) async {
    try {
      LoggerService.i(
        'Requesting ${permissions.length} permissions',
        tag: 'Permission',
      );

      final statuses = await permissions.request();
      final grantedPermissions =
          statuses.values.where((status) => status.isGranted).length;
      final permanentlyDenied =
          statuses.values.any((status) => status.isPermanentlyDenied);

      LoggerService.i(
        'Permissions result: $grantedPermissions/${permissions.length} granted',
        tag: 'Permission',
        data: statuses.map((key, value) =>
            MapEntry(key.toString().split('.').last, value.name)),
      );

      final success = requireAll
          ? grantedPermissions == permissions.length
          : grantedPermissions > 0;

      if (!success && permanentlyDenied && showSettingsDialog) {
        await _showSettingsDialog(
          title: title ?? 'Permissions Required',
          message: message ??
              'Some permissions are required. Please enable them in settings.',
        );
      }

      return success;
    } catch (e) {
      LoggerService.e(
        'Error requesting multiple permissions',
        error: e,
        tag: 'Permission',
      );
      return false;
    }
  }

  /// Get status of a permission
  ///
  /// Returns the current [PermissionStatus] of the permission
  ///
  /// Example:
  /// ```dart
  /// final status = await PermissionService.getStatus(Permission.camera);
  /// if (status.isGranted) {
  ///   // Use camera
  /// }
  /// ```
  static Future<PermissionStatus> getStatus(Permission permission) async {
    try {
      return await permission.status;
    } catch (e) {
      LoggerService.e(
        'Error getting permission status: ${permission.toString().split('.').last}',
        error: e,
        tag: 'Permission',
      );
      return PermissionStatus.denied;
    }
  }

  /// Get status of multiple permissions
  ///
  /// Returns a map of [Permission] to [PermissionStatus]
  ///
  /// Example:
  /// ```dart
  /// final statuses = await PermissionService.getStatuses([
  ///   Permission.camera,
  ///   Permission.storage,
  /// ]);
  /// ```
  static Future<Map<Permission, PermissionStatus>> getStatuses(
    List<Permission> permissions,
  ) async {
    try {
      final Map<Permission, PermissionStatus> statuses = {};
      for (final permission in permissions) {
        statuses[permission] = await permission.status;
      }
      return statuses;
    } catch (e) {
      LoggerService.e(
        'Error getting multiple permission statuses',
        error: e,
        tag: 'Permission',
      );
      return {};
    }
  }

  /// Open app settings
  ///
  /// Returns `true` if settings were opened successfully
  ///
  /// Example:
  /// ```dart
  /// await PermissionService.openSettings();
  /// ```
  static Future<bool> openSettings() async {
    try {
      LoggerService.i('Opening app settings', tag: 'Permission');
      return await openAppSettings();
    } catch (e) {
      LoggerService.e(
        'Error opening app settings',
        error: e,
        tag: 'Permission',
      );
      return false;
    }
  }

  /// Show dialog to open app settings
  static Future<void> _showSettingsDialog({
    required String title,
    required String message,
  }) async {
    await CustomDialogWidget.show(
      type: DialogType.warning,
      title: title,
      message: message,
      primaryButtonText: 'Open Settings',
      secondaryButtonText: 'Cancel',
      onPrimaryPressed: () {
        CustomDialogWidget.close();
        openSettings();
      },
    );
  }

  /// Request camera permission with predefined messages
  ///
  /// Convenience method for camera permission
  static Future<bool> requestCamera({
    String? title,
    String? message,
    VoidCallback? onGranted,
    VoidCallback? onDenied,
  }) async {
    return request(
      Permission.camera,
      title: title ?? 'Camera Permission',
      message: message ?? 'We need camera access to take photos',
      onGranted: onGranted,
      onDenied: onDenied,
    );
  }

  /// Request storage/photos permission with predefined messages
  ///
  /// Convenience method for storage permission
  static Future<bool> requestStorage({
    String? title,
    String? message,
    VoidCallback? onGranted,
    VoidCallback? onDenied,
  }) async {
    return request(
      Permission.photos,
      title: title ?? 'Storage Permission',
      message: message ?? 'We need storage access to access your medias',
      onGranted: onGranted,
      onDenied: onDenied,
    );
  }

  /// Request location permission with predefined messages
  ///
  /// Convenience method for location permission
  static Future<bool> requestLocation({
    String? title,
    String? message,
    VoidCallback? onGranted,
    VoidCallback? onDenied,
  }) async {
    return request(
      Permission.location,
      title: title ?? 'Location Permission',
      message: message ?? 'We need location access to track your drive',
      onGranted: onGranted,
      onDenied: onDenied,
    );
  }

  /// Request notification permission with predefined messages
  ///
  /// Convenience method for notification permission
  static Future<bool> requestNotification({
    String? title,
    String? message,
    VoidCallback? onGranted,
    VoidCallback? onDenied,
  }) async {
    return request(
      Permission.notification,
      title: title ?? 'Notification Permission',
      message: message ?? 'We need notification access to keep you updated',
      onGranted: onGranted,
      onDenied: onDenied,
    );
  }

  /// Request camera and storage permissions together
  ///
  /// Convenience method for media permissions
  static Future<bool> requestMediaPermissions({
    String? title,
    String? message,
  }) async {
    return requestMultiple(
      [Permission.camera, Permission.photos],
      title: title ?? 'Media Permissions',
      message: message ?? 'We need camera and storage access to manage photos',
    );
  }
}
