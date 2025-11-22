import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:safe_drive/configs/routes/route.dart';
import 'package:safe_drive/constants/api_constant.dart';
import 'package:safe_drive/shared/repositories/global_repository.dart';
import 'package:safe_drive/utils/services/hive_service.dart';

/// A customizable API service built on Dio for making HTTP requests.
///
/// This service provides a centralized way to handle API calls with features like:
/// - Automatic token management
/// - Request/response interceptors
/// - Network connectivity checks
/// - Automatic token refresh
/// - Error handling
///
/// ## Usage
///
/// ### Initialize the service
/// ```dart
/// await Get.putAsync(() => ApiService().init());
/// ```
///
/// ### Make API requests
/// ```dart
/// // GET request
/// final response = await ApiService.get('/endpoint');
///
/// // POST request
/// final response = await ApiService.post('/endpoint', data: {'key': 'value'});
///
/// // PUT request
/// final response = await ApiService.put('/endpoint', data: {'key': 'value'});
///
/// // DELETE request
/// final response = await ApiService.delete('/endpoint');
/// ```
class ApiService extends GetxService {
  static late Dio _dio;

  /// Get the Dio instance
  static Dio get dio => _dio;

  /// Configuration for API service
  static const Duration _connectTimeout = Duration(seconds: 30);
  static const Duration _receiveTimeout = Duration(seconds: 30);
  static const Duration _sendTimeout = Duration(seconds: 30);

  /// Initialize the API service
  Future<ApiService> init() async {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstant.baseUrl,
      connectTimeout: _connectTimeout,
      receiveTimeout: _receiveTimeout,
      sendTimeout: _sendTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Add interceptors
    _dio.interceptors.add(_createInterceptor());

    // Set bearer token if already logged in
    final bearer = HiveService.getBearer();
    if (bearer != null) {
      setToken(bearer);
    }

    return this;
  }

  /// Create interceptor for request/response/error handling
  static QueuedInterceptor _createInterceptor() {
    return QueuedInterceptorsWrapper(
      onRequest: (options, handler) async {
        // Check internet connection
        final isConnected = await checkInternet();
        if (!isConnected) {
          if (Get.currentRoute == Routes.noConnection) {
            return handler.reject(
              DioException(
                requestOptions: options,
                error: 'No internet connection',
                type: DioExceptionType.connectionError,
              ),
            );
          }

          // Navigate to no connection screen
          Get.toNamed(Routes.noConnection);
          return handler.reject(
            DioException(
              requestOptions: options,
              error: 'No internet connection',
              type: DioExceptionType.connectionError,
            ),
          );
        }

        return handler.next(options);
      },
      onResponse: (response, handler) async {
        return handler.next(response);
      },
      onError: (error, handler) async {
        // Handle token refresh (403)
        if (error.response?.statusCode == 403 &&
            Get.currentRoute != Routes.signInRoute) {
          return _refreshToken(handler, error);
        }

        // Handle unauthorized (401)
        if (error.response?.statusCode == 401) {
          await HiveService.clearHiveLogout();
          return Get.offAllNamed(Routes.signInRoute);
        }

        // Handle connection error
        if (error.type == DioExceptionType.connectionError) {
          return handler.next(
            DioException(
              requestOptions: error.requestOptions,
              error: 'No internet connection',
              message: 'No internet connection',
              type: DioExceptionType.connectionError,
            ),
          );
        }

        return handler.next(error);
      },
    );
  }

  /// Set authorization token
  static void setToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Remove authorization token
  static void removeToken() {
    _dio.options.headers.remove('Authorization');
  }

  /// Refresh token when expired
  static Future<void> _refreshToken(
    ErrorInterceptorHandler handler,
    DioException err,
  ) async {
    try {
      final newToken = await GlobalRepository.refreshToken();
      if (newToken != null) {
        await HiveService.setBearer(newToken);
        setToken(newToken);
        err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
      }

      final opts = Options(
        method: err.requestOptions.method,
        headers: err.requestOptions.headers,
      );

      final cloneReq = await _dio.request(
        err.requestOptions.path,
        options: opts,
        data: err.requestOptions.data,
        queryParameters: err.requestOptions.queryParameters,
      );

      return handler.resolve(cloneReq);
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 422) {
        await HiveService.clearHiveLogout();
        await Get.offAllNamed(Routes.signInRoute);
        return handler.next(err);
      }
    }
  }

  /// Check internet connection
  static Future<bool> checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result.first.rawAddress.isNotEmpty) {
        return true;
      }
      return false;
    } on SocketException catch (_) {
      return false;
    }
  }

  /// GET request
  static Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// POST request
  static Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// PUT request
  static Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// PATCH request
  static Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// DELETE request
  static Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Handle API errors
  static String _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout';
      case DioExceptionType.sendTimeout:
        return 'Send timeout';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout';
      case DioExceptionType.badResponse:
        return _parseErrorResponse(e);
      case DioExceptionType.cancel:
        return 'Request cancelled';
      case DioExceptionType.connectionError:
        return 'No internet connection';
      default:
        return e.message ?? 'Something went wrong';
    }
  }

  /// Parse error response from server
  static String _parseErrorResponse(DioException e) {
    if (e.response?.data != null) {
      final data = e.response?.data;

      // Try to get error message from response
      if (data is Map<String, dynamic>) {
        if (data.containsKey('message')) {
          return data['message'] as String;
        }
        if (data.containsKey('error')) {
          return data['error'] as String;
        }
        if (data.containsKey('errors')) {
          final errors = data['errors'];
          if (errors is List && errors.isNotEmpty) {
            return errors.first.toString();
          }
          if (errors is String) {
            return errors;
          }
        }
      }

      // Return status message if available
      if (e.response?.statusMessage != null) {
        return e.response!.statusMessage!;
      }
    }

    return 'Something went wrong';
  }

  /// API error handler for throwing values (backward compatibility)
  @Deprecated('Use direct API methods instead')
  static dynamic apiErrorHandler(DioException e, {bool useMessage = false}) {
    if (e.response?.data != null) {
      if (useMessage) throw e.message ?? 'Something went wrong';
      throw e.response?.data['errors']?[0] ??
          e.response?.data['errors'] ??
          'Something went wrong';
    }
    throw e.message ?? 'Something went wrong';
  }
}
