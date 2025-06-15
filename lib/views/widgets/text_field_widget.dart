import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/color_constants.dart';
import 'font_styles.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Function(String? value) onChanged;
  final int maxLines;
  final bool isPassword;
  final int? maxLength;
  final String? error;

  const TextFieldWidget(
      {super.key, required this.textEditingController,
      required this.hintText,
      this.prefixIcon,
      this.keyboardType,
      this.textInputAction,
      required this.onChanged,
      this.maxLines = 1,
      this.isPassword = false,this.maxLength,this.error});

  @override
  Widget build(BuildContext context) {
    return TextField(
        obscureText: isPassword,
        maxLines: maxLines,
        maxLength: maxLength,
        cursorColor: ColorConstants.colorSecondary,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        controller: textEditingController,
        onChanged: (value) {
          onChanged(value);
        },
        style: FontStyles.fontRegularTextStyle(
            textSize: 14.sp, color: ColorConstants.colorTextPrimary),
        decoration: InputDecoration(
          counterText: "",
          prefixIcon: prefixIcon,
          hintText: hintText,
          error: error != null
              ? Text(error!, style: FontStyles.fontRegularTextStyle(
                  textSize: 14.sp, color: ColorConstants.colorTextError))
              : null,
         // errorText: 'Please enter user name',
          errorStyle: FontStyles.fontRegularTextStyle(
              textSize: 14.sp, color: ColorConstants.colorTextError),

          hintStyle: FontStyles.fontRegularTextStyle(
              textSize: 14.sp, color: ColorConstants.colorTextSecondary),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 5.sp, vertical: 16.sp),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: ColorConstants.colorPrimary),// No borderCorner radius
          ),
          enabledBorder:  UnderlineInputBorder(
            borderSide: BorderSide(color: ColorConstants.colorPrimary),// No borderCorner radius
          ),
          focusedBorder:  UnderlineInputBorder(
            borderSide: BorderSide(color: ColorConstants.colorPrimary),// No borderCorner radius
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: ColorConstants.colorTextError),// No borderCorner radius
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: ColorConstants.colorTextError),// No borderCorner radius
          ),
        ));
  }
}
