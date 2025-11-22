import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safe_drive/configs/routes/route.dart';
import 'package:safe_drive/shared/widgets/custom_bottom_sheet_widget.dart';
import 'package:safe_drive/shared/widgets/custom_loading_overlay_widget.dart';
import 'package:safe_drive/shared/widgets/custom_toast_widget.dart';
import 'package:safe_drive/utils/helpers/supabase_error_handler.dart';
import 'package:safe_drive/utils/services/image_service.dart';
import 'package:safe_drive/utils/services/logger_service.dart';
import 'package:safe_drive/utils/services/supabase_service.dart';

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

  // Pick image from gallery
  Future<void> pickImageFromGallery() async {
    final file = await ImageService.pickFromGallery(
      cropImage: true,
      imageQuality: 85,
    );

    if (file != null) {
      selectedImage.value = file;
    }
  }

  // Pick image from camera
  Future<void> pickImageFromCamera() async {
    final file = await ImageService.pickFromCamera(
      cropImage: true,
      imageQuality: 85,
      preferredCameraDevice: CameraDevice.front,
    );

    if (file != null) {
      selectedImage.value = file;
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
        final user = _supabaseService.currentUser;
        avatarUrl = await ImageService.uploadToSupabase(
          file: selectedImage.value!,
          bucket: 'avatars',
          userId: user?.id,
        );
      }

      // Update user profile
      await _supabaseService.updateUserProfile(
        name: nameController.value.text.trim(),
        avatarUrl: avatarUrl,
        picture: avatarUrl,
      );

      LoggerService.i("Account created successfully");
      CustomLoadingOverlayWidget.hide();
      CustomToast.show(
        message: 'Account created successfully!',
        type: ToastType.success,
      );

      // Wait for toast to show before navigating
      await Future.delayed(const Duration(milliseconds: 1500));
      Get.offAllNamed(Routes.homeRoute);
    } catch (e) {
      LoggerService.e("Error saving profile", error: e);
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
