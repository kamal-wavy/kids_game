import 'package:get/instance_manager.dart';

import '../../controller/memory/memory_grid_controller.dart';

class MemoryGridBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MemoryGridController>(
      () => MemoryGridController(),
    );
  }
}
