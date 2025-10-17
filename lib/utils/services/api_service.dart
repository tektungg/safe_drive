import 'dart:io';
import 'package:get/get.dart';
import 'package:safe_drive/configs/routes/route.dart';
import 'package:safe_drive/constants/api_constant.dart';
import 'package:safe_drive/shared/repositories/global_repository.dart';
import 'package:safe_drive/utils/services/amplitude_services.dart';
import 'package:safe_drive/utils/services/hive_service.dart';
import 'package:vpack/vpack.dart';

class ApiService extends GetxService {
  /* Initialize the API service */
  Future<ApiService> init() async {
    /// Change your base url with your project !!!!
    await VenturoApiManager.initialize(
        baseUrl: ApiConstant.baseUrl,
        config: VenturoApiConfig(
          security: VenturoApiSecurity(
            PRIVATE_KEY: "",
            PUBLIC_KEY: "",
          ),
          configureInterceptor: const VenturoApiInterceptor(
            tokenKey: "Authorization",
          ),
        ),
        interceptors: [_interceptor()]);

    /* Defind bearer token jika sudah login */
    final bearer = HiveService.getBearer();
    if (bearer != null) {
      VenturoApiManager.setToken = bearer;
    }

    return this;
  }

  static QueuedInterceptor _interceptor() {
    return QueuedInterceptorsWrapper(
      onRequest: (options, handler) async {
        /* Check Connection*/
        final isConnected = await checkInternet();
        if (!isConnected) {
          if (Get.currentRoute == Routes.noConnection) return;

          /* Handle direct no internet*/
          Get.toNamed(Routes.noConnection);
          return handler.reject(DioException(requestOptions: options));
        }
        return handler.next(options);
      },
      onResponse: (response, handler) async {
        return handler.next(response);
      },
      onError: (error, handler) async {
        /* Handling Refresh Token */
        if (error.response?.statusCode == 403 &&
            Get.currentRoute != Routes.signInRoute) {
          return refreshToken(handler, error);
        }

        /* Handling token invalid */
        if (error.response?.statusCode == 401) {
          await HiveService.clearHiveLogout();
          await AmplitudeServices.instance.reset();
          return Get.offAllNamed(Routes.signInRoute);
        }

        /* Defind error no connection */
        if (error.type == DioExceptionType.connectionError) {
          return handler.next(
            DioException(
              requestOptions: error.requestOptions,
              error: "Tidak ada internet",
              message: "Tidak ada internet",
            ),
          );
        }

        return handler.next(error);
      },
    );
  }

  /* Refresh Token */
  static Future<void> refreshToken(
    ErrorInterceptorHandler handler,
    DioException err,
  ) async {
    try {
      final res = await GlobalRepository.refreshToken();
      if (res != null) {
        await HiveService.setBearer(res);
        VenturoApiManager.setToken = res;
        err.requestOptions.headers["Authorization"] = "Bearer $res";
      }

      final opts = Options(
        method: err.requestOptions.method,
        headers: err.requestOptions.headers,
      );

      final cloneReq = await VenturoApiManager.instance.dio.request(
        err.requestOptions.path,
        options: opts,
        data: err.requestOptions.data,
        queryParameters: err.requestOptions.queryParameters,
      );
      return handler.resolve(cloneReq);
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 422) {
        await HiveService.clearHiveLogout();
        await AmplitudeServices.instance.reset();
        await Get.offAllNamed(Routes.signInRoute);
        return handler.next(err);
      }
    }
  }

  /* Function check connection */
  static Future<bool> checkInternet() async {
    try {
      var check = await InternetAddress.lookup("google.com");
      if (check.isNotEmpty && check.first.rawAddress.isNotEmpty) {
        return true;
      }
      return false;
    } on SocketException catch (_) {
      return false;
    }
  }

  /* Error API handler for throwing values */
  static dynamic apiErrorHandler(DioException e, {bool useMessage = false}) {
    if (e.response?.data != null) {
      if (useMessage) throw e.message ?? "Terjadi Kesalahan";
      throw e.response?.data["errors"][0] ??
          e.response?.data["errors"] ??
          "Terjadi Kesalahan";
    }
    throw e.message ?? "Terjadi Kesalahan";
  }
}
