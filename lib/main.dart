import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kevit_insta_feed/routes/app_pages.dart';
import 'package:kevit_insta_feed/utils/color_constants.dart';
import 'package:kevit_insta_feed/utils/route_constants.dart';
import 'package:kevit_insta_feed/utils/string_constants.dart';

import 'services/storage_service.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(const Duration(milliseconds: 300));
  await Get.putAsync(() => StorageService().init());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // Make status bar transparent
    statusBarIconBrightness: Brightness.dark, // For Android
    statusBarBrightness: Brightness.light, // For iOS
  ));
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
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
