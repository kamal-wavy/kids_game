import 'dart:async';

import 'package:KidsPlan/pages/home/view/spelling/spelling_grid_screen.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../color.dart';
import '../../../../custom/simpleText.dart';
import '../../../../custom/take_screenshot.dart';
import '../../../../image.dart';
import '../../../../string.dart';

class SelectSpellingController extends GetxController
    with SingleGetTickerProviderMixin {
  @override
  String? getRoleId;
  int currentSetIndex = 0;
  int correctAnswers = 0;
  Timer? timer;
  int secondsElapsed = 0;
  String message = '';
  late List<Color> starColors;
  late List<AnimationController> controllers;
  bool isTimerPaused = false;
  List<String> shuffledSpellings = [];
  int score = 0;
  int currentIndex = 0;
  bool gameStarted = false;
  TextEditingController txtController = TextEditingController();
  Image? image;
  final AudioPlayer audioPlayer = AudioPlayer();
  String audioPath = 'audio/click.mp3';
  bool showText = false;

  final blastController = ConfettiController();
  AnimationController? animationControllerBlast;
  int start = 0;
  final AudioPlayer audioPlayerBlast = AudioPlayer();
  String audioPathbBlast = 'audio/four.mp3';
  void playAnimation() async{
    animationControllerBlast!.forward(from: 0.0);
    await audioPlayerBlast.play(AssetSource(audioPathbBlast));

    print('Audio playing  blast 1414');
  }

  void takeScreenshotMethod() {
    final screnCpntroller = Get.put(ScreenshotController());
    screnCpntroller.takeScreenshotAndShare();
  }

  @override
  void onInit() {
    super.onInit();
    shuffleStoreList();
    getData();
    startGame();
    animationControllerBlast = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10), // Adjust the duration as needed
    );
  }
  void shuffleStoreList() {
    colorList.shuffle();
    vegetableList.shuffle();
    bodyPartsList.shuffle();

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

  final List<Map<String, String>> colorList = [
    {'incorrect': 'Redd ,Rde', 'correct': 'Red'},
    {'incorrect': 'Bleu,Blu ', 'correct': 'Blue'},
    {'incorrect': 'Grenn,Grne', 'correct': 'Green'},
    {'incorrect': 'Broune,Browne', 'correct': 'Brown'},
    {'incorrect': 'Ornage,Orang', 'correct': 'Orange'},

    {'incorrect': 'Pik ,Penk', 'correct': 'Pink'},
    {'incorrect': 'Purplee,Purpal', 'correct': 'Purple'},
    {'incorrect': 'Blck,Blacke', 'correct': 'Black'},
    {'incorrect': 'Mehron,Maron', 'correct': 'Maroon'},
    {'incorrect': 'Gry,Grye', 'correct': 'Grey'},
    // Add more color names here
  ];
  final List<Map<String, String>> vegetableList = [
    {'incorrect': 'Tmato ,Toamato', 'correct': 'Tomato'},
    {'incorrect': 'Crrot,Carot ', 'correct': 'Carrot'},
    {'incorrect': 'Brenjal,Brijal', 'correct': 'Brinjal'},
    {'incorrect': 'Oion,Onin', 'correct': 'Onion'},
    {'incorrect': 'Ptato,Potto', 'correct': 'Potato'},

    {'incorrect': 'Cbage ,Cabage', 'correct': 'Cabbage'},
    {'incorrect': 'Broculi,Brocoly', 'correct': 'Broccoli'},
    {'incorrect': 'Spiach,Spynach', 'correct': 'Spinach'},
    {'incorrect': 'Mushrom,Musrom', 'correct': 'Mushroom'},
    {'incorrect': 'Ment,Mnt', 'correct': 'Mint'},
    // Add more color names here
  ];
  final List<Map<String, String>> bodyPartsList = [
    {'incorrect': 'Nse ,Noose', 'correct': 'Nose'},
    {'incorrect': 'Eaer,Year', 'correct': 'Ear'},
    {'incorrect': 'Hend,Hnd', 'correct': 'Hand'},
    {'incorrect': 'Hart,Hert', 'correct': 'Heart'},
    {'incorrect': 'Ees,Eys', 'correct': 'Eye'},

    {'incorrect': 'Lag ,Lgg', 'correct': 'Leg'},
    {'incorrect': 'Fot,Fuut', 'correct': 'Foot'},
    {'incorrect': 'Leps,Lyps', 'correct': 'Lips'},
    {'incorrect': 'Amr,Mra', 'correct': 'Arm'},
    {'incorrect': 'Nck,Nkck', 'correct': 'Neck'},
    // Add more color names here
  ];

  void startGame() {
    gameStarted = true;
    currentIndex = 0;
    secondsElapsed = 0;
    txtController.clear();
    startTimer();
    shuffleSpellings();
    update();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    controllers.forEach((controller) => controller.dispose());
    blastController.dispose();
    timer!.cancel(); // cancel the timer to avoid memory leaks
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
              Image.asset(appPause,height:  MediaQuery.of(context).size.width * 0.9),
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
                        textSize:  MediaQuery.of(context).size.width * 0.060,
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
                                width: MediaQuery.of(context).size.width * 0.5),
                            Center(
                              child: CustomSimpleTextField(
                                underLineValue: false,
                                textSizeValue: true,
                                textAlign: TextAlign.center,
                                hintText: txtResume,
                                textSize: MediaQuery.of(context).size.width * 0.060,
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

                      Get.offAll(SpellingGridScreen());
                    },
                    child: CustomSimpleTextField(
                      hintText: txtExit,
                      textSize:  MediaQuery.of(context).size.width * 0.070,
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

  _startAnimation() async {
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
    if (secondsElapsed <= 15) {
      return Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: SizedBox(
          height:  MediaQuery.of(Get.context!).size.height.toInt() * 0.06,
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
          height:  MediaQuery.of(Get.context!).size.height.toInt() * 0.06,
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
          height:  MediaQuery.of(Get.context!).size.height.toInt() * 0.06,
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
          height:  MediaQuery.of(Get.context!).size.height.toInt() * 0.06,
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
          height:  MediaQuery.of(Get.context!).size.height.toInt() * 0.06,
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

  void checkSpelling(var part) {
    final color = getRoleId == '1'
        ? colorList[currentIndex]
        : getRoleId == '2'
            ? vegetableList[currentIndex]
            : bodyPartsList[currentIndex];
    final correctSpelling = color['correct'];

    if (!gameStarted) {
      return; // Don't check spelling until the game has started.
    }

    if (part.toLowerCase() == correctSpelling?.toLowerCase()) {
      score++;
      txtController.clear();
      currentIndex++;

      if (currentIndex >=
          (getRoleId == '1'
              ? colorList.length
              : getRoleId == '2'
                  ? vegetableList.length
                  : bodyPartsList.length)) {
        stopTimer();

        starColors = List.generate(5, (index) => Colors.grey);
        controllers = List.generate(5, (index) {
          return AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 500),
          );
        });

        update();

        _startAnimation();
        // start = 1;
        playAnimation();
        dh();
        update();
      } else {
        shuffleSpellings();
      }
      // message = 'Correct!';
      update();
      update();
    } else {
      showText = true;
      message = 'Wrong!';
      Future.delayed(Duration(seconds: 1), () {
        showText = false;
        update();
      });
      update();
    }

    update();
  }

  void shuffleSpellings() {
    final color = getRoleId == '1'
        ? colorList[currentIndex]
        : getRoleId == '2'
            ? vegetableList[currentIndex]
            : bodyPartsList[currentIndex];
    // final color = vegetableList[currentIndex];
    shuffledSpellings = [color['correct']!] + color['incorrect']!.split(',');
    shuffledSpellings.shuffle();
  }

  dh() {
    blastController.play();
     showDialog(
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
                          textSize:  MediaQuery.of(Get.context!).size.height.toInt() *
                              0.04,
                          hintColor: appRedColor,
                          fontfamily: 'summary',
                        ),
                      ),
                      Flexible(
                        child: CustomSimpleTextField(
                          hintText:
                          '$txtGameTime ${formatTime(secondsElapsed)}',
                          textSize:
                          MediaQuery.of(Get.context!).size.height.toInt() *
                              0.025,
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
                            Get.offAll(SpellingGridScreen());
                          },
                          child: Image.asset(appFinish,height:   MediaQuery.of(Get.context!)
                              .size
                              .height
                              .toInt() *
                              0.05,),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.share,color: Colors.pink,),
                          ),
                          Flexible(
                            child: GestureDetector(
                              onTap: () {
                                takeScreenshotMethod();
                              },
                              child: CustomSimpleTextField(

                                underLineValue:false,
                                textSizeValue: true ,
                                hintText: 'Share With Friends',
                                textSize:  MediaQuery.of(Get.context!)
                                    .size
                                    .height
                                    .toInt() *
                                    0.020,
                                hintColor: appColor,
                                fontfamily: 'Montstreat',
                              ),
                            ),
                          ),
                        ],
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
    start = 1;
    update();
  }

  @override
  void onReady() {
    super.onReady();
  }
}
