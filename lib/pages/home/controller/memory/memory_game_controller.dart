import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../color.dart';
import '../../../../custom/simpleText.dart';
import '../../../../custom/take_screenshot.dart';
import '../../../../image.dart';
import '../../../../string.dart';
import '../../view/memory/memory_grid.dart';

class MemoryGameSolveController extends GetxController
    with SingleGetTickerProviderMixin {
  late GameImage gameImage;
  late AnimationController animationController;
  late Game game;
  final AudioPlayer audioPlayer = AudioPlayer();
  String audioPath = 'audio/click.mp3';
  bool isTimerPaused = false;
  Timer? timer;
  int secondsElapsed = 0;
  int score = 0;
  int start = 0;
  String? formattedTime;
  String? getRoleId;

  late List<Color> starColors;
  late List<AnimationController> controllers;
  AnimationController? animationControllerBlast;

  final AudioPlayer audioPlayerBlast = AudioPlayer();

  String audioPathbBlast = 'audio/four.mp3';
  String audioPathbBlast1 = 'audio/ontap.mp3';
  String audioPathbBlast2 = 'audio/ontap1.mp3';

  void playAnimation() async {
    animationControllerBlast!.forward(from: 0.0);
    await audioPlayerBlast.play(AssetSource(audioPathbBlast));

    print('Audio playing  blast 1414');
  }

  void playMusicOnTap() async {
    animationControllerBlast!.forward(from: 0.0);
    await audioPlayerBlast.play(AssetSource(audioPathbBlast2));

    print('Audio playing on Tap  2000');
  }

  void takeScreenshotMethod() {
    final screnCpntroller = Get.put(ScreenshotController());
    screnCpntroller.takeScreenshotAndShare();
  }

  List<Card> cards = [
    Card(id: 0, imageName: 'assets/animal/cow.png'),
    Card(id: 1, imageName: 'assets/animal/bear.png'),
    Card(id: 2, imageName: 'assets/animal/elephant.png'),
    Card(id: 3, imageName: 'assets/animal/rat.png'),
    Card(id: 4, imageName: 'assets/animal/turtle.png'),
    Card(id: 5, imageName: 'assets/animal/dog.png'),
    Card(id: 6, imageName: 'assets/animal/deer.png'),
    Card(id: 7, imageName: 'assets/animal/horse.png'),
    // Card(id: 8, imageName: 'assets/match/cow.png'),

    // Add more cards as needed
  ];
  List<Card> cardsNumber = [
    Card(id: 0, imageName: 'assets/pair/h.png'),
    Card(id: 1, imageName: 'assets/pair/b.png'),
    Card(id: 2, imageName: 'assets/pair/e.png'),
    Card(id: 3, imageName: 'assets/pair/m.png'),
    Card(id: 4, imageName: 'assets/pair/o.png'),
    Card(id: 5, imageName: 'assets/pair/p.png'),
    Card(id: 6, imageName: 'assets/pair/v.png'),
    Card(id: 7, imageName: 'assets/pair/d.png')
    // Card(id: 8, imageName: 'assets/match/cow.png'),

    // Add more cards as needed
  ];

  @override
  void onInit() {
    super.onInit();
    if (timer == null || !timer!.isActive) {
      startGame();
    }
    getData();
    // for numbe game
    // game = Game(cards: List.generate(16, (index) => CardModel(id: index ~/ 2)));
    // game.cards.shuffle();

    var random = Random();
    var numbers = List.generate(
        8,
        (index) =>
            random.nextInt(101)); // Generate 8 random numbers between 0 and 50
    var pairs = [...numbers, ...numbers]; // Duplicate numbers for pairs
    pairs.shuffle(); // Shuffle the pairs

    game =
        Game(cards: List.generate(16, (index) => CardModel(id: pairs[index])));
    game.cards.shuffle();

    // for image game
    List<String> imageNames = [
      'assets/animal/cow.png',
      'assets/animal/bear.png',
      'assets/animal/elephant.png',
      'assets/animal/rat.png',
      'assets/animal/turtle.png',
      'assets/animal/dog.png',
      'assets/animal/deer.png',
      'assets/animal/horse.png',
    ];
    List<String> alphabetNames = [
      'assets/pair/h.png',
      'assets/pair/b.png',
      'assets/pair/e.png',
      'assets/pair/m.png',
      'assets/pair/o.png',
      'assets/pair/p.png',
      'assets/pair/v.png',
      'assets/pair/l.png',
    ];
    List<Card> cards = [];

    for (int i = 0; i < 2; i++) {
      // Duplicate each image
      if (getRoleId == '2') {
        for (int j = 0; j < imageNames.length; j++) {
          cards.add(Card(id: j, imageName: imageNames[j]));
        }
      } else {
        for (int j = 0; j < alphabetNames.length; j++) {
          cards.add(Card(id: j, imageName: alphabetNames[j]));
        }
      }
    }
    cards.shuffle(); // Shuffle the cards

    gameImage = GameImage(cardsImage: cards);

    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    animationControllerBlast = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10), // Adjust the duration as needed
    );
  }

  getData() {
    if (Get.arguments != null) {
      if (Get.arguments["roleId"] != null) {
        getRoleId = (Get.arguments["roleId"]);

        debugPrint('$getRoleId');
      }
    }
  }

  // for image game
  void flipCard(int index) {
    if (!gameImage.cardsImage[index].isFlipped &&
        !gameImage.cardsImage[index].isMatched) {
      score++;
      playMusicOnTap();
      print(score);
      gameImage.flipCard(index);
      if (gameImage.firstSelectedIndex != null &&
          gameImage.secondSelectedIndex != null) {
        if (gameImage.isMatched) {
          gameImage.cardsImage[gameImage.firstSelectedIndex!].isMatched = true;
          gameImage.cardsImage[gameImage.secondSelectedIndex!].isMatched = true;
          // score++;
          gameImage.resetSelectedCards();
        } else {
          Future.delayed(Duration(milliseconds: 500), () {
            gameImage.flipCard(gameImage.firstSelectedIndex!);
            gameImage.flipCard(gameImage.secondSelectedIndex!);
            gameImage.resetSelectedCards();
            update();
          });
        }
      }
      update();
      if (gameImage.isGameOver) {
        stopTimer();
        print(score);
        starColors = List.generate(5, (index) => Colors.grey);
        controllers = List.generate(5, (index) {
          return AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 500),
          );
        });
        update();

        _startAnimation();

        start = 1;
        playAnimation();
        dh();
        update();
      }
    }
  }

  // for number game
  void flipCardNumber(int index) {
    if (!game.cards[index].isFlipped && !game.cards[index].isMatched) {
      score++;
      playMusicOnTap();
      game.flipCard(index);
      if (game.firstSelectedIndex != null && game.secondSelectedIndex != null) {
        if (game.isMatched) {
          game.cards[game.firstSelectedIndex!].isMatched = true;
          game.cards[game.secondSelectedIndex!].isMatched = true;

          game.resetSelectedCards();
        } else {
          // If not matched, flip the cards back to the front
          Future.delayed(Duration(milliseconds: 500), () {
            game.resetSelectedCards();
            update();
          });
        }
      }
      update();
      if (game.isGameOver) {
        stopTimer();
        print(score);
        starColors = List.generate(5, (index) => Colors.grey);
        controllers = List.generate(5, (index) {
          return AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 500),
          );
        });
        update();

        _startAnimation();

        start = 1;
        playAnimation();
        dh();
        update();
      }
    }
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
    if (score <= 35) {
      return Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: SizedBox(
          height: MediaQuery.of(Get.context!).size.height.toInt() * 0.06,
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
    } else if (score <= 40) {
      return Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: SizedBox(
          height: MediaQuery.of(Get.context!).size.height.toInt() * 0.06,
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
    } else if (score <= 50) {
      return Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: SizedBox(
          height: MediaQuery.of(Get.context!).size.height.toInt() * 0.06,
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
    } else if (score <= 55) {
      return Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: SizedBox(
          height: MediaQuery.of(Get.context!).size.height.toInt() * 0.06,
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
    } else if (score <= 10000) {
      return Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: SizedBox(
          height: MediaQuery.of(Get.context!).size.height.toInt() * 0.06,
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

  String formatSeconds(int seconds) {
    int hours = seconds ~/ 3600;
    int remainingSeconds = seconds % 3600;
    int minutes = remainingSeconds ~/ 60;
    int remainingSecondsFinal = remainingSeconds % 60;

    String formattedTime = '';

    if (hours > 0) {
      formattedTime += '${hours.toString().padLeft(2, '0')}:';
    }

    formattedTime += '${minutes.toString().padLeft(2, '0')}:';
    formattedTime += '${remainingSecondsFinal.toString().padLeft(2, '0')}';

    return formattedTime;
  }

  dh() {
    formattedTime = formatSeconds(secondsElapsed);
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
                          textSize:
                              MediaQuery.of(Get.context!).size.height.toInt() *
                                  0.04,
                          hintColor: appRedColor,
                          fontfamily: 'summary',
                        ),
                      ),
                      Flexible(
                        child: CustomSimpleTextField(
                          textSizeValue: true,
                          hintText:
                              '$txtGameTime ${formatTime(secondsElapsed)}',
                          textSize:
                              MediaQuery.of(Get.context!).size.height.toInt() *
                                  0.025,
                          hintColor: appColor,
                          fontfamily: 'Montstreat',
                        ),
                      ),
                      Flexible(
                        child: CustomSimpleTextField(
                          textSizeValue: true,
                          hintText: 'Moves : $score',
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
                            Get.offAll(MemoryGridScreen());
                          },
                          child: Image.asset(
                            appFinish,
                            height: MediaQuery.of(Get.context!)
                                    .size
                                    .height
                                    .toInt() *
                                0.05,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.share,
                              color: Colors.pink,
                            ),
                          ),
                          Flexible(
                            child: GestureDetector(
                              onTap: () {
                                takeScreenshotMethod();
                              },
                              child: CustomSimpleTextField(
                                underLineValue: false,
                                textSizeValue: true,
                                hintText: 'Share With Friends',
                                textSize: MediaQuery.of(Get.context!)
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
  }

  void playAudio() async {
    try {
      await audioPlayer.play(AssetSource(audioPath));
      print('Audio playing');
    } catch (e) {
      print('Error playing audio: $e');
    }
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
              Image.asset(appPause,
                  height: MediaQuery.of(context).size.width * 0.9),
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
                        textSize: MediaQuery.of(context).size.width * 0.060,
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
                              width: MediaQuery.of(context).size.width * 0.5,
                            ),
                            Center(
                              child: CustomSimpleTextField(
                                underLineValue: false,
                                textSizeValue: true,
                                textAlign: TextAlign.center,
                                hintText: txtResume,
                                textSize:
                                    MediaQuery.of(context).size.width * 0.060,
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
                      Get.offAll(MemoryGridScreen());
                    },
                    child: CustomSimpleTextField(
                      hintText: txtExit,
                      textSize: MediaQuery.of(context).size.width * 0.070,
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
  void onClose() {
    animationController.dispose();
    super.onClose();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    timer!.cancel(); // cancel the timer to avoid memory leaks
    // blastController.dispose();
    super.dispose();
  }
}

// For Animal Images
class GameImage {
  List<Card> cardsImage;
  int? firstSelectedIndex;
  int? secondSelectedIndex;

  GameImage({required this.cardsImage});

  bool get isMatched {
    if (firstSelectedIndex != null && secondSelectedIndex != null) {
      return cardsImage[firstSelectedIndex!].id ==
          cardsImage[secondSelectedIndex!].id;
    }
    return false;
  }

  void flipCard(int index) {
    if (!cardsImage[index].isFlipped &&
        (firstSelectedIndex == null || secondSelectedIndex == null)) {
      cardsImage[index].isFlipped = true;
      if (firstSelectedIndex == null) {
        firstSelectedIndex = index;
      } else {
        secondSelectedIndex = index;
      }
    }
  }

  void resetSelectedCards() {
    if (firstSelectedIndex != null && secondSelectedIndex != null) {
      cardsImage[firstSelectedIndex!].isFlipped = false;
      cardsImage[secondSelectedIndex!].isFlipped = false;
    }
    firstSelectedIndex = null;
    secondSelectedIndex = null;
  }

  bool get isGameOver => cardsImage.every((card) => card.isMatched);
}

class Card {
  int id;
  String imageName;
  bool isFlipped;
  bool isMatched;

  Card({
    required this.id,
    required this.imageName,
    this.isFlipped = false,
    this.isMatched = false,
  });
}

// For Numbers

class Game {
  List<CardModel> cards;
  int? firstSelectedIndex;
  int? secondSelectedIndex;

  Game({required this.cards});

  bool get isMatched {
    if (firstSelectedIndex != null && secondSelectedIndex != null) {
      return cards[firstSelectedIndex!].id == cards[secondSelectedIndex!].id;
    }
    return false;
  }

  void flipCard(int index) {
    if (!cards[index].isFlipped &&
        (firstSelectedIndex == null || secondSelectedIndex == null)) {
      cards[index].isFlipped = true;
      if (firstSelectedIndex == null) {
        firstSelectedIndex = index;
      } else {
        secondSelectedIndex = index;
      }
    }
  }

  void resetSelectedCards() {
    cards[firstSelectedIndex!].isFlipped = false;
    cards[secondSelectedIndex!].isFlipped = false;
    firstSelectedIndex = null;
    secondSelectedIndex = null;
  }

  bool get isGameOver => cards.every((card) => card.isMatched);
}

class CardModel {
  final int id;
  bool isFlipped;
  bool isMatched;

  CardModel({required this.id, this.isFlipped = false, this.isMatched = false});
}
