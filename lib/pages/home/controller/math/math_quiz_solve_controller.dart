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
import '../../view/math/math_grid.dart';

class MathQuizSolveController extends GetxController
    with SingleGetTickerProviderMixin {
  @override
  String? getRoleId;
  final AudioPlayer audioPlayer = AudioPlayer();
  bool showText = false;
  int currentStep = 1;
  String audioPath = 'audio/click.mp3';
  final blastController = ConfettiController();


  int num1 = 0;
  int num2 = 0;
  int correctAnswer = 0;
  double correctAnswerDivision = 0;
  List<int> answerOptions = [];
  List<double> answerOptionsDivision = [];
  String message = "";
  bool showMessage = false;
  int score = 0;
  AnimationController? animationControllerBlast;
  final AudioPlayer audioPlayerBlast = AudioPlayer();

  String audioPathbBlast = 'audio/four.mp3';

  @override
  void onInit() {
    super.onInit();
    getData();
    startGame();
    generateQuestion();
    animationControllerBlast = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10), // Adjust the duration as needed
    );
  }
  int start = 0;
  void playAnimation()async {

    animationControllerBlast!.forward(from: 0.0);
    await audioPlayerBlast.play(AssetSource(audioPathbBlast));

    print('Audio playing  blast 1414');

  }

  void generateQuestion() {
    if (getRoleId == '1') {
      num1 = Random().nextInt(20) + 1;
      num2 = Random().nextInt(20) + 1;

      correctAnswer = num1 + num2;

      answerOptions = [correctAnswer];
      while (answerOptions.length < 3) {
        int randomOption =
            Random().nextInt(20) + 1; // Adjust the range as needed
        if (!answerOptions.contains(randomOption)) {
          answerOptions.add(randomOption);
        }
      }

      answerOptions.shuffle();
    } else if (getRoleId == '2') {
      num1 = Random().nextInt(20) + 1;
      num2 = Random().nextInt(20) + 1;

      correctAnswer = num1 - num2;

      answerOptions = [correctAnswer];
      while (answerOptions.length < 3) {
        int randomOption =
            Random().nextInt(20) + 1; // Adjust the range as needed
        if (!answerOptions.contains(randomOption)) {
          answerOptions.add(randomOption);
        }
      }

      answerOptions.shuffle();
    } else if (getRoleId == '3') {
      num1 = Random().nextInt(10) + 1;
      num2 = Random().nextInt(10) + 1;

      correctAnswer = num1 * num2;

      answerOptions = [correctAnswer];
      while (answerOptions.length < 3) {
        int randomOption =
            Random().nextInt(20) + 1; // Adjust the range as needed
        if (!answerOptions.contains(randomOption)) {
          answerOptions.add(randomOption);
        }
      }

      answerOptions.shuffle();
    } else if (getRoleId == '4') {
      // num1 = Random().nextInt(20) + 1;
      do {
        num1 = Random().nextInt(20) + 1;
      } while (num1 <= 10);
      num2 = Random().nextInt(10) + 1;

      correctAnswerDivision = num1 / num2;

      answerOptionsDivision = [correctAnswerDivision];
      while (answerOptionsDivision.length < 3) {
        double randomOption =
            Random().nextInt(20) + 1; // Adjust the range as needed
        if (!answerOptionsDivision.contains(randomOption)) {
          answerOptionsDivision.add(randomOption);
        }
      }

      answerOptionsDivision.shuffle();
    }
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
      generateQuestion();
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
        start=1;
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
      generateQuestion();
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
        start=1;
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
    audioPlayerBlast.dispose();
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
                 Get.offAll(MathGridScreen());
                      // timer!.cancel();
                      // isTimerPaused = false;
                      // Get.offNamed(AppRoutes.animalGridScreen);
                      // Get.offAllNamed(AppRoutes.mathGridScreen);
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
                            audioPlayerBlast.stop();
                            print('Audio stop  blast 1414');
                            Get.offAll(MathGridScreen());
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
}
