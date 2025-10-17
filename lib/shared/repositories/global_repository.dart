import 'package:safe_drive/constants/api_constant.dart';
import 'package:safe_drive/utils/services/api_service.dart';
import 'package:vpack/vpack.dart';

class GlobalRepository {
  GlobalRepository._();

  static Future<String?> refreshToken() async {
    try {
      final result = await VenturoApiManager.api.post(ApiConstant.refreshToken);
      return result.data?["data"]?["access_token"];
    } on DioException catch (e) {
      throw ApiService.apiErrorHandler(e);
    }
  }
}
