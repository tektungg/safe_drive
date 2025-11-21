import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safe_drive/configs/routes/route.dart';
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
      Get.snackbar(
        'Error',
        'Failed to pick image',
        snackPosition: SnackPosition.BOTTOM,
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
      Get.snackbar(
        'Error',
        'Failed to capture image',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Show image picker bottom sheet
  void showImagePickerOptions() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Choose Photo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Get.back();
                pickImageFromGallery();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Get.back();
                pickImageFromCamera();
              },
            ),
          ],
        ),
      ),
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

      logger.i("Profile setup completed");
      Get.snackbar(
        'Success',
        'Profile setup completed!',
        snackPosition: SnackPosition.BOTTOM,
      );

      // Navigate to home screen
      Get.offAllNamed(Routes.homeRoute);
    } catch (e) {
      logger.e("Error saving profile: $e");
      Get.snackbar(
        'Error',
        'Failed to save profile: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Skip profile setup
  void skipSetup() {
    Get.offAllNamed(Routes.homeRoute);
  }
}
