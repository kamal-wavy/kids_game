// import 'dart:async';
//
// import 'package:KidsPlan/pages/home/view/word/word_option_list.dart';
// import 'package:KidsPlan/sqlite_data/number_game_data/data.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:confetti/confetti.dart';
// import 'package:english_words/english_words.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:word_search_safety/word_search_safety.dart';
//
// import '../../../../color.dart';
// import '../../../../custom/simpleText.dart';
// import '../../../../custom/take_screenshot.dart';
// import '../../../../image.dart';
// import '../../../../sqlite_data/word_game_data.dart';
// import '../../../../string.dart';
//
// class WordSolveController extends GetxController
//     with SingleGetTickerProviderMixin {
//   @override
//   int numBoxPerRow = 6;
//   double padding = 5;
//   Size sizeBox = Size.zero;
//   int? getNumBoxGrid;
//   Size size = MediaQuery.of(Get.context!).size;
//   late ValueNotifier<List<List<String>>> listChars;
//   late ValueNotifier<List<CrosswordAnswer>> answerList;
//   late ValueNotifier<CurrentDragObj> currentDragObj;
//   late ValueNotifier<List<int>> charsDone;
//
//   final AudioPlayer audioPlayer = AudioPlayer();
//   final DBWordGame dbWordManager = new DBWordGame();
//   final blastController = ConfettiController();
//
//   // String audioPath = 'audio/ping.mp3';
//   String audioPath = 'audio/click.mp3';
//
//   int? gridSize;
//   int score = 0;
//   int? boxLength;
//   int moves = 0;
//   NumberUserData? userData;
//   Timer? timer;
//   int secondsElapsed = 0;
//   String message = '';
//
//   late List<Color> starColors;
//   late List<AnimationController> controllers;
//   bool isTimerPaused = false;
//
//   late AnimationController animateController;
//   bool isHandlingGesture = false;
//   double initialX = 0.0;
//   double initialY = 0.0;
//   AnimationController? animationControllerBlast;
//   int start = 0;
//
//   final AudioPlayer audioPlayerBlast = AudioPlayer();
//   String audioPathbBlast = 'audio/four.mp3';
//
//   void playAnimation() async {
//     animationControllerBlast!.forward(from: 0.0);
//     await audioPlayerBlast.play(AssetSource(audioPathbBlast));
//
//     print('Audio playing  blast 1414');
//   }
//
//   void takeScreenshotMethod() {
//     final screnCpntroller = Get.put(ScreenshotController());
//     screnCpntroller.takeScreenshotAndShare();
//   }
//
//   @override
//   void onInit() {
//     super.onInit();
//
//     getData();
//     listChars = ValueNotifier<List<List<String>>>([]);
//     answerList = ValueNotifier<List<CrosswordAnswer>>([]);
//     currentDragObj = ValueNotifier<CurrentDragObj>(CurrentDragObj());
//     charsDone = ValueNotifier<List<int>>([]);
//     generateRandomWord();
//     if (timer == null || !timer!.isActive) {
//       startGame();
//     }
//     animateController = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 1),
//     );
//
//     animationControllerBlast = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: 10), // Adjust the duration as needed
//     );
//   }
//
//   void startGame() {
//     secondsElapsed = 0;
//
//     startTimer();
//     update();
//   }
//
//   void stopTimer() {
//     if (timer != null) {
//       timer!.cancel();
//     }
//   }
//
//   void startTimer() {
//     timer = Timer.periodic(Duration(seconds: 1), (timer) {
//       if (!isTimerPaused) {
//         secondsElapsed++;
//         update();
//       }
//     });
//   }
//
//   String formatTime(int seconds) {
//     int hours = seconds ~/ 3600;
//     int minutes = (seconds % 3600) ~/ 60;
//     int remainingSeconds = seconds % 60;
//
//     String hoursStr = hours.toString().padLeft(2, '0');
//     String minutesStr = minutes.toString().padLeft(2, '0');
//     String secondsStr = remainingSeconds.toString().padLeft(2, '0');
//
//     return '$hoursStr:$minutesStr:$secondsStr';
//   }
//
//   void togglePlayPause() {
//     isTimerPaused = !isTimerPaused;
//     update();
//
//     if (isTimerPaused) {
//       timer!.cancel();
//       _showResumePopup();
//     } else {
//       startTimer();
//     }
//   }
//
//   void _showResumePopup() {
//     showDialog(
//       context: Get.context!,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return WillPopScope(
//           onWillPop: () async {
//             return false;
//           },
//           child: Stack(
//             alignment: Alignment.center,
//             children: [
//               Image.asset(appPause,
//                   height: MediaQuery.of(context).size.width * 0.9),
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(top: 10.0),
//                     child: SizedBox(
//                       width: MediaQuery.of(context).size.width * 0.6,
//                       // height: MediaQuery.of(context).size.height * 0.1,
//                       child: CustomSimpleTextField(
//                         textAlign: TextAlign.center,
//                         hintText: txtGameDonotResume,
//                         textSize: MediaQuery.of(context).size.width * 0.060,
//                         hintColor: blackColor,
//                         fontfamily: 'summary',
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(5.0),
//                     child: GestureDetector(
//                         onTap: () {
//                           playAudio();
//                           Get.back();
//                           togglePlayPause();
//                         },
//                         child: Stack(
//                           alignment: Alignment.center,
//                           children: [
//                             Image.asset(
//                               appbtn,
//                               width: MediaQuery.of(context).size.width * 0.5,
//                             ),
//                             Center(
//                               child: CustomSimpleTextField(
//                                 underLineValue: false,
//                                 textSizeValue: true,
//                                 textAlign: TextAlign.center,
//                                 hintText: txtResume,
//                                 textSize:
//                                     MediaQuery.of(context).size.width * 0.060,
//                                 hintColor: Colors.white,
//                                 fontfamily: 'summary',
//                               ),
//                             ),
//                           ],
//                         )),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       timer!.cancel();
//                       playAudio();
//                       Get.offAll(WordOptionListScreen());
//                     },
//                     child: CustomSimpleTextField(
//                       hintText: txtExit,
//                       textSize: MediaQuery.of(context).size.width * 0.070,
//                       hintColor: appRedColor,
//                       fontfamily: 'summary',
//                     ),
//                   ),
//                 ],
//               )
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   void playAudio() async {
//     try {
//       await audioPlayer.play(AssetSource(audioPath));
//       print('Audio playing');
//     } catch (e) {
//       print('Error playing audio: $e');
//     }
//   }
//
//   getData() {
//     if (Get.arguments != null) {
//       if (Get.arguments["option_game"] != null) {
//         getNumBoxGrid = (Get.arguments["option_game"]);
//
//         print(getNumBoxGrid);
//       }
//     }
//
//     update();
//   }
//
//   String formatSeconds(int seconds) {
//     int hours = seconds ~/ 3600;
//     int remainingSeconds = seconds % 3600;
//     int minutes = remainingSeconds ~/ 60;
//     int remainingSecondsFinal = remainingSeconds % 60;
//
//     String formattedTime = '';
//
//     if (hours > 0) {
//       formattedTime += '${hours.toString().padLeft(2, '0')}:';
//     }
//
//     formattedTime += '${minutes.toString().padLeft(2, '0')}:';
//     formattedTime += '${remainingSecondsFinal.toString().padLeft(2, '0')}';
//
//     return formattedTime;
//   }
//
//   String? formattedTime;
//
//   dh() {
//     formattedTime = formatSeconds(secondsElapsed);
//     blastController.play();
//     return showDialog(
//       context: Get.context!,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return WillPopScope(
//           onWillPop: () async {
//             return false;
//           },
//           child: Center(
//             child: Stack(
//               alignment: Alignment.center,
//               children: [
//                 Image.asset(appPopup),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 70.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       showStar(),
//                       Flexible(
//                         child: CustomSimpleTextField(
//                           hintText: txtGameOver,
//                           textSize:
//                               MediaQuery.of(Get.context!).size.height.toInt() *
//                                   0.04,
//                           hintColor: appRedColor,
//                           fontfamily: 'summary',
//                         ),
//                       ),
//                       // Flexible(
//                       //   child: CustomSimpleTextField(
//                       //     underLineValue: false,
//                       //     textSizeValue: true,
//                       //     hintText: 'Moves: ${moves.toString() ?? ""}',
//                       //     textSize:
//                       //         MediaQuery.of(Get.context!).size.height.toInt() *
//                       //             0.025,
//                       //     hintColor: appColor,
//                       //     fontfamily: 'Montstreat',
//                       //   ),
//                       // ),
//                       Flexible(
//                         child: CustomSimpleTextField(
//                           underLineValue: false,
//                           textSizeValue: true,
//                           // hintText: '$txtGameTime $formattedTime',
//                           hintText:
//                               '$txtGameTime ${formatTime(secondsElapsed)}',
//                           textSize:
//                               MediaQuery.of(Get.context!).size.height.toInt() *
//                                   0.025,
//                           hintColor: appColor,
//                           fontfamily: 'Montstreat',
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(10.0),
//                         child: GestureDetector(
//                           onTap: () {
//                             playAudio();
//                             blastController.stop();
//                             Get.offAll(WordOptionListScreen());
//                           },
//                           child: Image.asset(
//                             appFinish,
//                             height: MediaQuery.of(Get.context!)
//                                     .size
//                                     .height
//                                     .toInt() *
//                                 0.05,
//                           ),
//                         ),
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Icon(
//                               Icons.share,
//                               color: Colors.pink,
//                             ),
//                           ),
//                           Flexible(
//                             child: GestureDetector(
//                               onTap: () {
//                                 takeScreenshotMethod();
//                               },
//                               child: CustomSimpleTextField(
//                                 underLineValue: false,
//                                 textSizeValue: true,
//                                 hintText: 'Share With Friends',
//                                 textSize: MediaQuery.of(Get.context!)
//                                         .size
//                                         .height
//                                         .toInt() *
//                                     0.020,
//                                 hintColor: appColor,
//                                 fontfamily: 'Montstreat',
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   startAnimation() async {
//     for (int i = 0; i < 5; i++) {
//       await Future.delayed(const Duration(milliseconds: 300));
//       controllers[i].forward();
//
//       starColors[i] = Colors.amber;
//       update();
//     }
//   }
//
//   List startList = [
//     appStarLeft1,
//     appStarLeft2,
//     appStar1,
//     appStarRight1,
//     appStarRight2,
//   ];
//
//   showStar() {
//     if (secondsElapsed <= 300) {
//       return Padding(
//         padding: const EdgeInsets.only(top: 20.0),
//         child: SizedBox(
//           height: MediaQuery.of(Get.context!).size.height.toInt() * 0.06,
//           width: MediaQuery.of(Get.context!).size.width,
//           child: Stack(
//             children: [
//               // Display gray stars at the bottom
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: List.generate(startList.length, (index) {
//                   return Padding(
//                       padding: EdgeInsets.all(4.0),
//                       child: Center(
//                           child: Image.asset(
//                         startList[index],
//                         color: greyColor,
//                       )));
//                 }),
//               ),
//               // Display amber stars with SlideTransition
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: List.generate(startList.length, (index) {
//                   return SlideTransition(
//                     position: Tween<Offset>(
//                       begin: const Offset(1, -5.0),
//                       end: Offset.zero,
//                     ).animate(controllers[index]),
//                     child: Padding(
//                         padding: EdgeInsets.all(4.0),
//                         child: Center(
//                             child: Image.asset(
//                           startList[index],
//                         ))),
//                   );
//                 }),
//               ),
//             ],
//           ),
//         ),
//       );
//     } else if (secondsElapsed <= 500) {
//       return Padding(
//         padding: const EdgeInsets.only(top: 20.0),
//         child: SizedBox(
//           height: MediaQuery.of(Get.context!).size.height.toInt() * 0.06,
//           width: MediaQuery.of(Get.context!).size.width,
//           child: Stack(
//             children: [
//               // Display gray stars at the bottom
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: List.generate(startList.length, (index) {
//                   return Padding(
//                       padding: EdgeInsets.all(4.0),
//                       child: Center(
//                           child: Image.asset(
//                         startList[index],
//                         color: greyColor,
//                       )));
//                 }),
//               ),
//               // Display amber stars with SlideTransition
//               Padding(
//                 padding: const EdgeInsets.only(right: 33.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: List.generate(startList.length - 1, (index) {
//                     return SlideTransition(
//                       position: Tween<Offset>(
//                         begin: const Offset(1, -5.0),
//                         end: Offset.zero,
//                       ).animate(controllers[index]),
//                       child: Padding(
//                         padding: EdgeInsets.all(4.0),
//                         child: Center(child: Image.asset(startList[index])),
//                       ),
//                     );
//                   }),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     } else if (secondsElapsed <= 720) {
//       return Padding(
//         padding: const EdgeInsets.only(top: 20.0),
//         child: SizedBox(
//           height: MediaQuery.of(Get.context!).size.height.toInt() * 0.06,
//           width: MediaQuery.of(Get.context!).size.width,
//           child: Stack(
//             children: [
//               // Display gray stars at the bottom
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: List.generate(startList.length, (index) {
//                   return Padding(
//                       padding: EdgeInsets.all(4.0),
//                       child: Center(
//                           child: Image.asset(
//                         startList[index],
//                         color: greyColor,
//                       )));
//                 }),
//               ),
//               // Display amber stars with SlideTransition
//               Padding(
//                   padding: const EdgeInsets.only(right: 67.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: List.generate(startList.length - 2, (index) {
//                       return SlideTransition(
//                         position: Tween<Offset>(
//                           begin: const Offset(1, -5.0),
//                           end: Offset.zero,
//                         ).animate(controllers[index]),
//                         child: Padding(
//                             padding: EdgeInsets.all(4.0),
//                             child:
//                                 Center(child: Image.asset(startList[index]))),
//                       );
//                     }),
//                   )),
//             ],
//           ),
//         ),
//       );
//     } else if (secondsElapsed <= 1000) {
//       return Padding(
//         padding: const EdgeInsets.only(top: 20.0),
//         child: SizedBox(
//           height: MediaQuery.of(Get.context!).size.height.toInt() * 0.06,
//           width: MediaQuery.of(Get.context!).size.width,
//           child: Stack(
//             children: [
//               // Display gray stars at the bottom
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: List.generate(startList.length, (index) {
//                   return Padding(
//                       padding: EdgeInsets.all(4.0),
//                       child: Center(
//                           child: Image.asset(
//                         startList[index],
//                         color: greyColor,
//                       )));
//                 }),
//               ),
//               // Display amber stars with SlideTransition
//               Padding(
//                   padding: const EdgeInsets.only(right: 115.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: List.generate(startList.length - 3, (index) {
//                       return SlideTransition(
//                         position: Tween<Offset>(
//                           begin: const Offset(1, -5.0),
//                           end: Offset.zero,
//                         ).animate(controllers[index]),
//                         child: Padding(
//                             padding: EdgeInsets.all(4.0),
//                             child:
//                                 Center(child: Image.asset(startList[index]))),
//                       );
//                     }),
//                   )),
//             ],
//           ),
//         ),
//       );
//     } else if (secondsElapsed <= 15000000) {
//       return Padding(
//         padding: const EdgeInsets.only(top: 20.0),
//         child: SizedBox(
//           height: MediaQuery.of(Get.context!).size.height.toInt() * 0.06,
//           width: MediaQuery.of(Get.context!).size.width,
//           child: Stack(
//             children: [
//               // Display gray stars at the bottom
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: List.generate(startList.length, (index) {
//                   return Padding(
//                       padding: EdgeInsets.all(4.0),
//                       child: Center(
//                           child: Image.asset(
//                         startList[index],
//                         color: greyColor,
//                       )));
//                 }),
//               ),
//               // Display amber stars with SlideTransition
//               Padding(
//                   padding: const EdgeInsets.only(right: 150.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: List.generate(startList.length - 4, (index) {
//                       return SlideTransition(
//                         position: Tween<Offset>(
//                           begin: const Offset(1, -5.0),
//                           end: Offset.zero,
//                         ).animate(controllers[index]),
//                         child: Padding(
//                             padding: EdgeInsets.all(4.0),
//                             child:
//                                 Center(child: Image.asset(startList[index]))),
//                       );
//                     }),
//                   )),
//             ],
//           ),
//         ),
//       );
//     }
//   }
//
//   @override
//   void dispose() {
//     audioPlayer.dispose();
//     timer!.cancel();
//     controllers.forEach((controller) => controller.dispose());
//     secondsElapsed = 0;
//     animateController.dispose();
//     blastController.dispose();
//     super.dispose();
//   }
//
//   @override
//   void onReady() {
//     super.onReady();
//   }
//
//   void submitUser() {
//     if (userData == null) {
//       WordUserData st = new WordUserData(
//           userMoves: moves.toString() ?? "",
//           userNames: getNumBoxGrid == 6
//               ? 'Easy'
//               : getNumBoxGrid == 8
//                   ? 'Medium'
//                   : 'Hard',
//           result: formatTime(secondsElapsed));
//       dbWordManager.insertStudent(st).then((value) => {
//             print("User Data Add to database $value"),
//           });
//     } else {}
//   }
//
//   List<String> generateRandomWords() {
//     final allWords = nouns.take(100).toList();
//     allWords.shuffle();
//     return allWords
//         .where((word) => (getNumBoxGrid == 6
//                 ? word.length <= 4 && word.length >= 3
//                 : getNumBoxGrid == 8
//                     ? word.length <= 6 && word.length >= 5
//                     : word.length <= 7 && word.length >= 6)
//             // word.length <=
//             // (getNumBoxGrid == 6
//             //     ? 5
//             //     : getNumBoxGrid == 8
//             //         ? 6
//             //         : 7)
//             )
//         .take(6)
//         .toList();
//   }
//
//   void generateRandomWord() {
//     final List<String> wl = generateRandomWords();
//
//     // Set the grid size to 6x6
//     numBoxPerRow = getNumBoxGrid!;
//     // numBoxPerRow = 8;
//
//     final WSSettings ws = WSSettings(
//       width: numBoxPerRow,
//       height: numBoxPerRow,
//       orientations: [
//         WSOrientation.horizontal,
//         WSOrientation.vertical,
//       ],
//     );
//
//     final WordSearchSafety wordSearch = WordSearchSafety();
//     final WSNewPuzzle? newPuzzle = wordSearch.newPuzzle(wl, ws);
//
//     if (newPuzzle != null && newPuzzle.errors!.isEmpty) {
//       final puzzle = newPuzzle.puzzle!;
//       listChars.value = puzzle;
//       final WSSolved solved = wordSearch.solvePuzzle(puzzle, wl);
//       answerList.value = solved.found!
//           .map((solve) => new CrosswordAnswer(solve, numPerRow: numBoxPerRow))
//           .toList();
//     } else {
//       if (newPuzzle == null) {
//         print("Error: Puzzle couldn't be generated.");
//       } else {
//         newPuzzle.errors!.forEach((error) {
//           print(error);
//         });
//       }
//     }
//   }
//
//   void onDragEnd(PointerUpEvent? event) {
//     if (currentDragObj.value.currentDragLine.isEmpty) return;
//     currentDragObj.value.currentDragLine.clear();
//     currentDragObj.notifyListeners();
//
//     // Check if all words are found
//     if (answerList.value.every((answer) => answer.done)) {
//       resetGame();
//       score++;
//       if (score == 2) {
//         stopTimer();
//
//         starColors = List.generate(5, (index) => Colors.grey);
//         controllers = List.generate(5, (index) {
//           return AnimationController(
//             vsync: this,
//             duration: const Duration(milliseconds: 500),
//           );
//         });
//         startAnimation();
//         submitUser();
//         start = 1;
//         playAnimation();
//         dh();
//         update();
//       }
//     }
//   }
//
//   void resetGame() {
//     charsDone.value.clear();
//     charsDone.notifyListeners();
//     currentDragObj.value = CurrentDragObj();
//     currentDragObj.notifyListeners();
//     generateRandomWord();
//     update();
//   }
//
//   void onDragUpdate(PointerMoveEvent event) {
//     generateLineOnDrag(event);
//
//     int indexFound = answerList.value.indexWhere((answer) {
//       // return answer
//       return answer.answerLines.join("-") ==
//           currentDragObj.value.currentDragLine.join("-");
//     });
//
//     if (indexFound >= 0) {
//       answerList.value[indexFound].done = true;
//       charsDone.value.addAll(answerList.value[indexFound].answerLines);
//       charsDone.notifyListeners();
//       answerList.notifyListeners();
//       onDragEnd(null);
//     }
//   }
//
//   int calculateIndexBasePosLocal(Offset localPosition) {
//     double maxSizeBox =
//         ((sizeBox.width - (numBoxPerRow - 1) * padding) / numBoxPerRow);
//
//     if (localPosition.dy > sizeBox.width || localPosition.dx > sizeBox.width)
//       return -1;
//
//     int x = 0, y = 0;
//     double yAxis = 0, xAxis = 0;
//     double yAxisStart = 0, xAxisStart = 0;
//
//     for (var i = 0; i < numBoxPerRow; i++) {
//       xAxisStart = xAxis;
//       xAxis += maxSizeBox +
//           (i == 0 || i == (numBoxPerRow - 1) ? padding / 2 : padding);
//       if (xAxisStart < localPosition.dx && xAxis > localPosition.dx) {
//         x = i;
//         break;
//       }
//     }
//
//     for (var i = 0; i < numBoxPerRow; i++) {
//       yAxisStart = yAxis;
//       yAxis += maxSizeBox +
//           (i == 0 || i == (numBoxPerRow - 1) ? padding / 2 : padding);
//       if (yAxisStart < localPosition.dy && yAxis > localPosition.dy) {
//         y = i;
//         break;
//       }
//     }
//
//     return y * numBoxPerRow + x;
//   }
//
//   void generateLineOnDrag(PointerMoveEvent event) {
//     if (currentDragObj.value.currentDragLine.isEmpty) {
//       currentDragObj.value.currentDragLine = [];
//     }
//
//     int indexBase = calculateIndexBasePosLocal(event.localPosition);
//
//     if (indexBase >= 0) {
//       if (currentDragObj.value.currentDragLine.length >= 2) {
//         WSOrientation? wsOrientation;
//
//         if (currentDragObj.value.currentDragLine[0] % numBoxPerRow ==
//             currentDragObj.value.currentDragLine[1] % numBoxPerRow)
//           wsOrientation = WSOrientation.vertical;
//         else if (currentDragObj.value.currentDragLine[0] ~/ numBoxPerRow ==
//             currentDragObj.value.currentDragLine[1] ~/ numBoxPerRow)
//           wsOrientation = WSOrientation.horizontal;
//
//         if (wsOrientation == WSOrientation.horizontal &&
//             indexBase ~/ numBoxPerRow !=
//                 currentDragObj.value.currentDragLine[1] ~/ numBoxPerRow) {
//           onDragEnd(null);
//         } else if (wsOrientation == WSOrientation.vertical &&
//             indexBase % numBoxPerRow !=
//                 currentDragObj.value.currentDragLine[1] % numBoxPerRow) {
//           onDragEnd(null);
//         } else if (wsOrientation == null) {
//           onDragEnd(null);
//         }
//       }
//
//       if (!currentDragObj.value.currentDragLine.contains(indexBase))
//         currentDragObj.value.currentDragLine.add(indexBase);
//       else if (currentDragObj.value.currentDragLine.length >= 2 &&
//           currentDragObj.value.currentDragLine[
//                   currentDragObj.value.currentDragLine.length - 2] ==
//               indexBase) onDragEnd(null);
//     }
//     currentDragObj.notifyListeners();
//   }
//
//   void onDragStart(int indexArray) {
//     List<CrosswordAnswer> indexSelecteds = answerList.value
//         .where((answer) => answer.indexArray == indexArray)
//         .toList();
//
//     if (indexSelecteds.isEmpty) return;
//
//     currentDragObj.value.indexArrayOnTouch = indexArray;
//     currentDragObj.notifyListeners();
//   }
// }
//
// class CurrentDragObj {
//   late Offset currentDragPos = Offset.zero;
//   late Offset currentTouch;
//   late int indexArrayOnTouch;
//   List<int> currentDragLine = [];
//
//   CurrentDragObj({
//     this.indexArrayOnTouch = 0,
//     this.currentTouch = Offset.zero,
//   });
// }
//
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
