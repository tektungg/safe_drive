import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safe_drive/shared/widgets/custom_toast_widget.dart';
import 'package:safe_drive/utils/services/logger_service.dart';
import 'package:safe_drive/utils/services/permission_service.dart';

class ScannerController extends GetxController {
  static ScannerController get to => Get.find();

  // Camera
  Rx<CameraController?> cameraController = Rx<CameraController?>(null);
  RxBool isCameraInitializing = false.obs;
  RxBool isScanning = false.obs;
  RxList<CameraDescription> cameras = <CameraDescription>[].obs;

  // Detection States
  RxString detectionStatus = 'Ready'.obs;
  RxString detectionStatusMessage = 'Position your face in the frame'.obs;
  RxBool isEyesClosed = false.obs;
  RxBool isYawning = false.obs;
  RxInt drowsinessScore = 0.obs;
  RxString alertLevel = 'safe'.obs; // safe, moderate, risky, dangerous

  // Statistics
  RxInt eyeClosedCount = 0.obs;
  RxInt yawnCount = 0.obs;
  RxDouble sessionDuration = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeCamera();
  }

  @override
  void onClose() {
    cameraController.value?.dispose();
    super.onClose();
  }

  /// Initialize camera
  Future<void> _initializeCamera() async {
    try {
      isCameraInitializing.value = true;

      // Check camera permission
      final hasPermission = await PermissionService.requestCamera(
        title: 'Camera Permission Required',
        message: 'Camera permission is required for drowsiness detection',
      );

      if (!hasPermission) {
        LoggerService.error(
          'Camera permission denied',
          tag: 'ScannerController',
        );
        return;
      }

      // Get available cameras
      cameras.value = await availableCameras();
      if (cameras.isEmpty) {
        LoggerService.error('No cameras available', tag: 'ScannerController');
        CustomToast.show(
          message: 'No cameras found on this device',
          type: ToastType.error,
        );
        return;
      }

      // Use front camera for face detection
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      // Initialize camera controller
      final controller = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );

      await controller.initialize();
      cameraController.value = controller;

      LoggerService.info(
        'Camera initialized successfully',
        tag: 'ScannerController',
      );
    } catch (e, stackTrace) {
      LoggerService.error(
        'Failed to initialize camera',
        tag: 'ScannerController',
        error: e,
        stackTrace: stackTrace,
      );
      CustomToast.show(
        message: 'Failed to initialize camera',
        type: ToastType.error,
      );
    } finally {
      isCameraInitializing.value = false;
    }
  }

  /// Start scanning
  Future<void> startScanning() async {
    if (isScanning.value) return;

    try {
      isScanning.value = true;
      detectionStatus.value = 'Scanning...';
      detectionStatusMessage.value = 'Keep your face in view of the camera';

      // Reset statistics
      eyeClosedCount.value = 0;
      yawnCount.value = 0;
      drowsinessScore.value = 0;
      sessionDuration.value = 0.0;
      _updateAlertLevel();

      // TODO: Start ML model detection here
      // This is where you would integrate your ML model for face detection
      // For now, we'll simulate detection

      LoggerService.info('Started scanning', tag: 'ScannerController');
    } catch (e, stackTrace) {
      LoggerService.error(
        'Failed to start scanning',
        tag: 'ScannerController',
        error: e,
        stackTrace: stackTrace,
      );
      CustomToast.show(
        message: 'Failed to start detection',
        type: ToastType.error,
      );
      isScanning.value = false;
    }
  }

  /// Stop scanning
  void stopScanning() {
    if (!isScanning.value) return;

    isScanning.value = false;
    detectionStatus.value = 'Stopped';
    detectionStatusMessage.value = 'Detection paused';

    LoggerService.info('Stopped scanning', tag: 'ScannerController');
  }

  /// Update alert level based on drowsiness score
  void _updateAlertLevel() {
    if (drowsinessScore.value < 25) {
      alertLevel.value = 'safe';
    } else if (drowsinessScore.value < 50) {
      alertLevel.value = 'moderate';
    } else if (drowsinessScore.value < 75) {
      alertLevel.value = 'risky';
    } else {
      alertLevel.value = 'dangerous';
    }
  }

  /// Get alert level color
  Color getAlertLevelColor() {
    switch (alertLevel.value) {
      case 'safe':
        return const Color(0xFF4CAF50);
      case 'moderate':
        return const Color(0xFFFF9800);
      case 'risky':
        return const Color(0xFFFF5722);
      case 'dangerous':
        return const Color(0xFFF44336);
      default:
        return const Color(0xFF4CAF50);
    }
  }

  /// Get alert level text
  String getAlertLevelText() {
    switch (alertLevel.value) {
      case 'safe':
        return 'Safe';
      case 'moderate':
        return 'Moderate';
      case 'risky':
        return 'Risky';
      case 'dangerous':
        return 'Dangerous';
      default:
        return 'Safe';
    }
  }

  /// Retry camera initialization
  Future<void> retryCamera() async {
    await _initializeCamera();
  }
}
