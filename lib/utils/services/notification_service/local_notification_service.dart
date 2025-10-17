import "dart:async";
import "dart:convert";
import "package:firebase_messaging/firebase_messaging.dart";
import "package:flutter_local_notifications/flutter_local_notifications.dart";
import "package:get/get.dart";
import "package:venturo_api_manager/loggers/logger.dart";
import "package:vpack/vpack.dart";

class LocalNotificationService extends GetxService {
  static final localNotif = FlutterLocalNotificationsPlugin();
  bool isInitiated = false;

  static const androidGlobalChannel = AndroidNotificationChannel(
    "safe_drive_channel",
    "SafeDrive",
    importance: Importance.max,
  );

  static NotificationDetails notifDetail(String? body) => NotificationDetails(
        android: AndroidNotificationDetails(
          androidGlobalChannel.id,
          androidGlobalChannel.name,
          priority: Priority.max,
          importance: Importance.max,
          styleInformation: BigTextStyleInformation(body ?? ""),
          visibility: NotificationVisibility.public,
        ),
        iOS: const DarwinNotificationDetails(
          presentSound: true,
          presentAlert: true,
          presentBadge: true,
        ),
      );

  Future<void> initLocalNotif({bool isBackground = false}) async {
    try {
      if (isInitiated) return;

      var androidInitialize =
          const AndroidInitializationSettings("@mipmap/ic_launcher");

      var iosInitialize = const DarwinInitializationSettings();

      if (!isBackground) {
        unawaited(localNotif
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.requestNotificationsPermission());

        unawaited(localNotif
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            ));
      }

      var platformInitialize = InitializationSettings(
        android: androidInitialize,
        iOS: iosInitialize,
      );
      final launchDetails = await localNotif.getNotificationAppLaunchDetails();

      /** If app was launched by tapping a notification, handle it **/
      if (launchDetails?.didNotificationLaunchApp ?? false) {
        final payload = launchDetails!.notificationResponse;
        if (payload != null) {
          handleNotif(payload);
        }
      }

      await localNotif.initialize(
        platformInitialize,
        onDidReceiveNotificationResponse: handleNotif,
      );

      unawaited(localNotif
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(androidGlobalChannel));

      isInitiated = true;
    } catch (e) {
      logger.e("ERROR INIT LOCAL NOTIF: $e");
      isInitiated = false;
    }
  }

  Future<LocalNotificationService> initNotification() async {
    await initLocalNotif();
    return this;
  }

  static void showNotif(RemoteMessage message) {
    localNotif.show(
      message.hashCode,
      message.notification?.title,
      message.notification?.body,
      notifDetail(message.notification?.body),
      payload: jsonEncode(message.data),
    );
  }

  void handleNotif(NotificationResponse response) async {
    /** Handle Notif Message **/
    final payload = jsonDecode(response.payload ?? "");
    logger.i("PAYLOAD $payload");
  }
}
