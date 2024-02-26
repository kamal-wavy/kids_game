import 'package:get/get_navigation/get_navigation.dart';

import '../pages/home/binding/image/image_option_binding.dart';
import '../pages/home/binding/math/matQuiz_solve_binding.dart';
import '../pages/home/binding/math/math_grid_binding.dart';
import '../pages/home/binding/number/number_puzzle_list_binding.dart';
import '../pages/home/binding/number/number_puzzle_solve_binding.dart';
import '../pages/home/binding/pair/pair_grid_binding.dart';
import '../pages/home/binding/pair/pair_solve_binding.dart';
import '../pages/home/binding/selectImage/animal_grid_binding.dart';
import '../pages/home/binding/selectImage/select_image_game_binding.dart';
import '../pages/home/binding/spelling/spelling_grid_binding.dart';
import '../pages/home/binding/tictoe/select_tictoe_avtar_binding.dart';
import '../pages/home/view/image/puzzle_option.dart';
import '../pages/home/view/math/mathQuiz_solve_screen.dart';
import '../pages/home/view/math/math_grid.dart';
import '../pages/home/view/number/number_puzzle_list_screen.dart';
import '../pages/home/view/number/number_puzzle_solve_screen.dart';
import '../pages/home/view/pair/pair_grid.dart';
import '../pages/home/view/pair/pair_solve_screen.dart';
import '../pages/home/view/selectImage/animal_grid_screen.dart';
import '../pages/home/view/selectImage/select_image_game.dart';
import '../pages/home/view/spelling/spelling_grid_screen.dart';
import '../pages/home/view/tictoe/select_tic_toe_avtar_screen.dart';
import '../pages/initial/binding/select_avtart_binding.dart';
import '../pages/initial/binding/select_game_binding.dart';
import '../pages/initial/binding/splash_binding.dart';
import '../pages/initial/view/change_select_avtar_sreen.dart';
import '../pages/initial/view/select_avtart_screen.dart';
import '../pages/initial/view/select_game_screen.dart';
import '../pages/initial/view/splash_screen.dart';
import 'app_routes.dart';

class AppPages {
  static const INITIAL = AppRoutes.splashScreen;

  static final routes = [
    GetPage(
      name: AppRoutes.splashScreen,
      page: () => SplashScreen(),
      bindings: [SplashBinding()],
    ),
    GetPage(
      name: AppRoutes.selectGameScreen,
      page: () => SelectGameScreen(),
      bindings: [SelectGameBinding()],
    ),
    GetPage(
      name: AppRoutes.animalGridScreen,
      page: () => AnimalGridScreen(),
      bindings: [AnimalGridBinding()],
    ),
    GetPage(
      name: AppRoutes.selectImageScreen,
      page: () => SelectImageScreen(),
      bindings: [SelectImageBinding()],
    ),
    GetPage(
      name: AppRoutes.numberPuzzleListScreen,
      page: () => NumberPuzzleListScreen(),
      bindings: [NumberPuzzleListBinding()],
    ),
    GetPage(
      name: AppRoutes.numberPuzzleSolveScreen,
      page: () => NumberPuzzleSolveScreen(),
      bindings: [NumberPuzzleSolveBinding()],
    ),
    GetPage(
      name: AppRoutes.sellingGridScreen,
      page: () => SpellingGridScreen(),
      bindings: [SpellingGridBinding()],
    ),
    GetPage(
      name: AppRoutes.ticToeSelectAvtarScreen,
      page: () => TicToeSelectAvtarScreen(),
      bindings: [TicToeSelectAvtarBinding()],
    ),
    GetPage(
      name: AppRoutes.imagePuzzleOptionScreen,
      page: () => ImagePuzzleOptionScreen(),
      bindings: [ImagePuzzleOptionBinding()],
    ),
    GetPage(
      name: AppRoutes.selectAvtarScreen,
      page: () => SelectAvtarScreen(),
      bindings: [SelectAvtarBinding()],
    ),
    GetPage(
      name: AppRoutes.mathQuizSolveScreen,
      page: () => MathQuizSolveScreen(),
      bindings: [MathQuizSolveBinding()],
    ),
    GetPage(
      name: AppRoutes.mathGridScreen,
      page: () => MathGridScreen(),
      bindings: [MathGridBinding()],
    ),
    GetPage(
      name: AppRoutes.pairSolveScreen,
      page: () => PairSolveScreen(),
      bindings: [PairSolveBinding()],
    ),
    GetPage(
      name: AppRoutes.pairGridScreen,
      page: () => PairGridScreen(),
      bindings: [PairGridBinding()],
    ),
  ];
}
