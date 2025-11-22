import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safe_drive/shared/styles/color_style.dart';
import 'package:safe_drive/shared/widgets/custom_toast_widget.dart';
import 'package:safe_drive/utils/services/logger_service.dart';
import 'package:safe_drive/utils/services/permission_service.dart';
import 'package:safe_drive/utils/services/supabase_service.dart';

/// A fully customizable image service for handling image operations.
///
/// This service provides a centralized way to manage images with features like:
/// - Pick images from gallery or camera with automatic permission handling
/// - Crop images with customizable aspect ratios and UI
/// - Compress images to reduce file size
/// - Upload images to Supabase Storage
/// - Generate unique file names
/// - Comprehensive error handling and logging
///
/// ## Usage
///
/// ### Pick image from gallery
/// ```dart
/// final file = await ImageService.pickFromGallery();
/// if (file != null) {
///   // Use the picked image
/// }
/// ```
///
/// ### Pick image from camera
/// ```dart
/// final file = await ImageService.pickFromCamera();
/// if (file != null) {
///   // Use the captured image
/// }
/// ```
///
/// ### Pick and crop image
/// ```dart
/// final file = await ImageService.pickFromGallery(
///   cropImage: true,
///   cropAspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
/// );
/// ```
///
/// ### Crop existing image
/// ```dart
/// final croppedFile = await ImageService.cropImage(
///   imagePath: '/path/to/image.jpg',
///   aspectRatio: const CropAspectRatio(ratioX: 16, ratioY: 9),
/// );
/// ```
///
/// ### Upload image to Supabase Storage
/// ```dart
/// final url = await ImageService.uploadToSupabase(
///   file: imageFile,
///   bucket: 'avatars',
///   userId: 'user_123',
/// );
/// if (url != null) {
///   LoggerService.i('Image uploaded: $url');
/// }
/// ```
///
/// ### Complete workflow (pick, crop, upload)
/// ```dart
/// final url = await ImageService.pickCropAndUpload(
///   source: ImageSource.gallery,
///   bucket: 'avatars',
///   userId: 'user_123',
/// );
/// ```
class ImageService {
  ImageService._();

  static final ImagePicker _picker = ImagePicker();
  static final SupabaseService _supabaseService = SupabaseService.instance;

  /// Pick an image from the specified source
  ///
  /// Parameters:
  /// - [source]: The image source (gallery or camera)
  /// - [cropImage]: Whether to crop the image after picking
  /// - [cropAspectRatio]: The aspect ratio for cropping (default: square 1:1)
  /// - [maxWidth]: Maximum width for the picked image
  /// - [maxHeight]: Maximum height for the picked image
  /// - [imageQuality]: Quality of the image (0-100, default: 100)
  /// - [requestPermission]: Whether to request permission automatically (default: true)
  ///
  /// Returns the picked (and optionally cropped) image file, or null if cancelled/failed
  ///
  /// Example:
  /// ```dart
  /// final file = await ImageService.pickImage(
  ///   source: ImageSource.gallery,
  ///   cropImage: true,
  ///   imageQuality: 85,
  /// );
  /// ```
  static Future<File?> pickImage({
    required ImageSource source,
    bool cropImage = false,
    CropAspectRatio cropAspectRatio =
        const CropAspectRatio(ratioX: 1, ratioY: 1),
    double? maxWidth,
    double? maxHeight,
    int imageQuality = 100,
    bool requestPermission = true,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
  }) async {
    try {
      // Request permission if needed
      if (requestPermission) {
        final hasPermission = source == ImageSource.camera
            ? await PermissionService.requestCamera()
            : await PermissionService.requestStorage();

        if (!hasPermission) {
          LoggerService.w(
            'Permission denied for ${source == ImageSource.camera ? 'camera' : 'gallery'}',
            tag: 'ImageService',
          );
          return null;
        }
      }

      LoggerService.i(
        'Picking image from ${source == ImageSource.camera ? 'camera' : 'gallery'}',
        tag: 'ImageService',
      );

      // Pick image
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality,
        preferredCameraDevice: preferredCameraDevice,
      );

      if (image == null) {
        LoggerService.d('Image picking cancelled', tag: 'ImageService');
        return null;
      }

      LoggerService.i(
        'Image picked successfully: ${image.path}',
        tag: 'ImageService',
      );

      // Crop if requested
      if (cropImage) {
        return await cropImageFile(
          imagePath: image.path,
          aspectRatio: cropAspectRatio,
        );
      }

      return File(image.path);
    } catch (e) {
      LoggerService.e(
        'Error picking image from ${source == ImageSource.camera ? 'camera' : 'gallery'}',
        error: e,
        tag: 'ImageService',
      );
      CustomToast.show(
        message: 'Failed to pick image',
        type: ToastType.error,
      );
      return null;
    }
  }

  /// Pick an image from gallery
  ///
  /// Convenience method for picking from gallery
  ///
  /// Example:
  /// ```dart
  /// final file = await ImageService.pickFromGallery(cropImage: true);
  /// ```
  static Future<File?> pickFromGallery({
    bool cropImage = false,
    CropAspectRatio cropAspectRatio =
        const CropAspectRatio(ratioX: 1, ratioY: 1),
    double? maxWidth,
    double? maxHeight,
    int imageQuality = 100,
    bool requestPermission = true,
  }) async {
    return pickImage(
      source: ImageSource.gallery,
      cropImage: cropImage,
      cropAspectRatio: cropAspectRatio,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
      requestPermission: requestPermission,
    );
  }

  /// Pick an image from camera
  ///
  /// Convenience method for picking from camera
  ///
  /// Example:
  /// ```dart
  /// final file = await ImageService.pickFromCamera(
  ///   cropImage: true,
  ///   preferredCameraDevice: CameraDevice.front,
  /// );
  /// ```
  static Future<File?> pickFromCamera({
    bool cropImage = false,
    CropAspectRatio cropAspectRatio =
        const CropAspectRatio(ratioX: 1, ratioY: 1),
    double? maxWidth,
    double? maxHeight,
    int imageQuality = 100,
    bool requestPermission = true,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
  }) async {
    return pickImage(
      source: ImageSource.camera,
      cropImage: cropImage,
      cropAspectRatio: cropAspectRatio,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
      requestPermission: requestPermission,
      preferredCameraDevice: preferredCameraDevice,
    );
  }

  /// Crop an image with the specified aspect ratio
  ///
  /// Parameters:
  /// - [imagePath]: Path to the image file
  /// - [aspectRatio]: The aspect ratio for cropping
  /// - [toolbarTitle]: Title for the crop screen
  /// - [toolbarColor]: Color of the toolbar (Android)
  /// - [toolbarWidgetColor]: Color of toolbar widgets (Android)
  /// - [lockAspectRatio]: Whether to lock the aspect ratio
  ///
  /// Returns the cropped image file, or null if cancelled/failed
  ///
  /// Example:
  /// ```dart
  /// final cropped = await ImageService.cropImage(
  ///   imagePath: '/path/to/image.jpg',
  ///   aspectRatio: const CropAspectRatio(ratioX: 16, ratioY: 9),
  ///   toolbarTitle: 'Crop Photo',
  /// );
  /// ```
  static Future<File?> cropImageFile({
    required String imagePath,
    CropAspectRatio aspectRatio = const CropAspectRatio(ratioX: 1, ratioY: 1),
    String toolbarTitle = 'Crop Photo',
    Color toolbarColor = ColorStyle.primary,
    Color toolbarWidgetColor = ColorStyle.white,
    bool lockAspectRatio = true,
  }) async {
    try {
      LoggerService.i('Cropping image: $imagePath', tag: 'ImageService');

      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imagePath,
        aspectRatio: aspectRatio,
        uiSettings: [
          AndroidUiSettings(
            hideBottomControls: true,
            toolbarTitle: toolbarTitle,
            toolbarColor: toolbarColor,
            toolbarWidgetColor: toolbarWidgetColor,
            initAspectRatio: _getAspectRatioPreset(aspectRatio),
            lockAspectRatio: lockAspectRatio,
          ),
          IOSUiSettings(
            title: toolbarTitle,
            aspectRatioLockEnabled: lockAspectRatio,
            resetAspectRatioEnabled: !lockAspectRatio,
          ),
        ],
      );

      if (croppedFile != null) {
        LoggerService.i(
          'Image cropped successfully: ${croppedFile.path}',
          tag: 'ImageService',
        );
        return File(croppedFile.path);
      }

      LoggerService.d('Image cropping cancelled', tag: 'ImageService');
      return null;
    } catch (e) {
      LoggerService.e('Error cropping image', error: e, tag: 'ImageService');
      CustomToast.show(
        message: 'Failed to crop image',
        type: ToastType.error,
      );
      return null;
    }
  }

  /// Upload an image to Supabase Storage
  ///
  /// Parameters:
  /// - [file]: The image file to upload
  /// - [bucket]: The storage bucket name
  /// - [userId]: Optional user ID to include in filename
  /// - [folder]: Optional folder path within bucket
  /// - [customFileName]: Optional custom file name (without extension)
  /// - [makePublic]: Whether to make the file publicly accessible (default: true)
  ///
  /// Returns the public URL of the uploaded image, or null if failed
  ///
  /// Example:
  /// ```dart
  /// final url = await ImageService.uploadToSupabase(
  ///   file: imageFile,
  ///   bucket: 'avatars',
  ///   userId: 'user_123',
  ///   folder: 'profile_photos',
  /// );
  /// ```
  static Future<String?> uploadToSupabase({
    required File file,
    required String bucket,
    String? userId,
    String? folder,
    String? customFileName,
    bool makePublic = true,
  }) async {
    try {
      LoggerService.i(
        'Uploading image to Supabase bucket: $bucket',
        tag: 'ImageService',
      );

      // Generate file name
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final userPrefix = userId != null ? '${userId}_' : '';
      final fileName = customFileName ?? '$userPrefix$timestamp.jpg';
      final filePath = folder != null ? '$folder/$fileName' : fileName;

      // Read file bytes
      final bytes = await file.readAsBytes();

      LoggerService.d(
        'Uploading file: $filePath ($bytes.length bytes)',
        tag: 'ImageService',
      );

      // Upload to Supabase Storage
      await _supabaseService.client.storage
          .from(bucket)
          .uploadBinary(filePath, bytes);

      // Get public URL
      final imageUrl =
          _supabaseService.client.storage.from(bucket).getPublicUrl(filePath);

      LoggerService.i(
        'Image uploaded successfully',
        tag: 'ImageService',
        data: {'url': imageUrl},
      );

      return imageUrl;
    } catch (e) {
      LoggerService.e(
        'Error uploading image to Supabase',
        error: e,
        tag: 'ImageService',
      );
      CustomToast.show(
        message: 'Failed to upload image',
        type: ToastType.error,
      );
      return null;
    }
  }

  /// Pick, crop, and upload an image in one flow
  ///
  /// Combines picking, cropping, and uploading into a single convenient method
  ///
  /// Parameters:
  /// - [source]: The image source (gallery or camera)
  /// - [bucket]: The storage bucket name
  /// - [userId]: Optional user ID to include in filename
  /// - [folder]: Optional folder path within bucket
  /// - [cropAspectRatio]: The aspect ratio for cropping
  /// - [imageQuality]: Quality of the image (0-100)
  ///
  /// Returns the public URL of the uploaded image, or null if cancelled/failed
  ///
  /// Example:
  /// ```dart
  /// final url = await ImageService.pickCropAndUpload(
  ///   source: ImageSource.gallery,
  ///   bucket: 'avatars',
  ///   userId: user.id,
  /// );
  /// if (url != null) {
  ///   // Update user profile with new avatar URL
  /// }
  /// ```
  static Future<String?> pickCropAndUpload({
    required ImageSource source,
    required String bucket,
    String? userId,
    String? folder,
    CropAspectRatio cropAspectRatio =
        const CropAspectRatio(ratioX: 1, ratioY: 1),
    int imageQuality = 85,
  }) async {
    try {
      // Pick and crop image
      final file = await pickImage(
        source: source,
        cropImage: true,
        cropAspectRatio: cropAspectRatio,
        imageQuality: imageQuality,
      );

      if (file == null) return null;

      // Upload to Supabase
      return await uploadToSupabase(
        file: file,
        bucket: bucket,
        userId: userId,
        folder: folder,
      );
    } catch (e) {
      LoggerService.e(
        'Error in pick, crop, and upload flow',
        error: e,
        tag: 'ImageService',
      );
      return null;
    }
  }

  /// Delete an image from Supabase Storage
  ///
  /// Parameters:
  /// - [bucket]: The storage bucket name
  /// - [filePath]: The file path within the bucket
  ///
  /// Returns true if deletion was successful, false otherwise
  ///
  /// Example:
  /// ```dart
  /// final deleted = await ImageService.deleteFromSupabase(
  ///   bucket: 'avatars',
  ///   filePath: 'profile_photos/user_123_1234567890.jpg',
  /// );
  /// ```
  static Future<bool> deleteFromSupabase({
    required String bucket,
    required String filePath,
  }) async {
    try {
      LoggerService.i(
        'Deleting image from Supabase: $bucket/$filePath',
        tag: 'ImageService',
      );

      await _supabaseService.client.storage.from(bucket).remove([filePath]);

      LoggerService.i('Image deleted successfully', tag: 'ImageService');
      return true;
    } catch (e) {
      LoggerService.e(
        'Error deleting image from Supabase',
        error: e,
        tag: 'ImageService',
      );
      return false;
    }
  }

  /// Get the appropriate aspect ratio preset based on the aspect ratio
  static CropAspectRatioPreset _getAspectRatioPreset(
      CropAspectRatio aspectRatio) {
    if (aspectRatio.ratioX == 1 && aspectRatio.ratioY == 1) {
      return CropAspectRatioPreset.square;
    } else if (aspectRatio.ratioX == 16 && aspectRatio.ratioY == 9) {
      return CropAspectRatioPreset.ratio16x9;
    } else if (aspectRatio.ratioX == 4 && aspectRatio.ratioY == 3) {
      return CropAspectRatioPreset.ratio4x3;
    } else if (aspectRatio.ratioX == 3 && aspectRatio.ratioY == 2) {
      return CropAspectRatioPreset.ratio3x2;
    }
    return CropAspectRatioPreset.original;
  }

  /// Generate a unique file name with optional prefix
  ///
  /// Example:
  /// ```dart
  /// final fileName = ImageService.generateFileName(prefix: 'avatar');
  /// // Returns: avatar_1234567890.jpg
  /// ```
  static String generateFileName({String? prefix, String extension = 'jpg'}) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final prefixPart = prefix != null ? '${prefix}_' : '';
    return '$prefixPart$timestamp.$extension';
  }
}
