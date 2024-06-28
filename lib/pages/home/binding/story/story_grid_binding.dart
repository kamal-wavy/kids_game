import 'package:get/instance_manager.dart';

import '../../controller/story/stories_list_controller.dart';

class StoryGridBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StoryListController>(
      () => StoryListController(),
    );
  }
}
