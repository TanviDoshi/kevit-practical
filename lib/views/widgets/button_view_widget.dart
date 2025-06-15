import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kevit_insta_feed/views/widgets/text_view_widget.dart';
import '../../utils/color_constants.dart';
import 'font_styles.dart';

class ButtonViewWidget extends StatelessWidget{
  final double buttonWidth;
  final String buttonText;
  final Function() onTap;
  final bool isEnabled;

  const ButtonViewWidget({super.key, required this.buttonText, required this.buttonWidth,required this.onTap,this.isEnabled = true});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: buttonWidth,
        padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 12.sp),
        decoration: BoxDecoration(
          color: isEnabled == true ? ColorConstants.colorSecondary : ColorConstants.colorTextSecondary,
          borderRadius: BorderRadius.circular(12.sp),
          boxShadow: [
            BoxShadow(
              color: Color(0x19000000),
              spreadRadius: 0.sp,
              blurRadius: 13.sp,
              offset: Offset(0, 4.sp),
      )]
        ),
        child: TextViewWidget(text: buttonText, textStyle: FontStyles.fontMediumTextStyle(textSize: 16.sp, color: ColorConstants.colorTextWhite)),
      ),
    );
  }

}