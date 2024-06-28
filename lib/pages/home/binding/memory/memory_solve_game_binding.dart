import 'package:KidsPlan/pages/home/controller/memory/memory_game_controller.dart';
import 'package:get/instance_manager.dart';

class MemorySolveBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MemoryGameSolveController>(
      () => MemoryGameSolveController(),
    );
  }
}
