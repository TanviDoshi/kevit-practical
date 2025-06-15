import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kevit_insta_feed/utils/route_constants.dart';

import 'controllers/check_auth_controller.dart';
import 'routes/app_pages.dart';
import 'services/database_helper.dart';
import 'services/storage_service.dart';
import 'utils/color_constants.dart';
import 'utils/string_constants.dart';
import 'views/widgets/progress_view_widget.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.database;
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
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final CheckAuthController authController = Get.put(CheckAuthController());
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return FutureBuilder(
        future:authController.checkLoginStatus() ,
        builder: (context,snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                    child: ProgressViewWidget()
                ),
              ),
            );
          }
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: Strings.appTitle,
            initialRoute:authController.isLogin.value ? RouteConstants.feedView : RouteConstants.login,
            getPages: Pages.getPages,
            theme: ThemeData(scaffoldBackgroundColor:ColorConstants.colorScreenBackground),
            defaultTransition: Transition.rightToLeft,
          );
        }
    );
  }
}
