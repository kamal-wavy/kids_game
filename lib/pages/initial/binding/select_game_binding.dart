import 'package:get/instance_manager.dart';

import '../controller/select_game_contoller.dart';

class SelectGameBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SelectGameController>(
      () => SelectGameController(),
    );
  }
}
