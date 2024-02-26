import 'package:get/instance_manager.dart';

import '../controller/select_avtar_controllr.dart';

class SelectAvtarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SelectAvtarController>(
      () => SelectAvtarController(),
    );
  }
}
