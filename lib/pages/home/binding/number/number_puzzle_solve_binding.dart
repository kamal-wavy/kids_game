import 'package:get/instance_manager.dart';

import '../../controller/number/number_puzzle_solve_controller.dart';

class NumberPuzzleSolveBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NumberPuzzleSolveController>(
      () => NumberPuzzleSolveController(),
    );
  }
}
