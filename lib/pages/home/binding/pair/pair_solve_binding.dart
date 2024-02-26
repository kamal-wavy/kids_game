import 'package:get/instance_manager.dart';

import '../../controller/pair/pair_solve_controller.dart';

class PairSolveBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PairSolveController>(
      () => PairSolveController(),
    );
  }
}
