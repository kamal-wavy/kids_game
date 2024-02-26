import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../color.dart';
import '../../../../custom/simpleText.dart';
import '../../../../image.dart';
import '../../../../routes/app_routes.dart';
import '../../../../string.dart';
import '../../view/pair/pair_grid.dart';

class PairSolveController extends GetxController
    with SingleGetTickerProviderMixin {
  @override
  String? getRoleId;
  final AudioPlayer audioPlayer = AudioPlayer();
  bool showText = false;
  int currentStep = 1;
  String audioPath = 'audio/click.mp3';
  var appBarSize;
  int num1 = 0;
  int num2 = 0;
  int correctAnswer = 0;
  double correctAnswerDivision = 0;
  List<int> answerOptions = [];
  List<double> answerOptionsDivision = [];
  String message = "";
  bool showMessage = false;
  int score = 0;
  Offset? start;
  Offset? end;
  final blastController = ConfettiController();
  AnimationController? animationControllerBlast;
  int startBlast = 0;

  // for colors lsit
  List<ItemModel>? itemList;
  List<ItemModel>? itemList2;
  Map<ItemModel, ItemModel?> matchedPairs = {};
  List<LinePainterWidget> drawnLines = [];
  List<ItemModel> nextItemList = [];

  // for alpahbet lsit
  List<ItemModel1>? itemListAlpahbet;
  List<ItemModel1>? itemListAlpahbet2;
  Map<ItemModel1, ItemModel1?> matchedPairsAlpahbet = {};
  List<ItemModel1> nextItemListAlpahbet = [];

  // for alpahbet lsit
  List<ItemModel1>? itemListSymbol;
  List<ItemModel1>? itemListSymbol2;
  Map<ItemModel1, ItemModel1?> matchedPairsSymbol = {};
  List<ItemModel1> nextItemListSymbol = [];

  double getAppBarOffset(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double appBarOffset =
        screenHeight * 0.1; // Adjust this multiplier as needed
    return appBarOffset;
  }

  void playAnimation() {

    animationControllerBlast!.forward(from: 0.0);

  }
  checkResult() {
    stopTimer();

    starColors = List.generate(5, (index) => Colors.grey);
    controllers = List.generate(5, (index) {
      return AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      );
    });
    startAnimation();
    startBlast=1;
    playAnimation();
    dh();
    update();

  }

  @override
  void onInit() {
    super.onInit();
    getData();
    startGame();

    initList();
    initNextItemList();

    initListAlphabet();
    initNextItemListAlpahbet();

    initListSymbol();
    initNextItemListSymbol();
    animationControllerBlast = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10), // Adjust the duration as needed
    );
  }

  void showTemporaryMessage(String messageToShow) {
    message = messageToShow;
    showMessage = true;
    update();

    Timer(Duration(seconds: 1), () {
      showMessage = false;
      update();
    });
  }

  checkGame(int option) {
    if (option == correctAnswer) {
      // Increment the score for correct answers

      score++;
      currentStep += 1;
      update();

      update();
      if (score == 10) {
        stopTimer();

        starColors = List.generate(5, (index) => Colors.grey);
        controllers = List.generate(5, (index) {
          return AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 500),
          );
        });
        startAnimation();
        startBlast=1;
        playAnimation();
        dh();
        update();
      }
    } else {
      showTemporaryMessage("Wrong! Try again");
    }
  }

  checkDivisionGame(double option) {
    if (option == correctAnswerDivision) {
      // Increment the score for correct answers

      score++;
      currentStep += 1;
      update();

      update();
      if (score == 10) {
        stopTimer();

        starColors = List.generate(5, (index) => Colors.grey);
        controllers = List.generate(5, (index) {
          return AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 500),
          );
        });
        startAnimation();
        startBlast=1;
        playAnimation();
        dh();
        update();

      }
    } else {
      showTemporaryMessage("Wrong! Try again");
    }
  }

  startAnimation() async {
    for (int i = 0; i < 5; i++) {
      await Future.delayed(const Duration(milliseconds: 300));
      controllers[i].forward();

      starColors[i] = Colors.amber;
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
      if (Get.arguments["roleId"] != null) {
        getRoleId = (Get.arguments["roleId"]);

        debugPrint('$getRoleId');
      }
    }
  }

  int currentSetIndex = 0;
  int imageSetIndex = 1;
  int correctAnswers = 0;
  Timer? timer;
  int secondsElapsed = 0;

  late List<Color> starColors;
  late List<AnimationController> controllers;
  bool isTimerPaused = false;

  void startGame() {
    secondsElapsed = 0;

    startTimer();
    update();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    timer!.cancel(); // cancel the timer to avoid memory leaks
    blastController.dispose();
    super.dispose();
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
                            Image.asset(appbtn,
                                width: MediaQuery.of(context).size.width * 0.6),
                            CustomSimpleTextField(
                              // textSizeValue: true ,

                              hintText: txtResume,
                              textSize: 32,
                              hintColor: Colors.white,
                              fontfamily: 'summary',
                            ),
                          ],
                        )),
                  ),
                  GestureDetector(
                    onTap: () {
                      playAudio();

                      Get.offAllNamed(AppRoutes.pairGridScreen);
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

  List startList = [
    appStarLeft1,
    appStarLeft2,
    appStar1,
    appStarRight1,
    appStarRight2,
  ];

  showStar() {
    if (secondsElapsed <= 15) {
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
    } else if (secondsElapsed <= 25) {
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
    } else if (secondsElapsed <= 35) {
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
    } else if (secondsElapsed <= 45) {
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

  dh() {
    // blastController.play();
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
                            Get.offAll(PairGridScreen());
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

  @override
  void onReady() {
    super.onReady();
  }

  void initList() {
    GlobalKey key1 = GlobalKey();
    GlobalKey key2 = GlobalKey();
    GlobalKey key3 = GlobalKey();
    GlobalKey key4 = GlobalKey();
    GlobalKey key5 = GlobalKey();

    itemList = [
      ItemModel('Red', Colors.red, key1),
      ItemModel('Black', Colors.black, key2),
      ItemModel('Blue', Colors.blue, key3),
      ItemModel('Green', Colors.green, key4),
      ItemModel('Yellow', Colors.yellow, key5),
    ];
    itemList2 = List<ItemModel>.from(itemList!);
    itemList2!.shuffle();
    itemList!.shuffle();
  }

  void initNextItemList() {
    nextItemList = [
      ItemModel('Purple', Colors.purple, GlobalKey()),
      ItemModel('Orange', Colors.orange, GlobalKey()),
      ItemModel('Cyan', Colors.cyan, GlobalKey()),
      ItemModel('Pink', Colors.pink, GlobalKey()),
      ItemModel('Brown', Colors.brown, GlobalKey()),
    ];
    nextItemList.shuffle();
  }

  void initListAlphabet() {
    GlobalKey key1 = GlobalKey();
    GlobalKey key2 = GlobalKey();
    GlobalKey key3 = GlobalKey();
    GlobalKey key4 = GlobalKey();
    GlobalKey key5 = GlobalKey();

    itemListAlpahbet = [
      ItemModel1('O', 'assets/birds/owl.png', key1),
      ItemModel1('P', 'assets/birds/parrot.png', key2),
      ItemModel1('D', 'assets/animalspics/dino.png', key3),
      ItemModel1('E', 'assets/animalspics/elephant.png', key4),
      ItemModel1('B', 'assets/stationary/book.png', key5),
    ];
    itemListAlpahbet2 = List<ItemModel1>.from(itemListAlpahbet!);
    itemListAlpahbet2!.shuffle();
    itemListAlpahbet!.shuffle();
  }

  void initNextItemListAlpahbet() {
    nextItemListAlpahbet = [
      ItemModel1('A', 'assets/pair/apple.png', GlobalKey()),
      ItemModel1('H', 'assets/pair/cock.png', GlobalKey()),
      ItemModel1('V', 'assets/pair/van.png', GlobalKey()),
      ItemModel1('M', 'assets/pair/mango.png', GlobalKey()),
      ItemModel1('L', 'assets/pair/lion.png', GlobalKey()),
    ];

    nextItemListAlpahbet.shuffle();
  }

  void initListSymbol() {
    GlobalKey key1 = GlobalKey();
    GlobalKey key2 = GlobalKey();
    GlobalKey key3 = GlobalKey();
    GlobalKey key4 = GlobalKey();
    GlobalKey key5 = GlobalKey();

    itemListSymbol = [
      ItemModel1('Addition', 'assets/pair/add.png', key1),
      ItemModel1('Upward', 'assets/pair/up.png', key2),
      ItemModel1('Heart', 'assets/pair/heart.png', key3),
      ItemModel1('Multiply', 'assets/pair/multiply.png', key4),
      ItemModel1('Forward', 'assets/pair/right.png', key5),
    ];
    itemListSymbol2 = List<ItemModel1>.from(itemListSymbol!);
    itemListSymbol2!.shuffle();
    itemListSymbol!.shuffle();
  }

  void initNextItemListSymbol() {
    nextItemListSymbol = [
      ItemModel1('Division', 'assets/pair/division.png', GlobalKey()),
      ItemModel1('Downward', 'assets/pair/down.png', GlobalKey()),
      ItemModel1('Delete', 'assets/pair/trash.png', GlobalKey()),
      ItemModel1('Dollar', 'assets/pair/dollar.png', GlobalKey()),
      ItemModel1('Backward', 'assets/pair/arrow.png', GlobalKey()),
    ];

    nextItemListSymbol.shuffle();
  }

  void resetGame() {
    matchedPairs.clear();
    matchedPairsAlpahbet.clear();
    matchedPairsSymbol.clear();
    drawnLines.clear();
    score = 0;
    initList();
    initNextItemList();
    initListAlphabet();
    initNextItemListAlpahbet();
    initListSymbol();
    initNextItemListSymbol();
    update();
  }

  void loadNextSetOfItems() {
    // Change the names of the next set of items
    itemList = List<ItemModel>.from(nextItemList);

    // Reset drawn lines
    drawnLines.clear();

    // Shuffle the items
    itemList2 = List<ItemModel>.from(itemList!);
    itemList2!.shuffle();
    update();
  }

  void loadNextSetOfItemsAlphabet() {
    // Change the names of the next set of items
    itemListAlpahbet = List<ItemModel1>.from(nextItemListAlpahbet);

    // Reset drawn lines
    drawnLines.clear();

    // Shuffle the items
    itemListAlpahbet2 = List<ItemModel1>.from(itemListAlpahbet!);
    itemListAlpahbet2!.shuffle();
    update();
  }

  void loadNextSetOfItemsSymbol() {
    // Change the names of the next set of items
    itemListSymbol = List<ItemModel1>.from(nextItemListSymbol);

    // Reset drawn lines
    drawnLines.clear();

    // Shuffle the items
    itemListSymbol2 = List<ItemModel1>.from(itemListSymbol!);
    itemListSymbol2!.shuffle();
    update();
  }
}

class ItemModel {
  String name;
  Color color;

  GlobalKey key;

  ItemModel(this.name, this.color, this.key);
}

class ItemModel1 {
  String name;

  String matchImage;

  GlobalKey key;

  ItemModel1(this.name, this.matchImage, this.key);
}

// class LinePainter extends CustomPainter {
//   Offset start;
//   Offset end;
//
//   LinePainter(this.start, this.end);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     if (start == null || end == null) return;
//     canvas.drawLine(
//       start,
//       end,
//       Paint()
//         ..strokeWidth = 4
//         ..color = Colors.red,
//     );
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }
class LinePainter extends CustomPainter {
  Offset start;
  Offset end;
  final double arrowLength = 20.0;
  final double arrowAngle = pi / 6; // 30 degrees in radians

  LinePainter(this.start, this.end);

  @override
  void paint(Canvas canvas, Size size) {
    if (start == null || end == null) return;

    // Draw the line
    canvas.drawLine(
      start,
      end,
      Paint()
        ..strokeWidth = 4
        ..color = Colors.red,
    );

    // Calculate the angle between the line and the x-axis
    double angle = atan2(end.dy - start.dy, end.dx - start.dx);

    // Draw the arrowhead
    Path path = Path();
    path.moveTo(end.dx, end.dy);
    path.lineTo(
      end.dx - arrowLength * cos(angle - arrowAngle),
      end.dy - arrowLength * sin(angle - arrowAngle),
    );
    path.lineTo(
      end.dx - arrowLength * cos(angle + arrowAngle),
      end.dy - arrowLength * sin(angle + arrowAngle),
    );
    path.close();
    canvas.drawPath(path, Paint()..color = Colors.red);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
class LinePainterWidget extends StatelessWidget {
  final Offset start;
  final Offset end;

  LinePainterWidget(this.start, this.end);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: LinePainter(start, end),
    );
  }
}
