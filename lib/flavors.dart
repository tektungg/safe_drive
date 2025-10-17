import "package:flutter/services.dart"
    show MethodChannel, PlatformException, appFlavor;
import "package:vpack/vpack.dart";

// ignore: prefer-match-file-name
class F {
  static Flavor selectedFlavor = Flavor.dev;
  static String get name => selectedFlavor.name;

  F() {
    String? flavor = appFlavor;
    if (flavor != null) {
      selectedFlavor = getFlavor(flavor);
    }
  }

  static Future<void> init() async {
    String? flavor = await _FlavorConfig.getFlavor();

    if (flavor != null) {
      selectedFlavor = getFlavor(flavor);
    }
  }

  static String get title {
    switch (selectedFlavor) {
      case Flavor.dev:
        return 'Safe Drive Dev';
      case Flavor.staging:
        return 'Safe Drive Staging';
      case Flavor.production:
        return 'Safe Drive';
    }
  }
}

class _FlavorConfig {
  static const MethodChannel _channel = MethodChannel("flavor.channel");

  static Future<String?> getFlavor() async {
    try {
      final String? flavor = await _channel.invokeMethod("getFlavor");

      return flavor;
    } on PlatformException catch (e, r) {
      logger.e("Error fetching flavor", error: e, stackTrace: r);
      return null;
    }
  }
}

extension FlavorExt on Flavor {
  bool get isProd => switch (this) {
        Flavor.production => true,
        Flavor.staging => true,
        Flavor.dev => true,
      };

  double get tracesSampleRate => switch (this) {
        Flavor.production => 0.2,
        Flavor.staging => 1.0,
        Flavor.dev => 1.0,
      };

  double get profilesSampleRate => switch (this) {
        Flavor.production => 0.2,
        Flavor.staging => 1.0,
        Flavor.dev => 1.0,
      };

  bool get enableTimeToFullDisplayTracing => switch (this) {
        Flavor.production => false,
        Flavor.staging => true,
        Flavor.dev => true,
      };
}

enum Flavor { dev, staging, production }

Flavor getFlavor(String name) {
  switch (name.toLowerCase()) {
    case "dev":
      return Flavor.dev;
    case "production":
      return Flavor.production;
    case "staging":
      return Flavor.staging;
    default:
      return Flavor.dev;
  }
}
