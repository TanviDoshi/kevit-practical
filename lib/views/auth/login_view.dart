import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../controllers/login_controller.dart';
import '../../utils/color_constants.dart';
import '../widgets/button_view_widget.dart';
import '../widgets/font_styles.dart';
import '../widgets/progress_view_widget.dart';
import '../widgets/text_field_widget.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(builder: (controller) {
      return Scaffold(
        body: Padding(
          padding: EdgeInsets.all(16.sp),
          child: Stack(
            children: [
              Center(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: SvgPicture.asset(
                          'assets/images/login_vector.svg',
                          width: 250.sp,
                          height: 250.sp,
                        ),
                      ),
                      Text.rich(TextSpan(
                          text: 'Hey there!',
                          style: FontStyles.fontSemiBoldTextStyle(
                              textSize: 30.sp, color: ColorConstants.colorPrimary),
                          children: [
                            TextSpan(
                              text: '\nGlad to see you again. Let’s get social.',
                              style: FontStyles.fontRegularTextStyle(
                                  textSize: 16.sp,
                                  color: ColorConstants.colorTextSecondary),
                            ),
                          ])),
                      SizedBox(height: 10.sp),
                      TextFieldWidget(
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          textEditingController: controller.usernameController,
                          hintText: 'Enter user name',
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(10.sp),
                            child: Icon(
                              Icons.person,
                              color: ColorConstants.colorTextSecondary,
                              size: 25.sp,
                            ),
                          ),
                          error: controller.errorText,
                          onChanged: (value) {
                            controller.isValidateUsername();
                          }),
                      Padding(
                          padding: EdgeInsets.only(top: 50.sp),
                          child: ButtonViewWidget(
                              buttonText: 'Login',
                              buttonWidth: Get.width,
                              onTap: () {
                                if(controller.isValidateUsername()){
                                  controller.login();
                                }
                              })
                      ),

                    ],
                  ),
                ),
              ),
              controller.isLoading ?  Center(child: ProgressViewWidget()) : Container()
            ],
          ),
        ),
      );
    });
  }
}
