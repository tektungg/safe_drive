import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safe_drive/configs/routes/route.dart';
import 'package:safe_drive/shared/widgets/custom_bottom_sheet_widget.dart';
import 'package:safe_drive/shared/widgets/custom_loading_overlay_widget.dart';
import 'package:safe_drive/shared/widgets/custom_toast_widget.dart';
import 'package:safe_drive/utils/helpers/supabase_error_handler.dart';
import 'package:safe_drive/utils/services/supabase_service.dart';
import 'package:venturo_api_manager/loggers/logger.dart';

class ProfileSetupController extends GetxController {
  static ProfileSetupController get to => Get.find();

  final SupabaseService _supabaseService = SupabaseService.instance;

  // Form key
  final Rx<GlobalKey<FormState>> formKey = GlobalKey<FormState>().obs;

  // Text editing controllers
  final Rx<TextEditingController> nameController = TextEditingController().obs;

  // Loading state
  final RxBool isLoading = false.obs;

  // Selected image
  final Rx<File?> selectedImage = Rx<File?>(null);

  // Image picker
  final ImagePicker _picker = ImagePicker();

  @override
  void onClose() {
    nameController.value.dispose();
    super.onClose();
  }

  // Validators
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  // Crop image to 1:1 ratio
  Future<File?> _cropImage(String imagePath) async {
    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imagePath,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            hideBottomControls: true,
            toolbarTitle: 'Crop Photo',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: 'Crop Photo',
            aspectRatioLockEnabled: true,
            resetAspectRatioEnabled: false,
          ),
        ],
      );

      if (croppedFile != null) {
        return File(croppedFile.path);
      }
      return null;
    } catch (e) {
      logger.e("Error cropping image: $e");
      CustomToast.show(
        message: 'Failed to crop image',
        type: ToastType.error,
      );
      return null;
    }
  }

  // Pick image from gallery
  Future<void> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
      );

      if (image != null) {
        final croppedImage = await _cropImage(image.path);
        if (croppedImage != null) {
          selectedImage.value = croppedImage;
        }
      }
    } catch (e) {
      logger.e("Error picking image from gallery: $e");
      CustomToast.show(
        message: 'Failed to pick image from gallery',
        type: ToastType.error,
      );
    }
  }

  // Pick image from camera
  Future<void> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
      );

      if (image != null) {
        final croppedImage = await _cropImage(image.path);
        if (croppedImage != null) {
          selectedImage.value = croppedImage;
        }
      }
    } catch (e) {
      logger.e("Error picking image from camera: $e");
      CustomToast.show(
        message: 'Failed to capture image',
        type: ToastType.error,
      );
    }
  }

  // Show image picker bottom sheet
  void showImagePickerOptions() {
    CustomBottomSheet.show(
      title: 'Choose Photo',
      subtitle: 'Select how you want to add your profile picture',
      actions: [
        BottomSheetAction(
          icon: Icons.photo_library_rounded,
          label: 'Gallery',
          subtitle: 'Choose from your photos',
          onTap: () => pickImageFromGallery(),
        ),
        BottomSheetAction(
          icon: Icons.camera_alt_rounded,
          label: 'Camera',
          subtitle: 'Take a new photo',
          onTap: () => pickImageFromCamera(),
        ),
      ],
    );
  }

  // Upload image to Supabase Storage
  Future<String?> _uploadImage() async {
    if (selectedImage.value == null) return null;

    try {
      final user = _supabaseService.currentUser;
      if (user == null) return null;

      final fileName =
          '${user.id}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final bytes = await selectedImage.value!.readAsBytes();

      await _supabaseService.client.storage
          .from('avatars')
          .uploadBinary(fileName, bytes);

      final imageUrl = _supabaseService.client.storage
          .from('avatars')
          .getPublicUrl(fileName);

      return imageUrl;
    } catch (e) {
      logger.e("Error uploading image: $e");
      return null;
    }
  }

  // Save profile
  Future<void> saveProfile() async {
    if (!formKey.value.currentState!.validate()) {
      return;
    }

    try {
      isLoading.value = true;
      CustomLoadingOverlayWidget.show(message: 'Creating your account...');

      // Upload image if selected
      String? avatarUrl;
      if (selectedImage.value != null) {
        avatarUrl = await _uploadImage();
      }

      // Update user profile
      await _supabaseService.updateUserProfile(
          name: nameController.value.text.trim(),
          avatarUrl: avatarUrl,
          picture: avatarUrl);

      logger.i("Account created successfully");
      CustomLoadingOverlayWidget.hide();
      CustomToast.show(
        message: 'Account created successfully!',
        type: ToastType.success,
      );

      // Wait for toast to show before navigating
      await Future.delayed(const Duration(milliseconds: 1500));
      Get.offAllNamed(Routes.homeRoute);
    } catch (e) {
      logger.e("Error saving profile: $e");
      CustomLoadingOverlayWidget.hide();
      CustomToast.show(
        message: SupabaseErrorHandler.parseError(e),
        type: ToastType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
