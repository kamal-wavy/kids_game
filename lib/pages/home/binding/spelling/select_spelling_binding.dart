import 'package:get/instance_manager.dart';

import '../../controller/spelling/select_spelling_controller.dart';

class SelectSpellingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SelectSpellingController>(
      () => SelectSpellingController(),
    );
  }
}
