import 'package:get/instance_manager.dart';

import '../../controller/number/number_puzzle_list_controller.dart';

class NumberPuzzleListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NumberPuzzleListController>(
      () => NumberPuzzleListController(),
    );
  }
}
