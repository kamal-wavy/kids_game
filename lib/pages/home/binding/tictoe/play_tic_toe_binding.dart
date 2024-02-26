import 'package:get/instance_manager.dart';

import '../../controller/tictoe/play_tic_toe_controller.dart';

class PlayTicToeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlayTicToeController>(
      () => PlayTicToeController(),
    );
  }
}
