import 'package:flutter/foundation.dart';

/// A fully customizable logger service for the application.
///
/// This service provides a centralized way to handle logging with features like:
/// - Different log levels (debug, info, warning, error)
/// - Colored console output (debug mode)
/// - Customizable log format
/// - Log filtering by level
/// - Optional log persistence
///
/// ## Usage
///
/// ### Basic logging
/// ```dart
/// LoggerService.debug('This is a debug message');
/// LoggerService.info('This is an info message');
/// LoggerService.warning('This is a warning message');
/// LoggerService.error('This is an error message');
/// ```
///
/// ### Logging with tags
/// ```dart
/// LoggerService.debug('User logged in', tag: 'Auth');
/// LoggerService.error('Failed to fetch data', tag: 'API');
/// ```
///
/// ### Logging with data
/// ```dart
/// LoggerService.info('User data', data: {'id': 1, 'name': 'John'});
/// ```
///
/// ### Logging errors with stack trace
/// ```dart
/// try {
///   // some code
/// } catch (e, stackTrace) {
///   LoggerService.error('Error occurred', error: e, stackTrace: stackTrace);
/// }
/// ```
///
/// ### Configure log level
/// ```dart
/// // Only show warnings and errors
/// LoggerService.setLogLevel(LogLevel.warning);
///
/// // Show all logs
/// LoggerService.setLogLevel(LogLevel.debug);
/// ```
class LoggerService {
  static LogLevel _currentLogLevel = LogLevel.debug;

  /// Set the minimum log level to display
  static void setLogLevel(LogLevel level) {
    _currentLogLevel = level;
  }

  /// Get the current log level
  static LogLevel get currentLogLevel => _currentLogLevel;

  /// Log a debug message
  ///
  /// Use this for detailed debugging information
  static void debug(
    String message, {
    String? tag,
    dynamic data,
  }) {
    _log(LogLevel.debug, message, tag: tag, data: data);
  }

  /// Log an info message
  ///
  /// Use this for general informational messages
  static void info(
    String message, {
    String? tag,
    dynamic data,
  }) {
    _log(LogLevel.info, message, tag: tag, data: data);
  }

  /// Log a warning message
  ///
  /// Use this for potentially harmful situations
  static void warning(
    String message, {
    String? tag,
    dynamic data,
  }) {
    _log(LogLevel.warning, message, tag: tag, data: data);
  }

  /// Log an error message
  ///
  /// Use this for error events that might still allow the app to continue
  static void error(
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
    dynamic data,
  }) {
    _log(
      LogLevel.error,
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
      data: data,
    );
  }

  /// Alias for info - for backward compatibility
  static void i(String message, {String? tag, dynamic data}) {
    info(message, tag: tag, data: data);
  }

  /// Alias for debug - for backward compatibility
  static void d(String message, {String? tag, dynamic data}) {
    debug(message, tag: tag, data: data);
  }

  /// Alias for warning - for backward compatibility
  static void w(String message, {String? tag, dynamic data}) {
    warning(message, tag: tag, data: data);
  }

  /// Alias for error - for backward compatibility
  static void e(
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
    dynamic data,
  }) {
    LoggerService.error(
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
      data: data,
    );
  }

  /// Internal logging method
  static void _log(
    LogLevel level,
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
    dynamic data,
  }) {
    // Check if this log level should be displayed
    if (level.index < _currentLogLevel.index) {
      return;
    }

    // Only log in debug mode
    if (!kDebugMode && level != LogLevel.error) {
      return;
    }

    final timestamp = _formatTimestamp(DateTime.now());
    final levelStr = level.toString().split('.').last.toUpperCase();
    final tagStr = tag != null ? '[$tag] ' : '';
    final emoji = _getEmoji(level);

    // Build log message
    final buffer = StringBuffer();
    buffer.write('$emoji $levelStr | $timestamp | $tagStr$message');

    if (data != null) {
      buffer.write('\n📦 Data: $data');
    }

    if (error != null) {
      buffer.write('\n❌ Error: $error');
    }

    if (stackTrace != null) {
      buffer.write('\n📚 Stack Trace:\n$stackTrace');
    }

    // Print with color in debug mode
    if (kDebugMode) {
      _printColored(buffer.toString(), level);
    } else {
      debugPrint(buffer.toString());
    }
  }

  /// Print colored log based on level
  static void _printColored(String message, LogLevel level) {
    const reset = '\x1B[0m';
    String color;

    switch (level) {
      case LogLevel.debug:
        color = '\x1B[37m'; // White
        break;
      case LogLevel.info:
        color = '\x1B[36m'; // Cyan
        break;
      case LogLevel.warning:
        color = '\x1B[33m'; // Yellow
        break;
      case LogLevel.error:
        color = '\x1B[31m'; // Red
        break;
    }

    debugPrint('$color$message$reset');
  }

  /// Format timestamp to be more readable
  ///
  /// Format: HH:mm:ss.SSS (e.g., 15:07:38.222)
  static String _formatTimestamp(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final second = dateTime.second.toString().padLeft(2, '0');
    final millisecond = dateTime.millisecond.toString().padLeft(3, '0');

    return '$hour:$minute:$second.$millisecond';
  }

  /// Get emoji for log level
  static String _getEmoji(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return '🔍';
      case LogLevel.info:
        return 'ℹ️';
      case LogLevel.warning:
        return '⚠️';
      case LogLevel.error:
        return '🚨';
    }
  }

  /// Format a map for logging
  static String formatMap(Map<String, dynamic> map) {
    final buffer = StringBuffer('{');
    map.forEach((key, value) {
      buffer.write('\n  $key: $value,');
    });
    buffer.write('\n}');
    return buffer.toString();
  }

  /// Format a list for logging
  static String formatList(List<dynamic> list) {
    final buffer = StringBuffer('[');
    for (var i = 0; i < list.length; i++) {
      buffer.write('\n  [$i]: ${list[i]},');
    }
    buffer.write('\n]');
    return buffer.toString();
  }
}

/// Log levels for filtering
enum LogLevel {
  /// Detailed debug information
  debug,

  /// General informational messages
  info,

  /// Warning messages for potentially harmful situations
  warning,

  /// Error messages for error events
  error,
}
