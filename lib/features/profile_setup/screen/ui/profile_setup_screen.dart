import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:safe_drive/features/profile_setup/controllers/profile_setup_controller.dart';
import 'package:safe_drive/shared/widgets/custom_text_form_field_widget.dart';

class ProfileSetupScreen extends GetView<ProfileSetupController> {
  const ProfileSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Form(
            key: controller.formKey.value,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 40.h),

                // Header
                Text(
                  'Setup Your Profile',
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),
                Text(
                  'Add a photo and your name to personalize your account',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 40.h),

                // Profile Photo
                Center(
                  child: GestureDetector(
                    onTap: controller.showImagePickerOptions,
                    child: Obx(() => Stack(
                          children: [
                            CircleAvatar(
                              radius: 60.r,
                              backgroundColor: Colors.grey[200],
                              backgroundImage: controller.selectedImage.value !=
                                      null
                                  ? FileImage(controller.selectedImage.value!)
                                  : null,
                              child: controller.selectedImage.value == null
                                  ? Icon(
                                      Icons.person,
                                      size: 60.sp,
                                      color: Colors.grey[400],
                                    )
                                  : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.all(8.r),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 20.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                ),

                SizedBox(height: 40.h),

                // Name Input Field
                CustomTextFormFieldWidget(
                  label: 'Full Name',
                  controller: controller.nameController.value,
                  hint: 'Enter your full name',
                  keyboardType: TextInputType.name,
                  prefixIcon: const Icon(Icons.person_outlined),
                  validator: controller.validateName,
                ),

                SizedBox(height: 40.h),

                // Save Button
                Obx(() => ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        elevation: 2,
                      ),
                      child: controller.isLoading.value
                          ? SizedBox(
                              width: 20.w,
                              height: 20.h,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              'Save Profile',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    )),

                SizedBox(height: 16.h),

                // Skip Button
                TextButton(
                  onPressed: controller.skipSetup,
                  child: Text(
                    'Skip for now',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
