import 'package:get/instance_manager.dart';

import '../../controller/spelling/spelling_grid_controller.dart';

class SpellingGridBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SpellingGridController>(
      () => SpellingGridController(),
    );
  }
}
