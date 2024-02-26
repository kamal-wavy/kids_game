import 'package:get/instance_manager.dart';

import '../../controller/tictoe/select_tictoe_avtar_controller.dart';

class TicToeSelectAvtarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TicToeSelectAvtarController>(
      () => TicToeSelectAvtarController(),
    );
  }
}
