import 'package:get/instance_manager.dart';

import '../../controller/pair/pair_grid_controller.dart';

class PairGridBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PairGridController>(
      () => PairGridController(),
    );
  }
}
