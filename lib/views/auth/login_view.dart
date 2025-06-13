import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kevit_insta_feed/views/widgets/text_view_widget.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/images/login_vector.svg',
                width: 100.sp,
                height: 100.sp,
              ),

              SizedBox(height: 20.h),

              TextViewWidget(
                text: 'Hey there! \nGlad to see you again. Let’s get social!',
              ),
              SizedBox(height: 20.h),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Enter username',
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
