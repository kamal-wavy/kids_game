import 'package:get/instance_manager.dart';

import '../../controller/selectImage/animal_grid_controller.dart';

class AnimalGridBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AnimalGridController>(
      () => AnimalGridController(),
    );
  }
}
