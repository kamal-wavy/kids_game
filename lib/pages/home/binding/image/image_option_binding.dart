import 'package:get/instance_manager.dart';
import 'package:KidsPlan/pages/home/controller/image/image_option_controller.dart';

class ImagePuzzleOptionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ImagePuzzleOptionController>(
      () => ImagePuzzleOptionController(),
    );
  }
}
