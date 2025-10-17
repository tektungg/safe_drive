import "package:amplitude_flutter/amplitude.dart";
import "package:amplitude_flutter/configuration.dart";
import "package:amplitude_flutter/events/base_event.dart";
import "package:amplitude_flutter/events/identify.dart";
import "package:get/get.dart";
import "package:sentry_flutter/sentry_flutter.dart";
import "package:safe_drive/flavors.dart";

class AmplitudeServices extends GetxService {
  AmplitudeServices();

  static AmplitudeServices get instance => Get.find();

  late final Amplitude _amplitude;

  Future<AmplitudeServices> init() async {
    _amplitude = Amplitude(
      Configuration(
        instanceName: "name",
        apiKey: "key",
      ),
    );

    // Wait until the SDK is initialized
    await _amplitude.isBuilt;

    return this;
  }

  Future<void> setUserIdentify({String? id}) async {
    // if (UserServices.i.userData.value == null) return;

    final Identify identify = Identify();

    /// To identify the user for sentry
    /// This is used to set the user context in Sentry
    Sentry.configureScope(
      (scope) => scope.setUser(SentryUser(
        id: id,
        // id: UserServices.i.userData.value?.phone,
        // email: UserServices.i.userData.value?.email,
      )),
    );

    identify.setOnce("sign_up_date", DateTime.now().toIso8601String());
    identify.setOnce("phone", id);
    // identify.setOnce("phone", UserServices.i.userData.value?.phone ?? "-");
    identify.set("last_sign_in", DateTime.now().toIso8601String());
    await _amplitude.groupIdentify("flavor", F.selectedFlavor.name, identify);
    await _amplitude.setUserId(id);
    // await _amplitude.setUserId(UserServices.i.userData.value?.phone);
    await _amplitude.identify(identify);
  }

  void logEventCostume({
    required String logName,
    Map<String, dynamic>? eventProperties,
  }) async {
    await _amplitude.track(
      BaseEvent(
        logName,
        eventProperties: {
          ...eventProperties ?? {},
          // "Phone": UserServices.i.userData.value?.phone ?? "-",
        },
      ),
    );

    await _amplitude.flush();
  }

  Future<void> reset() async {
    await _amplitude.reset();

    Sentry.configureScope((scope) => scope.setUser(null));
  }
}
