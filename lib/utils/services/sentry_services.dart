import "dart:async";

import "package:flutter/foundation.dart";
import "package:package_info_plus/package_info_plus.dart";
import "package:sentry_flutter/sentry_flutter.dart";
import "package:safe_drive/flavors.dart";
import "package:safe_drive/shared/models/sentry_exclude_model.dart";

class SentryService {
  SentryService._internal();

  /// Singleton instance of [SentryService].
  /// Use [SentryService.instance] to access the singleton instance.
  static final SentryService _instance = SentryService._internal();

  /// Returns the singleton instance of [SentryService].
  /// Use this to access the SentryService methods and properties.
  static SentryService get instance => _instance;

  /// The DSN (Data Source Name) for Sentry.
  /// This is used to configure the Sentry SDK.
  ///
  /// Change your options.dns with your project !!!!
  final String _dsn =
      "https://30fca41e405dfa6b23883af045e4658e@o4505883092975616.ingest.sentry.io/4506539099095040";

  /// Initializes the Sentry configuration with the provided options.
  /// [options] - The SentryFlutterOptions to configure.
  FutureOr<void> initializeConfiguration(SentryFlutterOptions options) async {
    final packageInfo = await PackageInfo.fromPlatform();

    /// Mengatur nama aplikasi, versi, dan nomor build yang akan dikirim ke Sentry.
    options.release =
        '${packageInfo.packageName}@${packageInfo.version}+${packageInfo.buildNumber}';

    /// Mengatur DSN (Data Source Name) untuk Sentry.
    /// Jika kDebugMode true, DSN akan kosong, sehingga tidak mengirim data ke Sentry.
    options.dsn = kDebugMode ? "" : _dsn;

    /// Mengatur environment aplikasi yang akan dikirim ke Sentry.
    options.environment = F.name;

    /// Mengaktifkan fitur lampiran screenshot saat terjadi error.
    /// Jika true, screenshot akan dilampirkan pada laporan error.
    options.attachScreenshot = true;

    /// Menonaktifkan penangkapan permintaan (request) yang gagal.
    /// Jika false, permintaan yang gagal tidak akan dikirim ke Sentry.
    options.captureFailedRequests = false;

    /// Mengatur ukuran maksimum lampiran (attachment) yang dapat dikirim ke Sentry.
    options.maxAttachmentSize = 1024 * 1024 * 2; // 2 MB

    /// Fungsi callback yang dijalankan sebelum transaksi dikirim.
    /// Jika mengembalikan null, transaksi tidak akan dikirim ke Sentry.
    options.beforeSendTransaction = (_) => null;

    /// Mengatur level diagnostik minimum yang akan dicatat.
    /// Hanya log dengan level fatal yang akan dicatat.
    options.diagnosticLevel = SentryLevel.error;

    /// Mengatur persentase sampling untuk pelacakan (tracing) transaksi.
    options.diagnosticLevel = SentryLevel.fatal;

    /// Mengatur persentase sampling untuk profiling performa.
    options.tracesSampleRate = F.selectedFlavor.tracesSampleRate;

    /// Mengaktifkan pelacakan waktu hingga tampilan penuh (Time To Full Display).
    options.profilesSampleRate = F.selectedFlavor.profilesSampleRate;

    /// Fungsi callback yang dijalankan sebelum event dikirim ke Sentry.
    options.enableTimeToFullDisplayTracing =
        F.selectedFlavor.enableTimeToFullDisplayTracing;

    /// Mengatur callback yang dijalankan sebelum event dikirim.
    options.beforeSend = _onBeforeSend;
  }

  /// Callback function that is called before sending a Sentry event.
  /// [event] - The SentryEvent to be sent.
  /// [hint] - Additional information about the event.
  /// This function checks if the event's exception description contains any
  /// of the strings in the [ignoreExceptions] list. If it does, the event is ignored and null is returned.
  FutureOr<SentryEvent?> _onBeforeSend(SentryEvent event, Hint _) {
    for (final ignoreException in ignoreExceptions) {
      var eventException =
          (event.exceptions?.firstOrNull?.value ?? "").toLowerCase();

      if (eventException.contains(ignoreException.title?.toLowerCase() ?? "")) {
        return null;
      }

      if (eventException
          .contains(ignoreException.description?.toLowerCase() ?? "")) {
        return null;
      }
    }
    return event;
  }

  /// Ignore String Exception Descriotion
  ///
  /// This [ignoreExceptions] used for list description extension that
  /// containen event error description
  static List<SentryExcludeModel> get ignoreExceptions {
    return [
      SentryExcludeModel(description: "unable to connect to the server"),
      SentryExcludeModel(description: "socketexception"),
      SentryExcludeModel(description: "timeout"),
      SentryExcludeModel(description: "timeout"),
      SentryExcludeModel(description: "platformexception"),
      SentryExcludeModel(description: "dioerror"),
      SentryExcludeModel(description: "dioexception"),
      SentryExcludeModel(description: "a renderflex overflowed by"),
      SentryExcludeModel(description: "assertion"),
      SentryExcludeModel(description: "firebase_messaging"),
      SentryExcludeModel(description: "CameraException"),
      SentryExcludeModel(description: "No such file or directory"),
      SentryExcludeModel(description: "Error Unknown"),
      SentryExcludeModel(description: "Abort"),
      SentryExcludeModel(description: "SIGABRT"),
      SentryExcludeModel(description: "SIGSEGV"),
      SentryExcludeModel(description: "SIGSEGV"),
      SentryExcludeModel(description: "execvp"),
      SentryExcludeModel(
        title: "TypeError",
        description: "type 'String' is not a subtype of type 'int' of 'index",
      ),
      SentryExcludeModel(description: "Connection refused"),
      SentryExcludeModel(description: "Connection reset"),
      SentryExcludeModel(
        title: "HTTPClientError",
        description: "HTTP Client Error with status code: 500",
      ),
      SentryExcludeModel(
        title: "App Hanging",
        description: "App hanging for at least 2000 ms",
      ),
      SentryExcludeModel(
        title: "App Hanging",
        description: "App hanging for at least 2000 ms",
      ),
      SentryExcludeModel(
        title: "WatchdogTermination",
        description:
            "The OS watchdog terminated your app, possibly because it overused RAM",
      ),
      SentryExcludeModel(
        title: "NSInternalInconsistencyException",
        description: "Unsupported value for standard codec",
      ),
      SentryExcludeModel(
        title: "EXC_BAD_ACCESS",
        description: "Exception 1, Code 1, Subcode 81 >",
      ),
      SentryExcludeModel(
        title: "EXC_BREAKPOINT",
        description:
            "Fatal error > Unexpectedly found nil while unwrapping an Optional value",
      ),
    ];
  }
}
