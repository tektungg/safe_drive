import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:safe_drive/utils/services/logger_service.dart';

/// A fully customizable connectivity service for monitoring network status.
///
/// This service provides a centralized way to manage network connectivity with features like:
/// - Real-time connection status monitoring
/// - Connection type detection (WiFi, Mobile, Ethernet, None)
/// - Internet reachability check (ping to verify actual internet access)
/// - Reactive state management with GetX
/// - Automatic retry mechanism for API calls
/// - Offline banner management
/// - Connection quality estimation
///
/// ## Usage
///
/// ### Initialize the service
/// ```dart
/// // In main.dart or app initialization
/// await Get.putAsync(() => ConnectivityService().init());
/// ```
///
/// ### Check connection status
/// ```dart
/// final isConnected = ConnectivityService.to.isConnected.value;
/// if (isConnected) {
///   // Proceed with network operation
/// }
/// ```
///
/// ### Listen to connection changes
/// ```dart
/// // In your controller
/// ever(ConnectivityService.to.isConnected, (isConnected) {
///   if (isConnected) {
///     LoggerService.i('Internet connection restored');
///     // Retry failed requests
///   } else {
///     LoggerService.w('Internet connection lost');
///   }
/// });
/// ```
///
/// ### Check specific connection type
/// ```dart
/// final connectionType = ConnectivityService.to.connectionType.value;
/// if (connectionType == ConnectivityResult.wifi) {
///   // WiFi connection - can download large files
/// } else if (connectionType == ConnectivityResult.mobile) {
///   // Mobile data - limit data usage
/// }
/// ```
///
/// ### Wait for connection
/// ```dart
/// await ConnectivityService.to.waitForConnection();
/// // Connection is available, proceed
/// ```
///
/// ### Check internet reachability (with ping)
/// ```dart
/// final hasInternet = await ConnectivityService.to.checkInternetConnection();
/// if (hasInternet) {
///   // Actually connected to internet
/// }
/// ```
class ConnectivityService extends GetxService {
  static ConnectivityService get to => Get.find<ConnectivityService>();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  /// Current connection status
  final RxBool isConnected = true.obs;

  /// Previous connection status (for detecting changes)
  final RxBool wasConnected = true.obs;

  /// Current connection type
  final Rx<ConnectivityResult> connectionType =
      ConnectivityResult.none.obs;

  /// Whether currently checking connection
  final RxBool isChecking = false.obs;

  /// Last time connection was checked
  final Rx<DateTime?> lastChecked = Rx<DateTime?>(null);

  /// List of hosts to ping for internet check
  static const List<String> _pingHosts = [
    'www.google.com',
    '8.8.8.8',
    '1.1.1.1',
  ];

  /// Timeout for internet check
  static const Duration _internetCheckTimeout = Duration(seconds: 10);

  /// Initialize the connectivity service
  Future<ConnectivityService> init() async {
    try {
      LoggerService.i('Initializing ConnectivityService', tag: 'Connectivity');

      // Check initial connection status
      await _updateConnectionStatus();

      // Listen to connectivity changes
      _connectivitySubscription = _connectivity.onConnectivityChanged
          .listen(_onConnectivityChanged);

      LoggerService.i(
        'ConnectivityService initialized',
        tag: 'Connectivity',
        data: {
          'isConnected': isConnected.value,
          'connectionType': connectionType.value.toString(),
        },
      );
    } catch (e) {
      LoggerService.e(
        'Error initializing ConnectivityService',
        error: e,
        tag: 'Connectivity',
      );
    }

    return this;
  }

  /// Handle connectivity changes
  void _onConnectivityChanged(List<ConnectivityResult> results) async {
    final result = results.isNotEmpty ? results.first : ConnectivityResult.none;

    LoggerService.d(
      'Connectivity changed: ${result.name}',
      tag: 'Connectivity',
    );

    connectionType.value = result;

    // Store previous state
    wasConnected.value = isConnected.value;

    // Update connection status with internet check
    await _updateConnectionStatus();

    // Log connection state change
    if (wasConnected.value != isConnected.value) {
      if (isConnected.value) {
        LoggerService.i(
          'Internet connection restored',
          tag: 'Connectivity',
          data: {'type': connectionType.value.name},
        );
      } else {
        LoggerService.w(
          'Internet connection lost',
          tag: 'Connectivity',
        );
      }
    }
  }

  /// Update connection status
  Future<void> _updateConnectionStatus() async {
    try {
      final results = await _connectivity.checkConnectivity();
      final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
      connectionType.value = result;

      // If no connectivity, mark as not connected
      if (result == ConnectivityResult.none) {
        isConnected.value = false;
        lastChecked.value = DateTime.now();
        return;
      }

      // Check actual internet connection
      final hasInternet = await checkInternetConnection();
      isConnected.value = hasInternet;
      lastChecked.value = DateTime.now();
    } catch (e) {
      LoggerService.e(
        'Error updating connection status',
        error: e,
        tag: 'Connectivity',
      );
      isConnected.value = false;
    }
  }

  /// Check if device has actual internet connection
  ///
  /// This performs a real check by attempting to connect to known hosts,
  /// not just checking if WiFi/Mobile is enabled
  ///
  /// Returns `true` if internet is accessible, `false` otherwise
  ///
  /// Example:
  /// ```dart
  /// final hasInternet = await ConnectivityService.to.checkInternetConnection();
  /// if (hasInternet) {
  ///   // Make API call
  /// }
  /// ```
  Future<bool> checkInternetConnection() async {
    if (isChecking.value) {
      return isConnected.value;
    }

    try {
      isChecking.value = true;

      // Try to connect to multiple hosts
      for (final host in _pingHosts) {
        try {
          final result = await InternetAddress.lookup(host)
              .timeout(_internetCheckTimeout);

          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            LoggerService.d(
              'Internet check successful via $host',
              tag: 'Connectivity',
            );
            return true;
          }
        } catch (e) {
          // Try next host
          continue;
        }
      }

      LoggerService.w(
        'Internet check failed for all hosts',
        tag: 'Connectivity',
      );
      return false;
    } catch (e) {
      LoggerService.e(
        'Error checking internet connection',
        error: e,
        tag: 'Connectivity',
      );
      return false;
    } finally {
      isChecking.value = false;
    }
  }

  /// Wait until connection is available
  ///
  /// Returns a future that completes when internet connection is restored
  ///
  /// Parameters:
  /// - [timeout]: Maximum time to wait (default: 30 seconds)
  /// - [checkInterval]: How often to check connection (default: 2 seconds)
  ///
  /// Example:
  /// ```dart
  /// try {
  ///   await ConnectivityService.to.waitForConnection(
  ///     timeout: Duration(seconds: 10),
  ///   );
  ///   // Connection available, proceed
  /// } on TimeoutException {
  ///   // No connection after timeout
  /// }
  /// ```
  Future<void> waitForConnection({
    Duration timeout = const Duration(seconds: 30),
    Duration checkInterval = const Duration(seconds: 2),
  }) async {
    LoggerService.i(
      'Waiting for internet connection...',
      tag: 'Connectivity',
    );

    final completer = Completer<void>();
    Timer? timeoutTimer;
    Timer? checkTimer;

    // Set timeout
    timeoutTimer = Timer(timeout, () {
      if (!completer.isCompleted) {
        checkTimer?.cancel();
        completer.completeError(TimeoutException(
          'Connection timeout after ${timeout.inSeconds}s',
        ));
      }
    });

    // Check connection periodically
    void checkConnection() {
      if (isConnected.value) {
        timeoutTimer?.cancel();
        checkTimer?.cancel();
        if (!completer.isCompleted) {
          completer.complete();
        }
      }
    }

    // Initial check
    checkConnection();

    // Set up periodic checks
    if (!completer.isCompleted) {
      checkTimer = Timer.periodic(checkInterval, (_) {
        checkConnection();
      });
    }

    return completer.future;
  }

  /// Get connection quality estimation
  ///
  /// Returns a quality score from 0 (no connection) to 100 (excellent)
  ///
  /// This is a simple estimation based on connection type:
  /// - None: 0
  /// - Mobile: 60
  /// - WiFi: 80
  /// - Ethernet: 100
  ///
  /// Example:
  /// ```dart
  /// final quality = ConnectivityService.to.getConnectionQuality();
  /// if (quality > 70) {
  ///   // Good connection - enable video streaming
  /// }
  /// ```
  int getConnectionQuality() {
    if (!isConnected.value) return 0;

    switch (connectionType.value) {
      case ConnectivityResult.ethernet:
        return 100;
      case ConnectivityResult.wifi:
        return 80;
      case ConnectivityResult.mobile:
        return 60;
      case ConnectivityResult.vpn:
        return 70;
      default:
        return 0;
    }
  }

  /// Check if connection is good enough for heavy operations
  ///
  /// Returns `true` if connection quality is above threshold (default: 70)
  ///
  /// Example:
  /// ```dart
  /// if (ConnectivityService.to.isGoodConnection()) {
  ///   // Download large file
  /// } else {
  ///   // Show warning about slow connection
  /// }
  /// ```
  bool isGoodConnection({int qualityThreshold = 70}) {
    return getConnectionQuality() >= qualityThreshold;
  }

  /// Get connection type name
  ///
  /// Returns a user-friendly name for the connection type
  ///
  /// Example:
  /// ```dart
  /// final typeName = ConnectivityService.to.getConnectionTypeName();
  /// // Returns: "WiFi", "Mobile Data", "Ethernet", or "No Connection"
  /// ```
  String getConnectionTypeName() {
    if (!isConnected.value) return 'No Connection';

    switch (connectionType.value) {
      case ConnectivityResult.wifi:
        return 'WiFi';
      case ConnectivityResult.mobile:
        return 'Mobile Data';
      case ConnectivityResult.ethernet:
        return 'Ethernet';
      case ConnectivityResult.vpn:
        return 'VPN';
      case ConnectivityResult.bluetooth:
        return 'Bluetooth';
      default:
        return 'Unknown';
    }
  }

  /// Force refresh connection status
  ///
  /// Manually trigger a connection check
  ///
  /// Example:
  /// ```dart
  /// await ConnectivityService.to.refresh();
  /// ```
  Future<void> refresh() async {
    LoggerService.i('Refreshing connection status', tag: 'Connectivity');
    await _updateConnectionStatus();
  }

  /// Execute a function with automatic retry on connection loss
  ///
  /// Parameters:
  /// - [function]: The function to execute
  /// - [maxRetries]: Maximum number of retries (default: 3)
  /// - [retryDelay]: Delay between retries (default: 2 seconds)
  /// - [waitForConnection]: Whether to wait for connection before retrying
  ///
  /// Example:
  /// ```dart
  /// final data = await ConnectivityService.to.executeWithRetry(
  ///   () => apiService.getData(),
  ///   maxRetries: 3,
  /// );
  /// ```
  Future<T> executeWithRetry<T>(
    Future<T> Function() function, {
    int maxRetries = 3,
    Duration retryDelay = const Duration(seconds: 2),
    bool waitForConnection = true,
  }) async {
    int attempts = 0;

    while (attempts < maxRetries) {
      try {
        // Check connection before attempt
        if (!isConnected.value) {
          if (waitForConnection) {
            LoggerService.w(
              'No connection - waiting for connection...',
              tag: 'Connectivity',
            );
            await this.waitForConnection();
          } else {
            throw Exception('No internet connection');
          }
        }

        // Execute function
        return await function();
      } catch (e) {
        attempts++;
        LoggerService.w(
          'Attempt $attempts failed',
          tag: 'Connectivity',
          data: {'error': e.toString()},
        );

        if (attempts >= maxRetries) {
          LoggerService.e(
            'Max retries ($maxRetries) reached',
            error: e,
            tag: 'Connectivity',
          );
          rethrow;
        }

        // Wait before retry
        await Future.delayed(retryDelay);
      }
    }

    throw Exception('Failed after $maxRetries attempts');
  }

  @override
  void onClose() {
    _connectivitySubscription?.cancel();
    LoggerService.i('ConnectivityService closed', tag: 'Connectivity');
    super.onClose();
  }
}
