import 'package:get/instance_manager.dart';

import '../../controller/math/math_grid_controller.dart';

class MathGridBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MathGridController>(
      () => MathGridController(),
    );
  }
}
