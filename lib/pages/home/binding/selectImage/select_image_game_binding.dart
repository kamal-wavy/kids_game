import 'package:get/instance_manager.dart';

import '../../controller/selectImage/select_image_game_controllr.dart';

class SelectImageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SelectImageController>(
      () => SelectImageController(),
    );
  }
}
