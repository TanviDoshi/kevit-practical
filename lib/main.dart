import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kevit_insta_feed/routes/app_pages.dart';
import 'package:kevit_insta_feed/utils/color_constants.dart';
import 'package:kevit_insta_feed/utils/route_constants.dart';
import 'package:kevit_insta_feed/utils/string_constants.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //Get.put(BaseController(),permanent: true);
  await Future.delayed(const Duration(milliseconds: 300));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: Strings.appTitle,
      initialRoute:RouteConstants.login,
      // initialRoute: RouteConstants.dashboard,
      getPages: Pages.getPages,
      theme: ThemeData(scaffoldBackgroundColor:ColorConstants.colorScreenBackground),
      defaultTransition: Transition.rightToLeft,
    );
  }
}
