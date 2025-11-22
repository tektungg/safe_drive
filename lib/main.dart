import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safe_drive/env/env.dart';
import 'package:safe_drive/app.dart';
import 'package:safe_drive/flavors.dart';
import 'package:safe_drive/utils/services/api_service.dart';
import 'package:safe_drive/utils/services/applink_service.dart';
import 'package:safe_drive/utils/services/connectivity_service.dart';
import 'package:safe_drive/utils/services/hive_service.dart';
import 'package:safe_drive/utils/services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  /* Uncomment jika sudah membuat Firebase Options
   await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform); 
  */

  await _initServices();
}

Future<void> _initServices() async {
  log("Env Key ${Env.key}");
  await F.init();

  await Get.putAsync(() => HiveService().initHive());
  await Get.putAsync(() => SupabaseService().init());
  /* Uncomment jika sudah membuat Firebase Options
   await Get.putAsync(() => LocalNotificationService().initNotification());
   await Get.putAsync(() => FirebaseNotificationService().init());
  */
  await Get.putAsync(() => ApplinkService().initApplink());

  // Initialize ConnectivityService before ApiService
  await Get.putAsync(() => ConnectivityService().init());
  await Get.putAsync(() => ApiService().init());

  runApp(const MyApp());
}
