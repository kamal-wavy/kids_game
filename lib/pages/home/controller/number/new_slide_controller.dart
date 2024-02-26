import 'dart:async';

import 'package:KidsPlan/sqlite_data/number_game_data/data.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../color.dart';
import '../../../../custom/simpleText.dart';
import '../../../../image.dart';
import '../../../../string.dart';
import '../../view/number/number_puzzle_list_screen.dart';

class NewNumberPuzzleSlideSolveController extends GetxController
    with SingleGetTickerProviderMixin {
  @override
  String? getNumGrid;
  final AudioPlayer audioPlayer = AudioPlayer();
  final DBNumberGame dbStudentManager = new DBNumberGame();
  final blastController = ConfettiController();

  // String audioPath = 'audio/ping.mp3';
  String audioPath = 'audio/click.mp3';
  List<String> containerList = ['1', '2', '3'];
  int? gridSize;
  int? boxLength;
  int moves = 0;
  NumberUserData? userData;
  Timer? timer;
  int secondsElapsed = 0;
  String message = '';

  late List<Color> starColors;
  late List<AnimationController> controllers;
  bool isTimerPaused = false;

  // List<int> puzzleNumbers = List.generate(9, (index) => index + 1);
  List<int> puzzleNumbers = List.generate(9, (index) => index + 1);
  late AnimationController animateController;
  bool isHandlingGesture = false;
  double initialX = 0.0;
  double initialY = 0.0;
  AnimationController? animationControllerBlast;
  int start = 0;
  void playAnimation() {

    animationControllerBlast!.forward(from: 0.0);

  }


  @override
  void onInit() {
    super.onInit();

    getData();
    initializeGame();

    if (timer == null || !timer!.isActive) {
      startGame();
    }
    animateController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1),
    );
    shufflePuzzle();
    // startGame();
    animationControllerBlast = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10), // Adjust the duration as needed
    );
  }
  void startGame() {
    secondsElapsed = 0;

    startTimer();
    update();
  }

  void stopTimer() {
    if (timer != null) {
      timer!.cancel();
    }
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!isTimerPaused) {
        secondsElapsed++;
        update();
      }
    });
  }

  String formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;

    String hoursStr = hours.toString().padLeft(2, '0');
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = remainingSeconds.toString().padLeft(2, '0');

    return '$hoursStr:$minutesStr:$secondsStr';
  }

  void togglePlayPause() {
    isTimerPaused = !isTimerPaused;
    update();

    if (isTimerPaused) {
      timer!.cancel();
      _showResumePopup();
    } else {
      startTimer();
    }
  }

  void shufflePuzzle() {
    puzzleNumbers.shuffle();
    update();
  }

  void _showResumePopup() {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(appPause),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      // height: MediaQuery.of(context).size.height * 0.1,
                      child: CustomSimpleTextField(
                        textAlign: TextAlign.center,
                        hintText: txtGameDonotResume,
                        textSize: 28,
                        hintColor: blackColor,
                        fontfamily: 'summary',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: GestureDetector(
                        onTap: () {
                          playAudio();
                          Get.back();
                          togglePlayPause();
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              appbtn,
                              width: MediaQuery.of(context).size.width * 0.6,
                            ),
                            Center(
                              child: CustomSimpleTextField(
                                textAlign: TextAlign.center,
                                hintText: txtResume,
                                textSize: 32,
                                hintColor: Colors.white,
                                fontfamily: 'summary',
                              ),
                            ),
                          ],
                        )),
                  ),
                  GestureDetector(
                    onTap: () {
                      playAudio();
                      Get.offAll(NumberPuzzleListScreen());
                    },
                    child: CustomSimpleTextField(
                      hintText: txtExit,
                      textSize: 35,
                      hintColor: appRedColor,
                      fontfamily: 'summary',
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }



  void moveNumber(int index, String direction) {
    if (animateController.isAnimating) {
      return;
    }

    int targetIndex = -1;

    switch (direction) {
      case 'up':
        targetIndex = index + 3;
        break;
      case 'down':
        targetIndex = index - 3;
        break;
      case 'left':
        targetIndex = index + 1;
        break;
      case 'right':
        targetIndex = index - 1;
        break;
    }
    switch (direction) {
      case 'up':
        targetIndex = index + gridSize!;
        break;
      case 'down':
        targetIndex = index - gridSize!;
        break;
      case 'left':
        targetIndex = index + 1;
        break;
      case 'right':
        targetIndex = index - 1;
        break;
    }

    if (targetIndex >= 0 &&
        targetIndex < puzzleNumbers.length &&
        puzzleNumbers[targetIndex] == (gridSize! * gridSize!)) {
      moves++;
      update();
      int temp = puzzleNumbers[index];
      puzzleNumbers[index] = puzzleNumbers[targetIndex];
      puzzleNumbers[targetIndex] = temp;
      update();
      animateController.reset();
      animateController.forward();

      // Check if the puzzle is solved after each move
      _checkIfPuzzleSolved();
    }
  }

  // Check if the puzzle is solved
  void _checkIfPuzzleSolved() {
    bool isSolved = true;
    for (int i = 0; i < puzzleNumbers.length - 1; i++) {
      if (puzzleNumbers[i] != i + 1) {
        isSolved = false;
        break;
      }
    }

    if (isSolved) {
      stopTimer();

      starColors = List.generate(5, (index) => Colors.grey);
      controllers = List.generate(5, (index) {
        return AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 500),
        );
      });
      startAnimation();
      submitUser();
      start=1;
      playAnimation();
      dh();
      update();

    }
  }

  void playAudio() async {
    try {
      await audioPlayer.play(AssetSource(audioPath));
      print('Audio playing');
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  getData() {
    if (Get.arguments != null) {
      if (Get.arguments["numGrid"] != null &&
          Get.arguments["boxLength"] != null) {
        getNumGrid = (Get.arguments["numGrid"]);
        boxLength = (Get.arguments["boxLength"]);

        print('rah');
        print(boxLength);
      }
    }
    puzzleNumbers = List.generate(boxLength!, (index) => index + 1);
    gridSize = getNumGrid == '1'
        ? 3
        : getNumGrid == '2'
            ? 4
            : 5;
    update();
  }

  List<int>? numbers;

  void initializeGame() {
    numbers = List.generate(gridSize! * gridSize!, (index) => index);
    numbers!.shuffle();
  }

  void onTilePressed(int tileIndex) {
    int emptyTileIndex = numbers!.indexOf(0);

    if (isAdjacent(tileIndex, emptyTileIndex)) {
      int temp = numbers![tileIndex];
      numbers![tileIndex] = numbers![emptyTileIndex];
      numbers![emptyTileIndex] = temp;
      moves++;
      update();
    }

    // Check if the puzzle is solved
    if (isPuzzleSolved()) {
      stopTimer();

      starColors = List.generate(5, (index) => Colors.grey);
      controllers = List.generate(5, (index) {
        return AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 500),
        );
      });
      startAnimation();
      submitUser();

      start=1;
      playAnimation();
      dh();
      update();
    }
  }

  dh() {
    blastController.play();
    return showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(appPopup),
                Padding(
                  padding: const EdgeInsets.only(top: 70.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      showStar(),
                      Flexible(
                        child: CustomSimpleTextField(
                          hintText: txtGameOver,
                          textSize: 35,
                          hintColor: appRedColor,
                          fontfamily: 'summary',
                        ),
                      ),
                      Flexible(
                        child: CustomSimpleTextField(
                          hintText: 'Moves: ${moves.toString() ?? ""}',
                          textSize: 20,
                          hintColor: appColor,
                          fontfamily: 'Montstreat',
                        ),
                      ),
                      Flexible(
                        child: CustomSimpleTextField(
                          hintText: '$txtGameTime $secondsElapsed seconds',
                          textSize: 20,
                          hintColor: appColor,
                          fontfamily: 'Montstreat',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: GestureDetector(
                          onTap: () {
                            playAudio();
                            blastController.stop();
                            Get.offAll(NumberPuzzleListScreen());
                          },
                          child: Image.asset(appFinish),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  bool isAdjacent(int index1, int index2) {
    int row1 = index1 ~/ gridSize!;
    int col1 = index1 % gridSize!;
    int row2 = index2 ~/ gridSize!;
    int col2 = index2 % gridSize!;

    return (row1 == row2 && (col1 == col2 - 1 || col1 == col2 + 1)) ||
        (col1 == col2 && (row1 == row2 - 1 || row1 == row2 + 1));
  }

  bool isPuzzleSolved() {
    for (int i = 0; i < numbers!.length - 1; i++) {
      if (numbers![i] != i + 1) {
        return false;
      }
    }
    return true;
  }

  startAnimation() async {
    for (int i = 0; i < 5; i++) {
      await Future.delayed(const Duration(milliseconds: 300));
      controllers[i].forward();

      starColors[i] = Colors.amber;
      update();
    }
  }

  List startList = [
    appStarLeft1,
    appStarLeft2,
    appStar1,
    appStarRight1,
    appStarRight2,
  ];

  showStar() {
    if (secondsElapsed <= 300) {
      return Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: SizedBox(
          height: 50,
          width: MediaQuery.of(Get.context!).size.width,
          child: Stack(
            children: [
              // Display gray stars at the bottom
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(startList.length, (index) {
                  return Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Center(
                          child: Image.asset(
                        startList[index],
                        color: greyColor,
                      )));
                }),
              ),
              // Display amber stars with SlideTransition
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(startList.length, (index) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(1, -5.0),
                      end: Offset.zero,
                    ).animate(controllers[index]),
                    child: Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Center(
                            child: Image.asset(
                          startList[index],
                        ))),
                  );
                }),
              ),
            ],
          ),
        ),
      );
    } else if (secondsElapsed <= 500) {
      return Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: SizedBox(
          height: 50,
          width: MediaQuery.of(Get.context!).size.width,
          child: Stack(
            children: [
              // Display gray stars at the bottom
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(startList.length, (index) {
                  return Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Center(
                          child: Image.asset(
                        startList[index],
                        color: greyColor,
                      )));
                }),
              ),
              // Display amber stars with SlideTransition
              Padding(
                padding: const EdgeInsets.only(right: 33.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(startList.length - 1, (index) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1, -5.0),
                        end: Offset.zero,
                      ).animate(controllers[index]),
                      child: Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Center(child: Image.asset(startList[index])),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      );
    } else if (secondsElapsed <= 720) {
      return Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: SizedBox(
          height: 50,
          width: MediaQuery.of(Get.context!).size.width,
          child: Stack(
            children: [
              // Display gray stars at the bottom
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(startList.length, (index) {
                  return Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Center(
                          child: Image.asset(
                        startList[index],
                        color: greyColor,
                      )));
                }),
              ),
              // Display amber stars with SlideTransition
              Padding(
                  padding: const EdgeInsets.only(right: 67.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(startList.length - 2, (index) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1, -5.0),
                          end: Offset.zero,
                        ).animate(controllers[index]),
                        child: Padding(
                            padding: EdgeInsets.all(4.0),
                            child:
                                Center(child: Image.asset(startList[index]))),
                      );
                    }),
                  )),
            ],
          ),
        ),
      );
    } else if (secondsElapsed <= 1000) {
      return Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: SizedBox(
          height: 50,
          width: MediaQuery.of(Get.context!).size.width,
          child: Stack(
            children: [
              // Display gray stars at the bottom
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(startList.length, (index) {
                  return Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Center(
                          child: Image.asset(
                        startList[index],
                        color: greyColor,
                      )));
                }),
              ),
              // Display amber stars with SlideTransition
              Padding(
                  padding: const EdgeInsets.only(right: 115.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(startList.length - 3, (index) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1, -5.0),
                          end: Offset.zero,
                        ).animate(controllers[index]),
                        child: Padding(
                            padding: EdgeInsets.all(4.0),
                            child:
                                Center(child: Image.asset(startList[index]))),
                      );
                    }),
                  )),
            ],
          ),
        ),
      );
    } else if (secondsElapsed <= 15000000) {
      return Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: SizedBox(
          height: 50,
          width: MediaQuery.of(Get.context!).size.width,
          child: Stack(
            children: [
              // Display gray stars at the bottom
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(startList.length, (index) {
                  return Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Center(
                          child: Image.asset(
                        startList[index],
                        color: greyColor,
                      )));
                }),
              ),
              // Display amber stars with SlideTransition
              Padding(
                  padding: const EdgeInsets.only(right: 150.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(startList.length - 4, (index) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1, -5.0),
                          end: Offset.zero,
                        ).animate(controllers[index]),
                        child: Padding(
                            padding: EdgeInsets.all(4.0),
                            child:
                                Center(child: Image.asset(startList[index]))),
                      );
                    }),
                  )),
            ],
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    timer!.cancel();
    controllers.forEach((controller) => controller.dispose());
    secondsElapsed = 0;
    animateController.dispose();
    blastController.dispose();
    super.dispose();
  }

  @override
  void onReady() {
    super.onReady();
  }

  void submitUser() {
    if (userData == null) {
      NumberUserData st = new NumberUserData(
          userMoves: moves.toString() ?? "",
          userNames: getNumGrid == '1'
              ? '3*3'
              : getNumGrid == '2'
                  ? '4*4'
                  : '5*5',
          result: formatTime(secondsElapsed));
      dbStudentManager.insertStudent(st).then((value) => {
            print("User Data Add to database $value"),
          });
    } else {}
  }
}
