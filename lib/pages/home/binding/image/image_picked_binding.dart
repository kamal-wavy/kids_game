import 'package:get/instance_manager.dart';

import '../../controller/image/image_picked_solve_controller.dart';

class ImagePickedSolveBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ImagePickedSolveController>(
      () => ImagePickedSolveController(),
    );
  }
}
