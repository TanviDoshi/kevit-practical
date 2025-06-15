import 'package:get/get_navigation/get_navigation.dart';
import 'package:kevit_insta_feed/bindings/login_binding.dart';
import 'package:kevit_insta_feed/views/auth/login_view.dart';

import '../bindings/feed_view_binding.dart';
import '../utils/route_constants.dart';
import '../views/dashboard/feed_view.dart';

class Pages{
  static final List<GetPage<dynamic>> getPages = [
    GetPage(
        name: RouteConstants.login,
        page: () => LoginView(),
        popGesture: true,
        binding:LoginBinding(),
        showCupertinoParallax: true),

    GetPage(
        name: RouteConstants.feedView,
        page: () => FeedView(),
        popGesture: true,
        binding: FeedViewBinding(),
        showCupertinoParallax: true),


  ];
}