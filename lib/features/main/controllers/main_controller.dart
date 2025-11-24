import 'package:get/get.dart';
import 'package:safe_drive/utils/services/logger_service.dart';

/// Controller for main navigation
///
/// Manages the bottom navigation bar state and page navigation
/// between Home, Scanner, and Settings screens.
class MainController extends GetxController {
  static MainController get to => Get.find();

  // Reactive variable for current page index
  final RxInt currentIndex = 0.obs;

  /// Change the current page
  ///
  /// [index] - The index of the page to navigate to (0: Home, 1: Scanner, 2: Settings)
  void changePage(int index) {
    if (index >= 0 && index <= 2) {
      currentIndex.value = index;
      LoggerService.d('Navigated to page: $index', tag: 'MainNavigation');
    }
  }

  @override
  void onInit() {
    super.onInit();
    LoggerService.i('MainController initialized', tag: 'MainNavigation');
  }

  @override
  void onClose() {
    LoggerService.i('MainController closed', tag: 'MainNavigation');
    super.onClose();
  }
}
