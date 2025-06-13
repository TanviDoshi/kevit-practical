import 'package:get/get_navigation/get_navigation.dart';
import 'package:kevit_insta_feed/bindings/login_binding.dart';
import 'package:kevit_insta_feed/views/auth/login_view.dart';

import '../utils/route_constants.dart';

class Pages{
  static final List<GetPage<dynamic>> getPages = [
    GetPage(
        name: RouteConstants.login,
        page: () => LoginView(),
        popGesture: true,
        binding:LoginBinding(),
        showCupertinoParallax: true),

  ];
}