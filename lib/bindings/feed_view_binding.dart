import 'package:get/get.dart';

import '../controllers/feed_view_controller.dart';

class FeedViewBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<FeedViewController>(() => FeedViewController());

  }

}