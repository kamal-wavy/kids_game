import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../color.dart';
import '../../../../custom/simpleText.dart';
import '../../../../image.dart';
import '../../../../routes/app_routes.dart';
import '../../../../string.dart';
import '../../view/selectImage/animal_grid_screen.dart';

class SelectImageController extends GetxController
    with SingleGetTickerProviderMixin {
  @override
  String? getRoleId;
  final AudioPlayer audioPlayer = AudioPlayer();
  bool showText = false;

  // String audioPath = 'audio/ping.mp3';
  String audioPath = 'audio/click.mp3';
  AnimationController? animationControllerBlast;
  int start = 0;
  void playAnimation() {

    animationControllerBlast!.forward(from: 0.0);

  }
  @override
  void onInit() {
    super.onInit();
    getData();
    startGame();
    animationControllerBlast = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10), // Adjust the duration as needed
    );
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

  List<Map<String, List<String>>> animalImageSets = [
    {
      'animalName': ['bear'],
      'imageSet': ['bear.png', 'cow.png', 'buffalo.png'],
    },
    {
      'animalName': ['dear'],
      'imageSet': ['dog.png', 'dear.png', 'elephant.png'],
    },
    {
      'animalName': ['rat'],
      'imageSet': ['bear.png', 'turtle.png', 'rat.png'],
    },
    {
      'animalName': ['lion'],
      'imageSet': ['horse.png', 'lion.png', 'zebra.png'],
    },
    {
      'animalName': ['cow'],
      'imageSet': ['buffalo.png', 'cow.png', 'dear.png'],
    },
    {
      'animalName': ['dog'],
      'imageSet': ['dog.png', 'elephant.png', 'rat.png'],
    },
    {
      'animalName': ['turtle'],
      'imageSet': ['lion.png', 'turtle.png', 'horse.png'],
    },
    {
      'animalName': ['buffalo'],
      'imageSet': ['dog.png', 'dear.png', 'buffalo.png'],
    },
    {
      'animalName': ['zebra'],
      'imageSet': ['cow.png', 'zebra.png', 'elephant.png'],
    },
    {
      'animalName': ['horse'],
      'imageSet': ['elephant.png', 'horse.png', 'dear.png'],
    },
    // Add more animals and their image sets as needed.
  ];
  List<Map<String, List<String>>> foodImageSets = [
    {
      'animalName': ['burger'],
      'imageSet': ['burger.png', 'taco.png', 'ramen.png'],
    },
    {
      'animalName': ['pizza'],
      'imageSet': ['donut.png', 'french-fries.png', 'pizza.png'],
    },
    {
      'animalName': ['ramen'],
      'imageSet': ['pizza.png', 'ramen.png', 'burger.png'],
    },
    {
      'animalName': ['Bhatura'],
      'imageSet': ['Bhatura.png', 'burger.png', 'taco.png'],
    },
    {
      'animalName': ['biryani'],
      'imageSet': ['muffin.png', 'pizza.png', 'biryani.png'],
    },
    {
      'animalName': ['chickenleg'],
      'imageSet': ['chickenleg.png', 'ramen.png', 'burger.png'],
    },
    {
      'animalName': ['cookies'],
      'imageSet': ['roti.png', 'cookies.png', 'burger.png'],
    },
    {
      'animalName': ['muffin'],
      'imageSet': ['french-fries.png', 'muffin.png', 'pizza.png'],
    },
    {
      'animalName': ['roti'],
      'imageSet': ['donut.png', 'taco.png', 'roti.png'],
    },
    {
      'animalName': ['samosa'],
      'imageSet': ['samosa.png', 'cookies.png', 'biryani.png'],
    },
    // Add more animals and their image sets as needed.
  ];
  List<Map<String, List<String>>> fruitImageSets = [
    {
      'animalName': ['apple'],
      'imageSet': ['grapes.png', 'banana.png', 'apple.png'],
    },
    {
      'animalName': ['guava'],
      'imageSet': ['kiwi.png', 'guava.png', 'mango.png'],
    },
    {
      'animalName': ['orange'],
      'imageSet': ['banana.png', 'strawberry.png', 'orange.png'],
    },
    {
      'animalName': ['watermelon'],
      'imageSet': ['mango.png', 'watermelon.png', 'grapes.png'],
    },
    {
      'animalName': ['banana'],
      'imageSet': ['banana.png', 'guava.png', 'orange.png'],
    },
    {
      'animalName': ['kiwi'],
      'imageSet': ['kiwi.png', 'mango.png', 'strawberry.png'],
    },
    {
      'animalName': ['grapes'],
      'imageSet': ['banana.png', 'grapes.png', 'watermelon.png'],
    },
    {
      'animalName': ['cherry'],
      'imageSet': ['strawberry.png', 'cherry.png', 'guava.png'],
    },
    {
      'animalName': ['mango'],
      'imageSet': ['banana.png', 'mango.png', 'orange.png'],
    },
    {
      'animalName': ['strawberry'],
      'imageSet': ['strawberry.png', 'grapes.png', 'cherry.png'],
    },
    // Add more animals and their image sets as needed.
  ];
  List<Map<String, List<String>>> birdsImageSets = [
    {
      'animalName': ['parrot'],
      'imageSet': ['hawk.png', 'parrot.png', 'ostrich.png'],
    },
    {
      'animalName': ['owl'],
      'imageSet': ['duck.png', 'owl.png', 'hen.png'],
    },
    {
      'animalName': ['sparrow'],
      'imageSet': ['hawk1.png', 'sparrow.png', 'parrot.png'],
    },
    {
      'animalName': ['crane'],
      'imageSet': ['parrot.png', 'crane.png', 'hen.png'],
    },
    {
      'animalName': ['hummingbird'],
      'imageSet': ['hummingbird.png', 'owl.png', 'duck.png'],
    },
    {
      'animalName': ['peacock'],
      'imageSet': ['parrot.png', 'sparrow.png', 'peacock.png'],
    },
    {
      'animalName': ['penguin'],
      'imageSet': ['penguin.png', 'duck.png', 'parrot.png'],
    },
    {
      'animalName': ['pigeon'],
      'imageSet': ['crane.png', 'pigeon.png', 'owl.png'],
    },
    {
      'animalName': ['crow'],
      'imageSet': ['crow.png', 'duck.png', 'parrot.png'],
    },
    {
      'animalName': ['hen'],
      'imageSet': ['peacock.png', 'penguin.png', 'hen.png'],
    },
    // Add more animals and their image sets as needed.
  ];

  List<Map<String, List<String>>> stationaryImageSets = [
    {
      'animalName': ['pencil'],
      'imageSet': ['book.png', 'pencil.png', 'eraser.png'],
    },
    {
      'animalName': ['sharpner'],
      'imageSet': ['sharpner.png', 'eraser.png', 'pen.png'],
    },
    {
      'animalName': ['book'],
      'imageSet': ['book.png', 'pen.png', 'pencil.png'],
    },
    {
      'animalName': ['stapler'],
      'imageSet': ['eraser.png', 'stapler.png', 'scale.png'],
    },
    {
      'animalName': ['calculator'],
      'imageSet': ['calculator.png', 'tape.png', 'pencil.png'],
    },
    {
      'animalName': ['scissors'],
      'imageSet': ['pen.png', 'scissors.png', 'book.png'],
    },
    {
      'animalName': ['scale'],
      'imageSet': ['scale.png', 'puncher.png', 'gluestick.png'],
    },
    {
      'animalName': ['tape'],
      'imageSet': ['calculator.png', 'tape.png', 'pencil.png'],
    },
    {
      'animalName': ['gluestick'],
      'imageSet': ['pen.png', 'gluestick.png', 'book.png'],
    },
    {
      'animalName': ['puncher'],
      'imageSet': ['puncher.png', 'scale.png', 'scissors.png'],
    },
    // Add more animals and their image sets as needed.
  ];
  List<Map<String, List<String>>> hindiImageSets = [
    {
      'animalName': ['orange'],
      'imageSet': ['orange.png', 'banana.png', 'kiwi.png'],
    },
    {
      'animalName': ['watermelon'],
      'imageSet': ['grapes.png', 'watermelon.png', 'mango.png'],
    },
    {
      'animalName': ['banana'],
      'imageSet': ['orange.png', 'grapes.png', 'banana.png'],
    },
    {
      'animalName': ['mango'],
      'imageSet': ['banana.png', 'mango.png', 'cherry.png'],
    },
    {
      'animalName': ['spoon'],
      'imageSet': ['kiwi.png', 'spoon.png', 'orange.png'],
    },
    {
      'animalName': ['grapes'],
      'imageSet': ['grapes.png', 'banana.png', 'watermelon.png'],
    },
    {
      'animalName': ['pigeon'],
      'imageSet': ['cherry.png', 'pigeon.png', 'orange.png'],
    },
    {
      'animalName': ['road'],
      'imageSet': ['banana.png', 'road.png', 'grapes.png'],
    },
    {
      'animalName': ['kite'],
      'imageSet': ['kiwi.png', 'banana.png', 'kite.png'],
    },
    {
      'animalName': ['flower_pot'],
      'imageSet': ['flower_pot.png', 'watermelon.png', 'cherry.png'],
    },
    // Add more animals and their image sets as needed.
  ];

  int currentSetIndex = 0;
  int imageSetIndex = 1;
  int correctAnswers = 0;
  Timer? timer;
  int secondsElapsed = 0;
  String message = '';
  late List<Color> starColors;
  late List<AnimationController> controllers;
  bool isTimerPaused = false;
  final blastController = ConfettiController();

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

                      Get.offAllNamed(AppRoutes.animalGridScreen);
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

  void checkAnswer(String animalName) {
    // String result =  animalName.replaceAll('.png', '');
    String result = getRoleId == '1'
        ? animalName.split('/').last.split('.').first
        : getRoleId == '2'
            ? animalName.split('/').last.split('.').first
            : getRoleId == '3'
                ? animalName.split('/').last.split('.').first
                : animalName.replaceAll('.png', '');

    String currentAnimal = getRoleId == '1'
        ? (birdsImageSets[currentSetIndex]['animalName']![0])
        : getRoleId == '2'
            ? (hindiImageSets[currentSetIndex]['animalName']![0])
            : getRoleId == '3'
                ? (fruitImageSets[currentSetIndex]['animalName']![0])
                : animalImageSets[currentSetIndex]['animalName']![0];

    print(currentAnimal);
    print(result);
    if (result == currentAnimal) {
      correctAnswers++;
      if (correctAnswers == 10) {
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

        start=1;
        playAnimation();
        dh();
        update();
        // message = 'You scored 5/10!';
      } else {
        // message = 'Correct!';
        currentSetIndex++;
        imageSetIndex++;
        print('kamala');
        print(currentSetIndex);
        print('llalal');
        if (currentSetIndex >= animalImageSets.length) {
          currentSetIndex = 0;
        }
        if (currentSetIndex >= birdsImageSets.length) {
          currentSetIndex = 0;
        }
        if (currentSetIndex >= stationaryImageSets.length) {
          currentSetIndex = 0;
        }
        if (currentSetIndex >= fruitImageSets.length) {
          currentSetIndex = 0;
        }
        if (currentSetIndex >= hindiImageSets.length) {
          currentSetIndex = 0;
        }

        update();
      }
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
                            Get.offAll(AnimalGridScreen());
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
