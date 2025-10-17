import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:safe_drive/shared/styles/google_text_style.dart";

class CustomEmptyWidget extends StatelessWidget {
  final String message;
  final String imagePath;
  final String? secondMesssage;
  final double? height;
  final double? width;
  const CustomEmptyWidget(
      {super.key,
      required this.message,
      required this.imagePath,
      this.secondMesssage,
      this.height,
      this.width});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Image.asset(imagePath, width: width ?? 200, height: height ?? 200),
            const SizedBox(height: 10),
            Text(
              textAlign: TextAlign.center,
              message,
              style: GoogleTextStyle.fw600.copyWith(
                color: Colors.black,
                fontSize: 16.sp,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              secondMesssage ?? "",
              textAlign: TextAlign.center,
              style: GoogleTextStyle.fw400.copyWith(
                color: Colors.black,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
