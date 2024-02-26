import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:KidsPlan/sqlite_data/number_game_data/data.dart';

import '../../../../color.dart';
import '../../../../custom/simpleText.dart';
import '../../../../image.dart';
import '../../../../string.dart';
import '../../view/image/puzzle_option.dart';

class ImagePickedSolveController extends GetxController
    with SingleGetTickerProviderMixin {
  @override
  String? getRoleId;
  final AudioPlayer audioPlayer = AudioPlayer();
  final DBNumberGame dbStudentManager = new DBNumberGame();
  List<Uint8List>? puzzlePieces;
  File? image;

  // String audioPath = 'audio/ping.mp3';
  String audioPath = 'audio/click.mp3';
  List<String> containerList = ['1', '2', '3'];
  int? gridSize;
  int moves = 0;
  NumberUserData? userData;
  Timer? timer;
  int secondsElapsed = 0;

  String message = '';
  String? getImage;

  late List<Color> starColors;
  late List<AnimationController> controllers;
  bool isTimerPaused = false;

  late List<int> shuffledIndices;
  int emptyIndex = 0; // The initial empty box is at the top-left corner

  void shufflePuzzle() {
    shuffledIndices.shuffle();
    // Ensure the shuffled puzzle is solvable
    while (!isSolvable()) {
      shuffledIndices.shuffle();
    }
  }

  bool isSolvable() {
    int inversions = 0;
    for (int i = 0; i < puzzlePieces!.length - 1; i++) {
      for (int j = i + 1; j < puzzlePieces!.length; j++) {
        if (shuffledIndices[i] > shuffledIndices[j]) {
          inversions++;
        }
      }
    }

    // Check if the puzzle is solvable based on the number of inversions
    return inversions % 2 == 0;
  }

  Widget buildPuzzlePiece(int index) {
    // Display an empty box if the current index matches the emptyIndex
    return index == emptyIndex
        ? Container(color: Colors.grey)
        : Image.memory(
            puzzlePieces![shuffledIndices[index]],
            fit: BoxFit.cover, // Ensure the image covers the entire space
          );
  }

  void onPieceTap(int tappedIndex) {
    // Check if the tapped piece is adjacent to the empty piece
    if (isAdjacent(tappedIndex, emptyIndex)) {
      // Swap the indices of the tapped piece and the empty piece
      final temp = shuffledIndices[tappedIndex];
      shuffledIndices[tappedIndex] = shuffledIndices[emptyIndex];
      shuffledIndices[emptyIndex] = temp;
      emptyIndex = tappedIndex;
      moves++;
      update();
      // Check if the puzzle is solved
      if (isPuzzleSolved()) {
        // Show a dialog when the puzzle is solved
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
        dh();
      }
      update();
    }
  }

  bool isAdjacent(int index1, int index2) {
    // Check if two indices are adjacent
    final int row1 = index1 ~/ 3;
    final int col1 = index1 % 3;
    final int row2 = index2 ~/ 3;
    final int col2 = index2 % 3;

    return (row1 == row2 && (col1 - col2).abs() == 1) ||
        ((row1 - row2).abs() == 1 && col1 == col2);
  }

  bool isPuzzleSolved() {
    // Check if the puzzle is solved by comparing the shuffled indices with the original indices
    return List.generate(puzzlePieces!.length, (index) => index).every(
      (originalIndex) => shuffledIndices[originalIndex] == originalIndex,
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
                      Get.offAll(ImagePuzzleOptionScreen());
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

  @override
  void onInit() {
    super.onInit();
    getData();

    if (timer == null || !timer!.isActive) {
      startGame();
    }
    shuffledIndices = List.generate(puzzlePieces!.length, (index) => index);
    shufflePuzzle();
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
      if (Get.arguments["puzzlePieces"] != null ||
          Get.arguments["fullImage"] != null ||
          Get.arguments["assetImage"] != null &&
              Get.arguments["getRoleId"] != null) {
        puzzlePieces = (Get.arguments["puzzlePieces"]);
        image = (Get.arguments["fullImage"]);
        getRoleId = (Get.arguments["getRoleId"]);
        getImage = (Get.arguments["assetImage"]);

        debugPrint('rah');
        debugPrint('$puzzlePieces');
        debugPrint('$image');
        debugPrint('$getRoleId');
        debugPrint('$getImage');
        debugPrint('rab');
      }
    }
  }

  List<int>? numbers;

  dh() {
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
                            Get.offAll(ImagePuzzleOptionScreen());
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
          result: formatTime(secondsElapsed));
      dbStudentManager.insertStudent(st).then((value) => {
            print("User Data Add to database $value"),
          });
    } else {}
  }
}
