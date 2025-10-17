import "dart:async";

import "package:get/get.dart";
import "package:hive_flutter/hive_flutter.dart";
import "package:path_provider/path_provider.dart";
import "package:safe_drive/constants/hive_constant.dart";

class HiveService extends GetxService {
  static late Box generalBox;
  static late Box authBox;

  /// The custom file path for the Hive database.
  ///
  /// If provided, Hive will use this path to store its data files.
  /// If null, the default path will be used.
  final String? costumePath;

  HiveService({this.costumePath});

  Future<HiveService> initHive() async {
    /// Initialize Hive with a custom path or the default application support directory.
    ///
    /// If `costumePath` is provided, it will be used as the path for Hive.
    /// Otherwise, the default path from `getApplicationSupportDirectory` will be used.
    /// To prevent the box file from being visible to the user.
    final path = await getApplicationSupportDirectory();

    await Hive.initFlutter();

    generalBox = await Hive.openBox(
      HiveConstant.generalBox,
      path: costumePath ?? path.path,
      // path: "${costumePath ?? path.path}_${globalFlavor.index}",
    );
    authBox = await Hive.openBox(
      HiveConstant.authBox,
      path: costumePath ?? path.path,
      // path: "${costumePath ?? path.path}_${globalFlavor.index}"
    );
    return this;
  }

  /// Function for set data to the general box.
  void set<T>({required String key, required T data}) =>
      generalBox.put(key, data);

  /// Function for get data from the general box.
  T? get<T>({required String key}) => generalBox.get(key) as T?;

  /* Function save bearer token to local */
  static String? getBearer() => authBox.get(HiveConstant.bearerToken);
  static Future<void> setBearer(String token) async => await authBox.put(
        HiveConstant.bearerToken,
        token,
      );

  /* Remove token auth */
  static Future<void> clearHiveLogout() async {
    await authBox.delete(HiveConstant.bearerToken);
  }
}
