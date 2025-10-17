import "dart:async";
import "package:app_links/app_links.dart";
import "package:get/get.dart";
import "package:venturo_api_manager/loggers/logger.dart";

class ApplinkService extends GetxService {
  final _appLinks = AppLinks();

  Future<ApplinkService> initApplink() async {
    final initialLink = await _appLinks.getInitialLink();
    logger.i("INITIAL LINK: $initialLink");

    if (initialLink != null) {
      unawaited(_handleDeepLink(initialLink));
    }

    // ... check initialLink
    _appLinks.uriLinkStream.listen((Uri? link) {
      // Parse the link and warn the user, if it is not correct
      if (link != null) {
        _handleDeepLink(link);
      }
    }, onError: (err) {
      // Handle exception by warning the user their action did not succeed
      logger.e("Error in deep link stream: $err");
    });

    return this;
  }

  Future<void> _handleDeepLink(Uri deepLink) async {
    /** Handle direct deeplink **/
    logger.i("Handling Deep Link: $deepLink");
  }
}
