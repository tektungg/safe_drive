import 'package:dio/dio.dart';
import 'package:safe_drive/constants/api_constant.dart';
import 'package:safe_drive/utils/services/api_service.dart';

class GlobalRepository {
  GlobalRepository._();

  static Future<String?> refreshToken() async {
    try {
      final result = await ApiService.post(ApiConstant.refreshToken);
      return result.data?["data"]?["access_token"];
    } on DioException {
      rethrow;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
