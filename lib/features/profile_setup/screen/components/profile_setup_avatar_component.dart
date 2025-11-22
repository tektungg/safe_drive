import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:safe_drive/features/profile_setup/controllers/profile_setup_controller.dart';
import 'package:safe_drive/shared/styles/color_style.dart';

class ProfileSetupAvatarComponent extends GetView<ProfileSetupController> {
  const ProfileSetupAvatarComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: controller.showImagePickerOptions,
        child: Obx(() => Stack(
              children: [
                CircleAvatar(
                  radius: 60.r,
                  backgroundColor: ColorStyle.gray100,
                  backgroundImage: controller.selectedImage.value != null
                      ? FileImage(controller.selectedImage.value!)
                      : null,
                  child: controller.selectedImage.value == null
                      ? Icon(
                          Icons.person_rounded,
                          size: 60.sp,
                          color: ColorStyle.gray400,
                        )
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                      color: ColorStyle.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: ColorStyle.white,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: ColorStyle.primary.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.camera_alt_rounded,
                      size: 18.sp,
                      color: ColorStyle.white,
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
