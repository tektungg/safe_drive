import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:safe_drive/features/sign_in/controllers/sign_in_controller.dart';
import 'package:safe_drive/shared/styles/google_text_style.dart';
import 'package:safe_drive/shared/widgets/custom_text_editing_widget.dart';
import 'package:vpack/components/button/v_button.dart';

class SignInScreen extends GetView<SignInController> {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("SignIn"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 150),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Masukan No. Handphone dan password sesuai hint yang diberikan",
                style: GoogleTextStyle.fw400.copyWith(
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Form(
                key: controller.formKeyt.value,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextEditingWidget(
                      label: "No. Handphone",
                      controller: controller.phoneController.value,
                      hint: "Masukan 085736499187",
                      keyboardType: TextInputType.number,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (value) {
                        if (value?.isEmpty ?? false) {
                          return "No. Handphone tidak boleh kosong";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    Obx(
                      () => CustomTextEditingWidget(
                        label: "Password",
                        controller: controller.passwordController.value,
                        hint: "Masukkan password",
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 12,
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        validator: (value) {
                          if (value?.isEmpty ?? false) {
                            return "Password tidak boleh kosong";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 32),
                    VButton(
                      label: "Login",
                      layout: VButtonLayout.FULL,
                      onTap: controller.login,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
