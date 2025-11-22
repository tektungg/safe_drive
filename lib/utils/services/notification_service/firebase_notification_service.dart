import "dart:async";
import "dart:convert";
import "dart:io";

import "package:firebase_messaging/firebase_messaging.dart";
import "package:get/get.dart";
import 'package:safe_drive/utils/services/logger_service.dart';
import "package:safe_drive/utils/services/notification_service/local_notification_service.dart";

class FirebaseNotificationService extends GetxService {
  static final FirebaseMessaging instance = FirebaseMessaging.instance;

  Future<void> setupFirebase() async {
    try {
      await instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      final token = await instance.getToken();
      LoggerService.i("Device Token $token");
      unawaited(_notificationHandler());
    } catch (e) {
      LoggerService.e("ERROR SETUP FIREBASE", error: e);
    }
  }

  Future<void> _notificationHandler() async {
    /** Handle notification click when app is terminated **/
    await FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        _handlerNotif(message);
      }
    });

    /** Handle notification click on foreground **/
    FirebaseMessaging.onMessage.listen((message) {
      LoggerService.d(jsonEncode(message.notification?.toMap()));
      if (Platform.isAndroid) LocalNotificationService.showNotif(message);
    });

    /** Handle notification click on background **/
    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      _handlerNotif(message);
    });
  }

  void _handlerNotif(RemoteMessage message) async {
    /** Handle Notif Message **/
    final payload = message.data;
    LoggerService.i("PAYLOAD $payload");
  }

  Future<FirebaseNotificationService> init() async {
    await setupFirebase();
    return this;
  }
}
