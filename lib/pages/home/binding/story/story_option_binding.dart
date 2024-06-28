import 'package:get/instance_manager.dart';

import '../../controller/story/story_option_grid_controller.dart';

class StoryOptionGridBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StoryOptionGridController>(
      () => StoryOptionGridController(),
    );
  }
}
