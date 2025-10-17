import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:get/get.dart";

class CustomTextEditingWidget extends StatelessWidget {
  final String? label;
  final TextEditingController? controller;
  final String? hint;
  final bool? enabled;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String value)? onChanged;
  final void Function(String value)? onFieldSubmitted;
  final String? Function(String? value)? validator;
  final String? prefixText;
  final EdgeInsets? contentPadding;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool filled;
  final Color? backgroundColor;
  final Color? cursorColor;
  final Color? textColor;
  final TextInputAction? textInputAction;
  final bool isPassword;
  final InputBorder? customBorder;

  const CustomTextEditingWidget({
    super.key,
    this.label,
    this.controller,
    this.hint,
    this.enabled,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
    this.onFieldSubmitted,
    this.validator,
    this.prefixText,
    this.contentPadding,
    this.suffixIcon,
    this.prefixIcon,
    this.filled = false,
    this.backgroundColor,
    this.cursorColor,
    this.textColor,
    this.textInputAction,
    this.isPassword = false,
    this.customBorder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: Get.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
        ],
        TextFormField(
          obscureText: isPassword,
          enabled: enabled,
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmitted,
          validator: validator,
          textInputAction: textInputAction,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: Get.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w400,
            color: textColor,
            fontSize: 10,
          ),
          cursorColor: cursorColor,
          decoration: InputDecoration(
            isDense: true,
            hintText: hint,
            filled: filled,
            fillColor: backgroundColor,
            contentPadding: contentPadding,
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            prefix: prefixText == null
                ? null
                : Container(
                    margin: const EdgeInsets.only(right: 4),
                    child: Text(
                      prefixText!,
                      style: Get.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
            hintStyle: Get.textTheme.bodyMedium?.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
            enabledBorder: customBorder ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(
                    color: Colors.grey,
                  ),
                ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(
                color: Colors.grey,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(
                color: Colors.red,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(
                color: Colors.red,
              ),
            ),
            errorStyle: Get.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 10,
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }
}
