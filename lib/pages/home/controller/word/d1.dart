import 'dart:async';

import 'package:KidsPlan/pages/home/view/word/word_option_list.dart';
import 'package:KidsPlan/sqlite_data/number_game_data/data.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_search_safety/word_search_safety.dart';

import '../../../../color.dart';
import '../../../../custom/simpleText.dart';
import '../../../../custom/take_screenshot.dart';
import '../../../../image.dart';
import '../../../../sqlite_data/word_game_data.dart';
import '../../../../string.dart';

class WordSolveController extends GetxController
    with SingleGetTickerProviderMixin {
  @override
  int numBoxPerRow = 6;
  int wordDone = 0;
  int lastColorIndex = 0;
  int incrementCounter = 1;
  bool doneCheck = false;
  var checkResult = 0.obs;
  Map<int, Color> matchedColors = {};

  void updateCheckResult(int value) {
    checkResult.value = value;
    update(); // Notify GetBuilder to rebuild
  }

  late Color color;
  var colorList = [
    Colors.red,
    Colors.yellow,
    Colors.brown,
    Colors.blue,
    Colors.green, /* Add more colors if needed */
  ];
  late ValueNotifier<List<CrosswordAnswer>> answerList =
      ValueNotifier<List<CrosswordAnswer>>([]);
  ValueNotifier<Map<int, List<Color>>> cellIntersections = ValueNotifier({});

  bool dfCalled = false;
  double padding = 5;
  Size sizeBox = Size.zero;
  int? getNumBoxGrid;
  Size size = MediaQuery.of(Get.context!).size;
  late ValueNotifier<List<List<String>>> listChars;

  // late ValueNotifier<List<CrosswordAnswer>> answerList;
  late ValueNotifier<CurrentDragObj> currentDragObj;
  late ValueNotifier<List<int>> charsDone;

  final AudioPlayer audioPlayer = AudioPlayer();
  final DBWordGame dbWordManager = new DBWordGame();
  final blastController = ConfettiController();

  // String audioPath = 'audio/ping.mp3';
  String audioPath = 'audio/click.mp3';

  int? gridSize;
  int score = 0;
  int? boxLength;
  int moves = 0;
  NumberUserData? userData;
  Timer? timer;
  int secondsElapsed = 0;
  String message = '';

  late List<Color> starColors;
  late List<AnimationController> controllers;
  bool isTimerPaused = false;

  late AnimationController animateController;
  bool isHandlingGesture = false;
  bool isResetGame = false;
  double initialX = 0.0;
  double initialY = 0.0;
  AnimationController? animationControllerBlast;
  int start = 0;

  final AudioPlayer audioPlayerBlast = AudioPlayer();
  String audioPathbBlast = 'audio/four.mp3';

  void playAnimation() async {
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

    getData();
    listChars = ValueNotifier<List<List<String>>>([]);
    answerList = ValueNotifier<List<CrosswordAnswer>>([]);
    currentDragObj = ValueNotifier<CurrentDragObj>(CurrentDragObj());
    charsDone = ValueNotifier<List<int>>([]);
    generateRandomWord();
    if (timer == null || !timer!.isActive) {
      startGame();
    }
    animateController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1),
    );

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
                      timer!.cancel();
                      playAudio();
                      Get.offAll(WordOptionListScreen());
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
      if (Get.arguments["option_game"] != null) {
        getNumBoxGrid = (Get.arguments["option_game"]);

        print(getNumBoxGrid);
      }
    }

    update();
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

  String? formattedTime;

  dh() {
    formattedTime = formatSeconds(secondsElapsed);
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
                          textSize:
                              MediaQuery.of(Get.context!).size.height.toInt() *
                                  0.04,
                          hintColor: appRedColor,
                          fontfamily: 'summary',
                        ),
                      ),
                      // Flexible(
                      //   child: CustomSimpleTextField(
                      //     underLineValue: false,
                      //     textSizeValue: true,
                      //     hintText: 'Moves: ${moves.toString() ?? ""}',
                      //     textSize:
                      //         MediaQuery.of(Get.context!).size.height.toInt() *
                      //             0.025,
                      //     hintColor: appColor,
                      //     fontfamily: 'Montstreat',
                      //   ),
                      // ),
                      Flexible(
                        child: CustomSimpleTextField(
                          underLineValue: false,
                          textSizeValue: true,
                          // hintText: '$txtGameTime $formattedTime',
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
                            Get.offAll(WordOptionListScreen());
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
    } else if (secondsElapsed <= 500) {
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
    } else if (secondsElapsed <= 720) {
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
    } else if (secondsElapsed <= 1000) {
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
    } else if (secondsElapsed <= 15000000) {
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
      WordUserData st = new WordUserData(
          userMoves: moves.toString() ?? "",
          userNames: getNumBoxGrid == 6
              ? 'Easy'
              : getNumBoxGrid == 8
                  ? 'Medium'
                  : 'Hard',
          result: formatTime(secondsElapsed));
      dbWordManager.insertStudent(st).then((value) => {
            print("User Data Add to database $value"),
          });
    } else {}
  }

  final List<String> animalNames = [
    'aardvark',
    'albatross',
    'alligator',
    'alpaca',
    'antelope',
    'armadillo',
    'baboon',
    'badger',
    'bandicoot',
    'barnacle',
    'barracuda',
    'basilisk',
    'bat',
    'beaver',
    'bee',
    'beetle',
    'bison',
    'boar',
    'buffalo',
    'butterfly',
    'buzzard',
    'camel',
    'capybara',
    'caribou',
    'cassowary',
    'cat',
    'caterpillar',
    'catfish',
    'chameleon',
    'cheetah',
    'chicken',
    'chimpanzee',
    'chinchilla',
    'chipmunk',
    'clam',
    'clownfish',
    'cobra',
    'cockatoo',
    'cockroach',
    'cod',
    'coyote',
    'crab',
    'crane',
    'crayfish',
    'crocodile',
    'crow',
    'cuckoo',
    'deer',
    'dingo',
    'dodo',
    'dog',
    'dolphin',
    'donkey',
    'dove',
    'dragonfly',
    'duck',
    'dugong',
    'eagle',
    'eel',
    'elephant',
    'elk',
    'emu',
    'falcon',
    'ferret',
    'finch',
    'firefly',
    'flamingo',
    'flea',
    'fly',
    'fox',
    'frog',
    'gaur',
    'gazelle',
    'gecko',
    'gerbil',
    'gibbon',
    'giraffe',
    'goat',
    'goldfish',
    'goose',
    'gorilla',
    'grasshopper',
    'grouse',
    'guanaco',
    'gull',
    'hamster',
    'hare',
    'hawk',
    'hedgehog',
    'heron',
    'herring',
    'hippopotamus',
    'hornet',
    'horse',
    'human',
    'hummingbird',
    'hyena',
    'ibex',
    'ibis',
    'iguana',
    'jackal',
    'jaguar',
    'jay',
    'jellyfish',
    'kangaroo',
    'kingfisher',
    'koala',
    'komodo dragon',
    'krill',
    'kudu',
    'ladybug',
    'lamprey',
    'lemur',
    'leopard',
    'lion',
    'llama',
    'lobster',
    'locust',
    'loon',
    'loris',
    'louse',
    'lynx',
    'macaw',
    'mackerel',
    'magpie',
    'mallard',
    'manatee',
    'mandrill',
    'marlin',
    'marmoset',
    'marmot',
    'meerkat',
    'mink',
    'mole',
    'mongoose',
    'monkey',
    'moose',
    'mosquito',
    'moth',
    'mouse',
    'mule',
    'narwhal',
    'newt',
    'nightingale',
    'octopus',
    'okapi',
    'opossum',
    'orangutan',
    'ostrich',
    'otter',
    'owl',
    'ox',
    'oyster',
    'panda',
    'panther',
    'parrot',
    'partridge',
    'peafowl',
    'pelican',
    'penguin',
    'pheasant',
    'pig',
    'pigeon',
    'piranha',
    'platypus',
    'polar bear',
    'porcupine',
    'porpoise',
    'prairie dog',
    'quail',
    'quelea',
    'quetzal',
    'rabbit',
    'raccoon',
    'rat',
    'raven',
    'red deer',
    'red panda',
    'reindeer',
    'rhinoceros',
    'rook',
    'salamander',
    'salmon',
    'sand dollar',
    'sandpiper',
    'sardine',
    'scorpion',
    'seahorse',
    'seal',
    'shark',
    'sheep',
    'shrew',
    'shrimp',
    'siamang',
    'silverfish',
    'skink',
    'skunk',
    'sloth',
    'snail',
    'snake',
    'sparrow',
    'spider',
    'squid',
    'squirrel',
    'starfish',
    'stingray',
    'stinkbug',
    'stork',
    'swallow',
    'swan',
    'tapir',
    'tarsier',
    'termite',
    'tiger',
    'toad',
    'trout',
    'turkey',
    'turtle',
    'viper',
    'vulture',
    'walrus',
    'wasp',
    'weasel',
    'whale',
    'wildcat',
    'wolf',
    'wolverine',
    'wombat',
    'woodpecker',
    'worm',
    'wren',
    'yak',
    'zebra',
    'zebu',
    'zonkey',
    'zorilla',
    'zorse'
  ];
  final List<String> birdNames = [
    'albatross',
    'canary',
    'cardinal',
    'cormorant',
    'crow',
    'dove',
    'eagle',
    'egret',
    'falcon',
    'finch',
    'flamingo',
    'goose',
    'hawk',
    'hummingbird',
    'ibis',
    'jay',
    'kingfisher',
    'kite',
    'loon',
    'macaw',
    'magpie',
    'mockingbird',
    'nighthawk',
    'oriole',
    'owl',
    'parakeet',
    'parrot',
    'peacock',
    'pelican',
    'penguin',
    'pheasant',
    'pigeon',
    'quail',
    'raven',
    'robin',
    'seagull',
    'sparrow',
    'starling',
    'swallow',
    'swan',
    'vulture',
    'woodpecker',
    'wren',
    'condor',
    'kiwi',
    'emu',
    'ostrich',
    'toucan',
    'albatross',
    'canary',
    'cardinal',
    'cormorant',
    'crow',
    'dove',
    'eagle',
    'egret',
    'falcon',
    'finch',
    'flamingo',
    'goose',
    'hawk',
    'hummingbird',
    'ibis',
    'jay',
    'kingfisher',
    'kite',
    'loon',
    'macaw',
    'magpie',
    'mockingbird',
    'nighthawk',
    'oriole',
    'owl',
    'parakeet',
    'parrot',
    'peacock',
    'pelican',
    'penguin',
    'pheasant',
    'pigeon',
    'quail',
    'raven',
    'robin',
    'seagull',
    'sparrow',
    'starling',
    'swallow',
    'swan',
    'vulture',
    'woodpecker',
    'wren',
    'condor',
    'kiwi',
    'emu',
    'ostrich',
    'toucan',
    'albatross',
    'canary',
    'cardinal',
    'cormorant',
    'crow',
    'dove',
    'eagle',
    'egret',
    'falcon',
    'finch',
    'flamingo',
    'goose',
    'hawk',
    'hummingbird',
    'ibis',
    'jay',
    'kingfisher',
    'kite',
    'loon',
    'macaw',
    'magpie',
    'mockingbird',
    'nighthawk',
    'oriole',
    'owl',
    'parakeet',
    'parrot',
    'peacock',
    'pelican',
    'penguin',
    'pheasant',
    'pigeon',
    'quail',
    'raven',
    'robin',
    'seagull',
    'sparrow',
    'starling',
    'swallow',
    'swan',
    'vulture',
    'woodpecker',
    'wren',
    'condor',
    'kiwi',
    'emu',
    'ostrich',
    'toucan',
    'albatross',
    'canary',
    'cardinal',
    'cormorant',
    'crow',
    'dove',
    'eagle',
    'egret',
    'falcon',
    'finch',
    'flamingo',
    'goose',
    'hawk',
    'hummingbird',
    'ibis',
    'jay',
    'kingfisher',
    'kite',
    'loon',
    'macaw',
    'magpie',
    'mockingbird',
    'nighthawk',
    'oriole',
    'owl',
    'parakeet',
    'parrot',
    'peacock',
    'pelican',
    'penguin',
    'pheasant',
    'pigeon',
    'quail',
    'raven',
    'robin',
    'seagull',
    'sparrow',
    'starling',
    'swallow',
    'swan',
    'vulture',
    'woodpecker',
    'wren',
    'condor',
    'kiwi',
    'emu',
    'ostrich',
    'toucan',
    'albatross',
    'canary',
    'cardinal',
    'cormorant',
    'crow',
    'dove',
    'eagle',
    'egret',
    'falcon',
    'finch',
    'flamingo',
    'goose',
    'hawk',
    'hummingbird',
    'ibis',
    'jay',
    'kingfisher',
    'kite',
    'loon',
    'macaw',
    'magpie',
    'mockingbird',
    'nighthawk',
    'oriole',
    'owl',
    'parakeet',
    'parrot',
    'peacock',
    'pelican',
    'penguin',
    'pheasant',
    'pigeon',
    'quail',
    'raven',
    'robin',
    'seagull',
    'sparrow',
    'starling',
    'swallow',
    'swan',
    'vulture',
    'woodpecker',
    'wren',
    'condor',
    'kiwi',
    'emu',
    'ostrich',
    'toucan',
    'albatross',
    'canary',
    'cardinal',
    'cormorant',
    'crow',
    'dove',
    'eagle',
    'egret',
    'falcon',
    'finch',
    'flamingo',
    'goose',
    'hawk',
    'hummingbird',
    'ibis',
    'jay',
    'kingfisher',
    'kite',
    'loon',
    'macaw',
    'magpie',
    'mockingbird',
    'nighthawk',
    'oriole',
    'owl',
    'parakeet',
    'parrot',
    'peacock',
    'pelican',
    'penguin',
    'pheasant',
    'pigeon',
    'quail',
    'raven',
    'robin',
    'seagull',
    'sparrow',
    'starling',
    'swallow',
    'swan',
    'vulture',
    'woodpecker',
    'wren',
    'condor',
    'kiwi',
    'emu',
    'ostrich',
    'toucan',
    'albatross',
    'canary',
    'cardinal',
    'cormorant',
    'crow',
    'dove',
    'eagle',
    'egret',
    'falcon',
    'finch',
    'flamingo',
    'goose',
    'hawk',
    'hummingbird',
    'ibis',
    'jay',
    'kingfisher',
    'kite',
    'loon',
    'macaw',
    'magpie',
    'mockingbird',
    'nighthawk',
    'oriole',
    'owl',
    'parakeet',
    'parrot',
    'peacock',
    'pelican',
    'penguin',
    'pheasant',
    'pigeon',
    'quail',
    'raven',
    'robin',
    'seagull',
    'sparrow',
    'starling',
    'swallow',
    'swan',
    'vulture',
    'woodpecker',
    'wren',
    'condor',
    'kiwi',
    'emu',
    'ostrich',
    'toucan',
  ];
  final List<String> fruitNames = [
    'apple',
    'banana',
    'orange',
    'grape',
    'strawberry',
    'watermelon',
    'kiwi',
    'mango',
    'pineapple',
    'pear',
    'peach',
    'plum',
    'cherry',
    'blueberry',
    'raspberry',
    'apricot',
    'lemon',
    'lime',
    'avocado',
    'pomegranate',
    'cranberry',
    'fig',
    'guava',
    'melon',
    'papaya',
    'passion fruit',
    'dragon fruit',
    'lychee',
    'coconut',
    'date',
    'kiwifruit',
    'blackberry',
    'tangerine',
    'nectarine',
    'grapefruit',
    'persimmon',
    'star fruit',
    'cantaloupe',
    'honeydew',
    'pepino',
    'plantain',
    'pomelo',
    'prickly pear',
    'quince',
    'red currant',
    'white currant',
    'gooseberry',
    'mulberry',
    'boysenberry',
    'loganberry',
    'acai berry',
    'ackee',
    'cherimoya',
    'custard apple',
    'soursop',
    'sapodilla',
    'tamarillo',
    'ugli fruit',
    'rambutan',
    'jackfruit',
    'durian',
    'breadfruit',
    'longan',
    'loquat',
    'passionflower',
    'tamarind',
    'kiwano',
    'mangosteen',
    'jabuticaba',
    'sapote',
    'medlar',
    'feijoa',
    'elderberry',
    'horned melon',
    'guava',
    'miracle fruit',
    'pink guava',
    'white sapote',
    'sugar apple',
    'persimmon',
    'water apple',
    'jujube',
    'carambola',
    'carissa',
    'salak',
    'wax jambu',
    'bilimbi',
    'black sapote',
    'blueberry',
    'breadfruit',
    'calamondin',
    'carambola',
    'cherimoya',
    'cloudberry',
    'crab apple',
    'cranberry',
    'currant',
    'damson plum',
    'date',
    'dragonfruit',
    'durian',
    'elderberry',
    'feijoa',
    'fig',
    'goji berry',
    'gooseberry',
    'grape',
    'grapefruit',
    'guava',
    'honeydew',
    'huckleberry',
    'jackfruit',
    'jostaberry',
    'jujube',
    'kiwi',
    'kumquat',
    'lemon',
    'lime',
    'lingonberry',
    'longan',
    'lychee',
    'mango',
    'mangosteen',
    'marionberry',
    'mulberry',
    'nectarine',
    'orange',
    'papaya',
    'passion fruit',
    'pawpaw',
    'peach',
    'pear',
    'persimmon',
    'physalis',
    'pineapple',
    'plumcot',
    'plum',
    'pomegranate',
    'pomelo',
    'quince',
    'raspberry',
    'redcurrant',
    'salmonberry',
    'satsuma',
    'star fruit',
    'strawberry',
    'tamarillo',
    'tamarind',
    'ugli fruit',
    'watermelon',
    'white currant',
    'white sapote',
    'yuzu',
    'acai',
    'ambarella',
    'amaranth fruit',
    'bacaba',
    'barbadine',
    'bearberry',
    'bel fruit',
    'bignay',
    'bilberry',
    'bitter melon',
    'black cherry',
    'blackberry',
    'blackcurrant',
    'blood orange',
    'blueberry',
    'boysenberry',
    'bush tomato',
    'butternut squash',
    'caiapo',
    'camu camu',
    'cantaloupe',
    'cape gooseberry',
    'cavalo',
    'celosia fruit',
    'chayote',
    'chokecherry',
    'chupa chupa',
    'citron',
    'cloudberry',
    'cocoplum',
    'conkerberry',
    'copal',
    'cordia',
    'cranberry',
    'cucumber',
    'cupuaçu',
    'currant',
    'custard apple',
    'damson',
    'date',
    'desert lime',
    'dewberry',
    'durian',
    'eggfruit',
    'elderberry',
    'emblica',
    'feijoa',
    'fig',
    'finger lime',
    'fitweed',
    'fruit salad plant',
    'genip',
    'ginger',
    'gingko',
    'golden raspberry',
    'gooseberry',
    'gourds',
    'granadilla',
    'grape',
    'grapefruit',
    'guama',
    'guarana',
    'guava',
    'hackberry',
    'hala fruit',
    'hog plum',
    'honeyberry',
    'honeydew',
    'horned melon',
    'huito',
    'ilama',
    'indian fig',
    'indian jujube',
    'indian gooseberry',
    'jackfruit',
    'jabuticaba',
    'jambolan',
    'jostaberry',
    'jujube',
    'juniper berry',
    'kakadu plum',
    'kapok',
    'kiwano',
    'kiwifruit',
    'kumquat',
    'lemon',
    'lemon aspen',
    'lemonade berry',
    'lime',
    'loganberry',
    'longan',
    'loquat',
    'lulo',
    'lychee',
    'mabolo',
    'macadamia',
    'mamey sapote',
    'mamoncillo',
    'mango',
    'mangosteen',
    'manila tamarind',
    'maracuja',
    'marang',
    'maypop',
    'medlar',
    'melon pear',
    'monstera deliciosa',
    'mulberry',
    'muscadine',
    'muscadine grape',
    'muscovy pear',
    'myrtle berry',
    'nardoo',
    'nectarine',
    'neem fruit',
    'orange',
    'orangette',
    'orangelo',
    'oregon grape',
    'palm fruit',
    'papaya',
    'paradise nut',
    'passionfruit',
    'pawpaw',
    'peach',
    'peach palm',
    'peanut butter fruit',
    'pear',
    'pepino',
    'pequi',
    'persimmon',
    'physalis',
    'pineapple',
    'pineberry',
    'plantain',
    'plum',
    'plumcot',
    'plum palm',
    'pomegranate',
    'pomelo',
    'prickly pear',
    'purple mangosteen',
    'quince',
    'raisin tree',
    'rambutan',
    'redcurrant',
    'red huckleberry',
    'red mombin',
    'red raspberry',
    'riberry',
    'rose apple',
    'rose hip',
    'rowan',
    'salak',
    'salmonberry',
    'santol',
    'sapodilla',
    'satsuma',
    'soursop',
    'sour cherry',
    'star apple',
    'star fruit'
  ];
  final List<String> vegetableNames = [
    'asparagus',
    'aubergine',
    'artichoke',
    'bell pepper',
    'broccoli',
    'cabbage',
    'carrot',
    'cauliflower',
    'celery',
    'corn',
    'cucumber',
    'eggplant',
    'garlic',
    'green bean',
    'green pea',
    'leek',
    'lettuce',
    'mushroom',
    'onion',
    'potato',
    'pumpkin',
    'radish',
    'spinach',
    'sweet potato',
    'tomato',
    'zucchini',
    'acorn squash',
    'amaranth leaves',
    'anise',
    'arugula',
    'bamboo shoots',
    'bean sprouts',
    'beetroot',
    'bitter gourd',
    'bok choy',
    'borage',
    'broad beans',
    'brussels sprouts',
    'butternut squash',
    'capers',
    'cardoon',
    'cassava',
    'celeriac',
    'chayote',
    'chicory',
    'chili pepper',
    'chinese cabbage',
    'chinese broccoli',
    'chinese cabbage',
    'chinese celery',
    'chinese spinach',
    'collard greens',
    'coriander',
    'courgette',
    'cress',
    'daikon',
    'endive',
    'fennel',
    'fiddlehead fern',
    'ginger',
    'habanero',
    'horseradish',
    'jalapeno',
    'jerusalem artichoke',
    'jicama',
    'kale',
    'kohlrabi',
    'komatsuna',
    'lamb\'s lettuce',
    'land cress',
    'lavender',
    'lemon grass',
    'mizuna',
    'mustard greens',
    'nopales',
    'okra',
    'pak choi',
    'parsley',
    'parsnip',
    'pattypan squash',
    'pea shoots',
    'pepperoncini',
    'portobello mushroom',
    'purslane',
    'radicchio',
    'rampion',
    'rapini',
    'rutabaga',
    'salsify',
    'scallion',
    'shiso',
    'snap pea',
    'snow pea',
    'sorrel',
    'spaghetti squash',
    'spring onion',
    'sugar snap pea',
    'sunchoke',
    'sweetcorn',
    'swiss chard',
    'taro',
    'tatsoi',
    'thai basil',
    'turnip',
    'water chestnut',
    'watercress',
    'yardlong bean',
    'yukon gold potato'
  ];

  List<String> generateRandomWords() {
    // final allWords = nouns.take(100).toList();
    final allWords = getNumBoxGrid == 1
        ? animalNames.take(200).toList()
        : getNumBoxGrid == 2
            ? birdNames.take(200).toList()
            : getNumBoxGrid == 3
                ? vegetableNames.take(200).toList()
                : fruitNames.take(200).toList();
    allWords.shuffle();
    return allWords
        .where((word) => word.length <= 7 && word.length >= 3)
        .take(6)
        .toList();
  }

  List<int> currentWordIndices = [];

  int getWordId(int index) {
    return index ~/ numBoxPerRow;
  }

  void generateRandomWord() {
    final List<String> wl = generateRandomWords();

    // Set the grid size to 6x6
    // numBoxPerRow = getNumBoxGrid!;
    numBoxPerRow = 9;

    final WSSettings ws = WSSettings(
      width: numBoxPerRow,
      height: numBoxPerRow,
      orientations: [
        WSOrientation.horizontal,
        WSOrientation.vertical,
        WSOrientation.verticalUp,
        WSOrientation.horizontalBack,
      ],
    );

    final WordSearchSafety wordSearch = WordSearchSafety();
    final WSNewPuzzle? newPuzzle = wordSearch.newPuzzle(wl, ws);

    if (newPuzzle != null && newPuzzle.errors!.isEmpty) {
      final puzzle = newPuzzle.puzzle!;
      listChars.value = puzzle;
      final WSSolved solved = wordSearch.solvePuzzle(puzzle, wl);
      answerList.value = solved.found!
          .map((solve) => new CrosswordAnswer(solve, numPerRow: numBoxPerRow))
          .toList();
    } else {
      if (newPuzzle == null) {
        print("Error: Puzzle couldn't be generated.");
      } else {
        newPuzzle.errors!.forEach((error) {
          print(error);
        });
      }
    }
  }

  void onDragEnd(PointerUpEvent? event) {
    if (currentDragObj.value.currentDragLine.isEmpty) return;
    currentDragObj.value.currentDragLine.clear();
    currentDragObj.notifyListeners();

    // Check if all words are found
    if (answerList.value.every((answer) => answer.done)) {
      if (!isResetGame) {
        isResetGame = true;
        update();

        Future.delayed(Duration(seconds: 4), () {
          resetGame();
          isResetGame = false;
          update();
        });

        score++;
        if (score == 2) {
          isResetGame = false;
          update();
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
          start = 1;
          playAnimation();
          dh();
          update();
        } else {
          return null;
        }
      }
    }
  }

  void resetGame() {
    charsDone.value.clear();
    charsDone.notifyListeners();
    currentDragObj.value = CurrentDragObj();
    currentDragObj.notifyListeners();
    generateRandomWord();
    update();
  }

  void onDragUpdate(PointerMoveEvent event) {
    generateLineOnDrag(event);

    int indexFound = answerList.value.indexWhere((answer) {
      return answer.answerLines.join("-") ==
          currentDragObj.value.currentDragLine.join("-");
    });

    if (indexFound >= 0) {
      answerList.value[indexFound].done = true;
      answerList.value[indexFound].color =
          colorList[wordDone % colorList.length];
      charsDone.value.addAll(answerList.value[indexFound].answerLines);

      for (int cell in answerList.value[indexFound].answerLines) {
        cellIntersections.value[cell] ??= [];
        cellIntersections.value[cell]!.add(answerList.value[indexFound].color);
      }
      cellIntersections.notifyListeners();
      charsDone.notifyListeners();
      answerList.notifyListeners();

      wordDone++;
      print(wordDone);
      update();

      onDragEnd(null);
    }
  }

  // void onDragUpdate(PointerMoveEvent event) {
  //   generateLineOnDrag(event);
  //
  //   int indexFound = answerList.value.indexWhere((answer) {
  //     // return answer
  //     return answer.answerLines.join("-") ==
  //         currentDragObj.value.currentDragLine.join("-");
  //   });
  //
  //   if (indexFound >= 0) {
  //     answerList.value[indexFound].done = true;
  //     charsDone.value.addAll(answerList.value[indexFound].answerLines);
  //     charsDone.notifyListeners();
  //     answerList.notifyListeners();
  //    // answerList.value[indexFound].color = wordColors[wordDone % wordColors.length];
  //
  //    wordDone++;
  //    print(wordDone);
  //       update();
  //
  //     onDragEnd(null);
  //   }
  // }

  int calculateIndexBasePosLocal(Offset localPosition) {
    double maxSizeBox =
        ((sizeBox.width - (numBoxPerRow - 1) * padding) / numBoxPerRow);

    if (localPosition.dy > sizeBox.width || localPosition.dx > sizeBox.width)
      return -1;

    int x = 0, y = 0;
    double yAxis = 0, xAxis = 0;
    double yAxisStart = 0, xAxisStart = 0;

    for (var i = 0; i < numBoxPerRow; i++) {
      xAxisStart = xAxis;
      xAxis += maxSizeBox +
          (i == 0 || i == (numBoxPerRow - 1) ? padding / 2 : padding);
      if (xAxisStart < localPosition.dx && xAxis > localPosition.dx) {
        x = i;
        break;
      }
    }

    for (var i = 0; i < numBoxPerRow; i++) {
      yAxisStart = yAxis;
      yAxis += maxSizeBox +
          (i == 0 || i == (numBoxPerRow - 1) ? padding / 2 : padding);
      if (yAxisStart < localPosition.dy && yAxis > localPosition.dy) {
        y = i;
        break;
      }
    }

    return y * numBoxPerRow + x;
  }

  void generateLineOnDrag(PointerMoveEvent event) {
    if (currentDragObj.value.currentDragLine.isEmpty) {
      currentDragObj.value.currentDragLine = [];
    }

    int indexBase = calculateIndexBasePosLocal(event.localPosition);

    if (indexBase >= 0) {
      if (currentDragObj.value.currentDragLine.length >= 2) {
        WSOrientation? wsOrientation;

        if (currentDragObj.value.currentDragLine[0] % numBoxPerRow ==
            currentDragObj.value.currentDragLine[1] % numBoxPerRow)
          wsOrientation = WSOrientation.vertical;
        else if (currentDragObj.value.currentDragLine[0] ~/ numBoxPerRow ==
            currentDragObj.value.currentDragLine[1] ~/ numBoxPerRow)
          wsOrientation = WSOrientation.horizontal;

        if (wsOrientation == WSOrientation.horizontal &&
            indexBase ~/ numBoxPerRow !=
                currentDragObj.value.currentDragLine[1] ~/ numBoxPerRow) {
          onDragEnd(null);
        } else if (wsOrientation == WSOrientation.vertical &&
            indexBase % numBoxPerRow !=
                currentDragObj.value.currentDragLine[1] % numBoxPerRow) {
          onDragEnd(null);
        } else if (wsOrientation == null) {
          onDragEnd(null);
        }
      }

      if (!currentDragObj.value.currentDragLine.contains(indexBase))
        currentDragObj.value.currentDragLine.add(indexBase);
      else if (currentDragObj.value.currentDragLine.length >= 2 &&
          currentDragObj.value.currentDragLine[
                  currentDragObj.value.currentDragLine.length - 2] ==
              indexBase) onDragEnd(null);
    }
    currentDragObj.notifyListeners();
  }

  void onDragStart(int indexArray) {
    List<CrosswordAnswer> indexSelecteds = answerList.value
        .where((answer) => answer.indexArray == indexArray)
        .toList();

    if (indexSelecteds.isEmpty) return;

    currentDragObj.value.indexArrayOnTouch = indexArray;
    currentDragObj.notifyListeners();
  }
}

class CurrentDragObj {
  late Offset currentDragPos = Offset.zero;
  late Offset currentTouch;
  late int indexArrayOnTouch;
  List<int> currentDragLine = [];

  CurrentDragObj({
    this.indexArrayOnTouch = 0,
    this.currentTouch = Offset.zero,
  });
}

class CrosswordAnswer {
  bool done = false;
  late int indexArray;
  WSLocation wsLocation;
  late List<int> answerLines;
  Color color = Colors.transparent; // Add this line

  CrosswordAnswer(this.wsLocation, {required int numPerRow}) {
    this.indexArray = this.wsLocation.y * numPerRow + this.wsLocation.x;
    generateAnswerLine(numPerRow);
  }

  void generateAnswerLine(int numperRow) {
    this.answerLines = <int>[];
    this.answerLines.addAll(List<int>.generate(this.wsLocation.overlap,
        (index) => generateIndexBaseOnAxis(this.wsLocation, index, numperRow)));
  }

  int generateIndexBaseOnAxis(WSLocation wsLocation, int i, int numPerRow) {
    int x = wsLocation.x, y = wsLocation.y;

    if (wsLocation.orientation == WSOrientation.horizontal ||
        wsLocation.orientation == WSOrientation.horizontalBack)
      x = (wsLocation.orientation == WSOrientation.horizontal) ? x + i : x - i;
    else
      y = (wsLocation.orientation == WSOrientation.vertical) ? y + i : y - i;

    return x + y * numPerRow;
  }
}

// class CrosswordAnswer {
//   bool done = false;
//   late int indexArray;
//   WSLocation wsLocation;
//   late List<int> answerLines;
//
//   CrosswordAnswer(this.wsLocation, {required int numPerRow}) {
//     this.indexArray = this.wsLocation.y * numPerRow + this.wsLocation.x;
//     generateAnswerLine(numPerRow);
//   }
//
//   void generateAnswerLine(int numperRow) {
//     this.answerLines = <int>[];
//     this.answerLines.addAll(List<int>.generate(this.wsLocation.overlap,
//         (index) => generateIndexBaseOnAxis(this.wsLocation, index, numperRow)));
//   }
//
//   int generateIndexBaseOnAxis(WSLocation wsLocation, int i, int numPerRow) {
//     int x = wsLocation.x, y = wsLocation.y;
//
//     if (wsLocation.orientation == WSOrientation.horizontal ||
//         wsLocation.orientation == WSOrientation.horizontalBack)
//       x = (wsLocation.orientation == WSOrientation.horizontal) ? x + i : x - i;
//     else
//       y = (wsLocation.orientation == WSOrientation.vertical) ? y + i : y - i;
//
//     return x + y * numPerRow;
//   }
// }

class OverlappingCellPainter extends CustomPainter {
  final List<Color> colors;

  OverlappingCellPainter(this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    if (colors.isEmpty) return;

    Paint paint = Paint();
    double stripeHeight = size.height / colors.length;

    for (int i = 0; i < colors.length; i++) {
      paint.color = colors[i];
      canvas.drawRect(
        Rect.fromLTWH(0, i * stripeHeight, size.width, stripeHeight),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
