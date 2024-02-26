import 'package:get/instance_manager.dart';

import '../../controller/math/math_quiz_solve_controller.dart';

class MathQuizSolveBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MathQuizSolveController>(
      () => MathQuizSolveController(),
    );
  }
}
