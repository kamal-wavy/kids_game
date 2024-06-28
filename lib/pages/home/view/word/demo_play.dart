import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../../color.dart';
import '../../../../custom/simpleText.dart';
import '../../../../image.dart';
import '../../controller/word/d1.dart';

class WordGameScreen extends GetView<WordSolveController> {
  @override
  Widget build(BuildContext context) {
    Get.put(WordSolveController());
    return WillPopScope(
      onWillPop: () async {
        controller.togglePlayPause();
        return true;
        // return false;
      },
      child: GetBuilder<WordSolveController>(
        init: WordSolveController(),
        builder: (context) {
          return Scaffold(
            body: _bodyWidget(controller),
          );
        },
      ),
    );
  }

  _bodyWidget(WordSolveController controller) {
    return Stack(
      children: [
        Image.asset(
          appselectbg,
          fit: BoxFit.fill,
          height: double.infinity,
          width: double.infinity,
        ),
        SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller.playAudio();
                        controller.togglePlayPause();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.pink,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Icon(
                            controller.isTimerPaused
                                ? Icons.play_arrow
                                : Icons.pause,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 150,
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          Positioned(
                            left: 50,
                            // Adjust the distance between the circle and text
                            child: Container(
                              width: 100,
                              margin: EdgeInsets.zero,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                                color: Colors.pink,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Center(
                                    child: CustomSimpleTextField(
                                  textSizeValue: true,
                                  hintText: controller
                                      .formatTime(controller.secondsElapsed),
                                  hintColor: Colors.white,
                                  textSize: 15,
                                  fontfamily: 'Montstreat',
                                )),
                              ),
                            ),
                          ),
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.amber,
                            backgroundImage: AssetImage(appalarm),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.playAudio();
                        showDialogBox(controller);
                      },
                      child: Image.asset(appTips),
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 15, left: 15, right: 15),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      dd(controller),
                      controller.isResetGame == true
                          ?
                          // Positioned.fill(
                          //       child:
                          Container(
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  borderRadius:
                                      BorderRadiusDirectional.circular(15)),

                              // Semi-transparent black overlay

                              child: Center(
                                child: Hero(
                                  tag: 'heroTag',
                                  child: Lottie.asset(
                                    'assets/loder1.json',
                                    // 'assets/loader.json',
                                    height: 150,
                                  ),
                                ),
                              ),
                            )
                          // )
                          : SizedBox()
                    ],
                  )),
              // dd(controller),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(Get.context!).size.height * 0.05),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller.charsDone.value.clear();
                        controller.charsDone.notifyListeners();
                        controller.currentDragObj.value = CurrentDragObj();
                        controller.currentDragObj.notifyListeners();
                        controller.generateRandomWord();

                        controller.stopTimer();
                        controller.startGame();
                        controller.moves = 0;
                        controller.update();
                      },
                      child: Image.asset(
                        appSkipbtn,
                        height: MediaQuery.of(Get.context!).size.height * 0.07,
                      ),
                    ),
                    // CustomSimpleTextField(
                    //   hintText: 'Moves: ${controller.moves.toString() ?? ""}',
                    //   fontfamily: 'Montstreat',
                    //   textSize: MediaQuery.of(Get.context!).size.width * 0.05,
                    //   hintColor: appColor,
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
        controller.start == 1
            ? Lottie.asset(
                fit: BoxFit.fitHeight,
//repeat: true,
                'assets/s.json',
                // animate: true,
                controller: controller.animationControllerBlast,
                // Use animationController here
                onLoaded: (composition) {
                  controller.animationControllerBlast!.duration =
                      composition.duration;
                },
              )
            : Text('')
      ],
    );
  }

  Widget drawCrosswordBox(String matchedWord) {
    return Listener(
      onPointerUp: (event) {
        controller.onDragEnd(event);
      },
      onPointerMove: (event) {
        controller.onDragUpdate(event);
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          controller.sizeBox = Size(constraints.maxWidth, constraints.maxWidth);
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 1,
              crossAxisCount: controller.numBoxPerRow,
              crossAxisSpacing: controller.padding,
              mainAxisSpacing: controller.padding,
            ),
            itemCount: controller.numBoxPerRow * controller.numBoxPerRow,
            itemBuilder: (context, index) {
              String char =
                  controller.listChars.value.expand((e) => e).toList()[index];

              return Listener(
                onPointerDown: (event) {
                  controller.onDragStart(index);
                },
                child: ValueListenableBuilder(
                  valueListenable: controller.currentDragObj,
                  builder: (context, CurrentDragObj value, child) {
                    Color cellColor = Colors.transparent;
                    if (value.currentDragLine.contains(index)) {
                      cellColor = appPinkColor;
                    } else if (controller.charsDone.value.contains(index)) {
                      List<Color>? intersectingColors =
                          controller.cellIntersections.value[index];

                      if (intersectingColors != null &&
                          intersectingColors.length > 1) {
                        return CustomPaint(
                          size: Size(double.infinity, double.infinity),
                          painter: OverlappingCellPainter(intersectingColors),
                          child: Center(
                            child: Text(
                              char.toUpperCase(),
                              style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                          ),
                        );
                      } else if (intersectingColors != null &&
                          intersectingColors.isNotEmpty) {
                        cellColor = intersectingColors.first;
                      }
                    }

                    return Container(
                      decoration: BoxDecoration(
                        color: cellColor,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        char.toUpperCase(),
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Widget drawCrosswordBox(String matchedWord) {
  //   return Listener(
  //     onPointerUp: (event) {
  //       controller.onDragEnd(event);
  //     },
  //     onPointerMove: (event) {
  //       controller.onDragUpdate(event);
  //     },
  //     child: LayoutBuilder(
  //       builder: (context, constraints) {
  //         controller.sizeBox = Size(constraints.maxWidth, constraints.maxWidth);
  //         return GridView.builder(
  //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //             childAspectRatio: 1,
  //             crossAxisCount: controller.numBoxPerRow,
  //             crossAxisSpacing: controller.padding,
  //             mainAxisSpacing: controller.padding,
  //           ),
  //           itemCount: controller.numBoxPerRow * controller.numBoxPerRow,
  //           itemBuilder: (context, index) {
  //             String char =
  //             controller.listChars.value.expand((e) => e).toList()[index];
  //
  //             return Listener(
  //               onPointerDown: (event) {
  //                 controller.onDragStart(index);
  //               },
  //               child: ValueListenableBuilder(
  //                 valueListenable: controller.currentDragObj,
  //                 builder: (context, CurrentDragObj value, child) {
  //                   List<CrosswordAnswer> overlappingAnswers = controller.answerList.value
  //                       .where((answer) => answer.answerLines.contains(index))
  //                       .toList();
  //
  //                   Color cellColor = Colors.transparent;
  //                   if (value.currentDragLine.contains(index)) {
  //                     cellColor = appPinkColor;
  //                   } else if (controller.charsDone.value.contains(index)) {
  //                     if (overlappingAnswers.isNotEmpty) {
  //                       return CustomPaint(
  //                         size: Size(double.infinity, double.infinity),
  //                         painter: OverlappingCellPainter(
  //                           overlappingAnswers.map((answer) => answer.color).toList(),
  //                         ),
  //                         child: Center(
  //                           child: Text(
  //                             char.toUpperCase(),
  //                             style: TextStyle(
  //                               fontSize: 21,
  //                               fontWeight: FontWeight.bold,
  //                               fontFamily: 'Montserrat',
  //                             ),
  //                           ),
  //                         ),
  //                       );
  //                     }
  //                   }
  //
  //                   return Container(
  //                     decoration: BoxDecoration(
  //                       color: cellColor,
  //                     ),
  //                     alignment: Alignment.center,
  //                     child: Text(
  //                       char.toUpperCase(),
  //                       style: TextStyle(
  //                         fontSize: 21,
  //                         fontWeight: FontWeight.bold,
  //                         fontFamily: 'Montserrat',
  //                       ),
  //                     ),
  //                   );
  //                 },
  //               ),
  //             );
  //           },
  //         );
  //       },
  //     ),
  //   );
  // }

  // Widget drawCrosswordBox(String matchedWord) {
  //   return Listener(
  //     onPointerUp: (event) {
  //       controller.onDragEnd(event);
  //     },
  //     onPointerMove: (event) {
  //       controller.onDragUpdate(event);
  //     },
  //     child: LayoutBuilder(
  //       builder: (context, constraints) {
  //         controller.sizeBox = Size(constraints.maxWidth, constraints.maxWidth);
  //         return GridView.builder(
  //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //             childAspectRatio: 1,
  //             crossAxisCount: controller.numBoxPerRow,
  //             crossAxisSpacing: controller.padding,
  //             mainAxisSpacing: controller.padding,
  //           ),
  //           itemCount: controller.numBoxPerRow * controller.numBoxPerRow,
  //           itemBuilder: (context, index) {
  //             String char =
  //             controller.listChars.value.expand((e) => e).toList()[index];
  //
  //             return Listener(
  //               onPointerDown: (event) {
  //                 controller.onDragStart(index);
  //               },
  //               child: ValueListenableBuilder(
  //                 valueListenable: controller.currentDragObj,
  //                 builder: (context, CurrentDragObj value, child) {
  //                   List<CrosswordAnswer> overlappingAnswers = controller.answerList.value
  //                       .where((answer) => answer.answerLines.contains(index))
  //                       .toList();
  //
  //                   Color cellColor = Colors.transparent;
  //                   if (value.currentDragLine.contains(index)) {
  //                     cellColor = appPinkColor;
  //                   } else if (controller.charsDone.value.contains(index)) {
  //                     if (overlappingAnswers.isNotEmpty) {
  //                       cellColor = overlappingAnswers
  //                           .map((answer) => answer.color)
  //                           .reduce((color1, color2) => blendColors(color1, color2));
  //                     }
  //                   }
  //
  //                   return Container(
  //                     decoration: BoxDecoration(
  //                       color: cellColor,
  //                     ),
  //                     alignment: Alignment.center,
  //                     child: Text(
  //                       char.toUpperCase(),
  //                       style: TextStyle(
  //                         fontSize: 21,
  //                         fontWeight: FontWeight.bold,
  //                         fontFamily: 'Montserrat',
  //                       ),
  //                     ),
  //                   );
  //                 },
  //               ),
  //             );
  //           },
  //         );
  //       },
  //     ),
  //   );
  // }

  Color blendColors(Color color1, Color color2) {
    return Color.fromARGB(
      (color1.alpha + color2.alpha) ~/ 2,
      (color1.red + color2.red) ~/ 2,
      (color1.green + color2.green) ~/ 2,
      (color1.blue + color2.blue) ~/ 2,
    );
  }

//   Widget drawCrosswordBox(String matchedWord) {
//
//
//     return Listener(
//       onPointerUp: (event) {
//         controller.onDragEnd(event);
//       },
//       onPointerMove: (event) {
//         controller.onDragUpdate(event);
//       },
//       child: LayoutBuilder(
//         builder: (context, constraints) {
//           controller.sizeBox = Size(constraints.maxWidth, constraints.maxWidth);
//           return GridView.builder(
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               childAspectRatio: 1,
//               crossAxisCount: controller.numBoxPerRow,
//               crossAxisSpacing: controller.padding,
//               mainAxisSpacing: controller.padding,
//             ),
//             itemCount: controller.numBoxPerRow * controller.numBoxPerRow,
//             itemBuilder: (context, index) {
//               String char =
//                   controller.listChars.value.expand((e) => e).toList()[index];
//
//               return Listener(
//                 onPointerDown: (event) {
//                   controller.onDragStart(index);
//                 },
//                 child: ValueListenableBuilder(
//                   valueListenable: controller.currentDragObj,
//                   builder: (context, CurrentDragObj value, child) {
//                     CrosswordAnswer matchedAnswer = controller.answerList.value
//                         .firstWhere(
//                             (answer) => answer.answerLines.contains(index),
//                             orElse: () =>
//                                 CrosswordAnswer(
//                                 WSLocation(
//                                     x: 0,
//                                     y: 0,
//                                     orientation: WSOrientation.horizontal,
//                                     overlap: 0,
//                                     word: ''),
//                                 numPerRow: controller.numBoxPerRow)
//                        // CrosswordAnswer.defaultAnswer()
//                     );
//
// // Then you can check if matchedAnswer is the default one
//                     Color cellColor = Colors.transparent;
//                     if (value.currentDragLine.contains(index)) {
//                       cellColor = appPinkColor;
//                     } else if (controller.charsDone.value.contains(index)) {
//                       print("Word Done: ${controller.wordDone}");
//                       if (matchedAnswer.indexArray != 0 ||
//                           matchedAnswer.wsLocation.x != 0 ||
//                           matchedAnswer.wsLocation.y != 0) {
//                         cellColor = matchedAnswer.color;
//                       }
//                     }
//
//                     return Container(
//                       decoration: BoxDecoration(
//                         color: cellColor,
//                       ),
//                       alignment: Alignment.center,
//                       child: Text(
//                         char.toUpperCase(),
//                         style: TextStyle(
//                           fontSize: 21,
//                           fontWeight: FontWeight.bold,
//                           fontFamily: 'Montserrat',
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//
//     //   Listener(
//     //   onPointerUp: (event) {
//     //     controller.onDragEnd(event);
//     //   },
//     //   onPointerMove: (event) {
//     //     controller.onDragUpdate(event);
//     //   },
//     //   child: LayoutBuilder(
//     //     builder: (context, constraints) {
//     //       controller.sizeBox = Size(constraints.maxWidth, constraints.maxWidth);
//     //       return GridView.builder(
//     //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//     //           childAspectRatio: 1,
//     //           crossAxisCount: controller.numBoxPerRow,
//     //           crossAxisSpacing: controller.padding,
//     //           mainAxisSpacing: controller.padding,
//     //         ),
//     //         itemCount: controller.numBoxPerRow * controller.numBoxPerRow,
//     //         itemBuilder: (context, index) {
//     //           String char =
//     //               controller.listChars.value.expand((e) => e).toList()[index];
//     //
//     //           return Listener(
//     //             onPointerDown: (event) {
//     //               controller.onDragStart(index);
//     //             },
//     //             child: ValueListenableBuilder(
//     //               valueListenable: controller.currentDragObj,
//     //               builder: (context, CurrentDragObj value, child) {
//     //                 print(controller.checkResult);
//     //
//     //                 controller.color = Colors.transparent;
//     //                 if (value.currentDragLine.contains(index)) {
//     //                   controller.color = appPinkColor;
//     //                 } else if (controller.charsDone.value.contains(index)) {
//     //                   print("Word Done: ${controller.wordDone}");
//     //                   print("Word Done: ${controller.wordDone}");
//     //                   var matchedAnswer = controller.answerList.value.firstWhere(
//     //                           (answer) => answer.answerLines.contains(index),
//     //                       orElse: () => null);
//     //                   if (matchedAnswer != null) {
//     //                     controller.color = matchedAnswer.color;
//     //                   }
//     //                   // if (controller.wordDone == 1) {
//     //                   //   controller.color = Colors.red;
//     //                   // } else if (controller.wordDone == 2) {
//     //                   //   controller.color = Colors.yellow;
//     //                   // } else if (controller.wordDone == 3) {
//     //                   //   controller.color = Colors.brown;
//     //                   // } else if (controller.wordDone == 4) {
//     //                   //   controller.color = Colors.blue;
//     //                   // } else if (controller.wordDone == 5) {
//     //                   //   controller.color = Colors.black;
//     //                   // }
//     //                   // controller.color = controller.colorList[
//     //                   //     (controller.lastColorIndex + controller.wordDone) %
//     //                   //         controller.colorList.length];
//     //                   // controller.lastColorIndex = (controller.lastColorIndex +
//     //                   //         1) %
//     //                   //     controller.colorList.length;
//     //                 }
//     //
//     //                 return Container(
//     //                   decoration: BoxDecoration(
//     //                     color: controller.color,
//     //                   ),
//     //                   alignment: Alignment.center,
//     //                   child: Text(
//     //                     char.toUpperCase(),
//     //                     style: TextStyle(
//     //                       fontSize: 21,
//     //                       fontWeight: FontWeight.bold,
//     //                       fontFamily: 'Montstreat',
//     //                     ),
//     //                   ),
//     //                 );
//     //               },
//     //             ),
//     //           );
//     //         },
//     //       );
//     //     },
//     //   ),
//     // );
//   }

  // Widget drawCrosswordBox(String matchedSeries) {
  //   bool isFirstMatch = true; // Flag to track if it's the first match
  //   print(controller.checkResult.value);
  //   print(matchedSeries);
  //   Color getRandomColor() {
  //     Random random = Random();
  //     return Color.fromARGB(
  //       255,
  //       random.nextInt(256),
  //       random.nextInt(256),
  //       random.nextInt(256),
  //     );
  //   }
  //
  //   return Listener(
  //     onPointerUp: (event) {
  //       controller.onDragEnd(event);
  //     },
  //     onPointerMove: (event) {
  //       controller.onDragUpdate(event);
  //     },
  //     child: LayoutBuilder(
  //       builder: (context, constraints) {
  //         controller.sizeBox = Size(constraints.maxWidth, constraints.maxWidth);
  //         return GridView.builder(
  //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //             childAspectRatio: 1,
  //             crossAxisCount: controller.numBoxPerRow,
  //             crossAxisSpacing: controller.padding,
  //             mainAxisSpacing: controller.padding,
  //           ),
  //           itemCount: controller.numBoxPerRow * controller.numBoxPerRow,
  //           itemBuilder: (context, index) {
  //             String char =
  //                 controller.listChars.value.expand((e) => e).toList()[index];
  //             return Listener(
  //               onPointerDown: (event) {
  //                 controller.onDragStart(index);
  //               },
  //               child: ValueListenableBuilder(
  //                 valueListenable: controller.currentDragObj,
  //                 builder: (context, CurrentDragObj value, child) {
  //                   print(controller.checkResult);
  //                   Color color = Colors.transparent;
  //                   if (value.currentDragLine.contains(index))
  //                     color = appPinkColor;
  //                   else if (controller.charsDone.value.contains(index))
  //                     color= appSkyColor;
  //
  //                   //   if (controller
  //                   //         .checkResult.value ==
  //                   //     matchedSeries) {
  //                   //   // Check for matched series
  //                   //   color = appSkyColor;
  //                   // } else if (controller.checkResult.value == 1) {
  //                   //   color = Colors.brown;
  //                   // } else if (controller.checkResult.value == 2) {
  //                   //   color = Colors.yellow;
  //                   // } else if (controller.checkResult.value == 3) {
  //                   //   color = Colors.blue;
  //                   // } else if (controller.checkResult.value == 4) {
  //                   //   color = Colors.orange;
  //                   // } else if (controller.checkResult.value == 5) {
  //                   //   color = Colors.blue;
  //                   // } else if (controller.checkResult.value == 0) {
  //                   //   color = Colors.green;
  //                   // }
  //
  //                   return Container(
  //                     decoration: BoxDecoration(
  //                       color: color,
  //                       // border: Border.all(color: Colors.black), // Add border
  //                     ),
  //                     alignment: Alignment.center,
  //                     child: Text(
  //                       char.toUpperCase(),
  //                       style: TextStyle(
  //                         fontSize: 21,
  //                         fontWeight: FontWeight.bold,
  //                         fontFamily: 'Montstreat',
  //                       ),
  //                     ),
  //                   );
  //                 },
  //               ),
  //             );
  //           },
  //         );
  //       },
  //     ),
  //   );
  // }

  // Widget drawCrosswordBox() {
  //
  //
  //   return Listener(
  //     onPointerUp: (event) {
  //       controller.onDragEnd(event);
  //     },
  //     onPointerMove: (event) {
  //       controller.onDragUpdate(event);
  //     },
  //     child: LayoutBuilder(
  //       builder: (context, constraints) {
  //         controller.sizeBox = Size(constraints.maxWidth, constraints.maxWidth);
  //         return GridView.builder(
  //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //             childAspectRatio: 1,
  //             crossAxisCount: controller.numBoxPerRow,
  //             crossAxisSpacing: controller.padding,
  //             mainAxisSpacing: controller.padding,
  //           ),
  //           itemCount: controller.numBoxPerRow * controller.numBoxPerRow,
  //           itemBuilder: (context, index) {
  //             String char =
  //                 controller.listChars.value.expand((e) => e).toList()[index];
  //             return Listener(
  //               onPointerDown: (event) {
  //                 controller.onDragStart(index);
  //               },
  //               child: ValueListenableBuilder(
  //                 valueListenable: controller.currentDragObj,
  //                 builder: (context, CurrentDragObj value, child) {
  //                   Color color = Colors.transparent;
  //                   if (value.currentDragLine.contains(index))
  //                     color = appPinkColor;
  //
  //                   else if (controller.charsDone.value.contains(index))
  //                     color = appSkyColor;
  //
  //                   return Container(
  //                     decoration: BoxDecoration(
  //                       color: color,
  //                       // border: Border.all(color: Colors.black), // Add border
  //                     ),
  //                     alignment: Alignment.center,
  //                     child: Text(
  //                       char.toUpperCase(),
  //                       style: TextStyle(
  //                         fontSize: 28,
  //                         fontWeight: FontWeight.bold,
  //                         fontFamily: 'summary',
  //                       ),
  //                     ),
  //                   );
  //                 },
  //               ),
  //             );
  //           },
  //         );
  //       },
  //     ),
  //   );
  // }

  Widget drawAnswerList() {
    return GetBuilder<WordSolveController>(
      builder: (_) {
        return ValueListenableBuilder<List<CrosswordAnswer>>(
          valueListenable: controller.answerList,
          builder: (context, value, child) {
            int perColTotal = 3;
            List<Widget> list = List.generate(
              (value.length ~/ perColTotal) +
                  ((value.length % perColTotal) > 0 ? 1 : 0),
              (int index) {
                int maxColumn = (index + 1) * perColTotal;

                return Container(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      maxColumn > value.length
                          ? maxColumn - value.length
                          : perColTotal,
                      (indexChild) {
                        int indexArray = (index) * perColTotal + indexChild;
                        if (indexArray < value.length) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            controller.updateCheckResult(indexArray);
                            if (controller.checkResult.value > 0) {
                              drawCrosswordBox(value[indexArray]
                                  .wsLocation
                                  .word); // Pass series number
                            }
                          });
                          print(controller.checkResult.value);
                          return Text(
                            "${value[indexArray].wsLocation.word.toUpperCase()}",
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.021,
                              color: value[indexArray].done
                                  ? Colors.yellow
                                  : Colors.white,
                              decoration: value[indexArray].done
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          );
                        } else {
                          return Container(); // Empty container for unused slots
                        }
                      },
                    ).toList(),
                  ),
                );
              },
            ).toList();

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadiusDirectional.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: list,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Widget drawAnswerList() {
  //   return ValueListenableBuilder(
  //     valueListenable: controller.answerList,
  //     builder: (context, List<CrosswordAnswer> value, child) {
  //       int perColTotal = 3;
  //       List<Widget> list = List.generate(
  //         (value.length ~/ perColTotal) +
  //             ((value.length % perColTotal) > 0 ? 1 : 0),
  //         (int index) {
  //           int maxColumn = (index + 1) * perColTotal;
  //
  //           return Container(
  //             margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
  //             child: Row(
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //               children: List.generate(
  //                 maxColumn > value.length
  //                     ? maxColumn - value.length
  //                     : perColTotal,
  //                 (indexChild) {
  //                   int indexArray = (index) * perColTotal + indexChild;
  //                   print('kamalalal');
  //                   // print(value);
  //                   print(indexArray);
  //                   //
  //                   // controller.checkResult = indexArray;
  //                   // print(controller.checkResult);
  //                   // controller.update();
  //                   return Text(
  //                     "${value[indexArray].wsLocation.word}",
  //                     style: TextStyle(
  //                       fontSize: MediaQuery.of(context).size.height * 0.025,
  //                       color: value[indexArray].done
  //                           ? Colors.yellow
  //                           : Colors.white,
  //                       decoration: value[indexArray].done
  //                           ? TextDecoration.lineThrough
  //                           : TextDecoration.none,
  //                     ),
  //                   );
  //                 },
  //               ).toList(),
  //             ),
  //           );
  //         },
  //       ).toList();
  //
  //       return Padding(
  //         padding: const EdgeInsets.all(8.0),
  //         child: Container(
  //           decoration: BoxDecoration(
  //               color: appPinkColor,
  //               borderRadius: BorderRadiusDirectional.circular(10)),
  //           child: Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: Column(
  //               children: list,
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  showDialogBox(WordSolveController controller) {
    return showDialog<void>(
      context: Get.context!,
      builder: (BuildContext context) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              apphow,
              height: MediaQuery.of(context).size.width * 0.9,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(Get.context!).size.height * 0.01),
                  child: SizedBox(
                    width: MediaQuery.of(Get.context!).size.width * 0.6,
                    // height: MediaQuery.of(Get.context!).size.height * 0.2,
                    child: CustomSimpleTextField(
                      textAlign: TextAlign.center,
                      hintText:
                          "I have six different words which are also hidden in a grid of letters. "
                          "If you find them, swipe on those words.",
                      textSize: MediaQuery.of(Get.context!).size.width * 0.04,
                      hintColor: blackColor,
                      fontfamily: 'Monstreat',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      controller.playAudio();
                      Get.back();
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
                            textSizeValue: true,
                            underLineValue: false,
                            textAlign: TextAlign.center,
                            hintText: 'OKAY!!',
                            textSize:
                                MediaQuery.of(Get.context!).size.width * 0.06,
                            hintColor: Colors.white,
                            fontfamily: 'summary',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  dd(WordSolveController controller) {
    return Column(
      children: [
        Container(
          // color: Colors.white,
          alignment: Alignment.center,
          width: double.maxFinite,
          height: MediaQuery.of(Get.context!).size.height * 0.45,
          // height: controller.size.width - controller.padding * 2,
          padding: EdgeInsets.all(controller.padding),
          margin: EdgeInsets.all(controller.padding),
          child: drawCrosswordBox(''),
        ),
        Container(
          alignment: Alignment.center,
          child: drawAnswerList(),
        ),
      ],
    );
    //   SizedBox(
    //   height: MediaQuery.of(Get.context!!).size.height * 0.6,
    //   width: MediaQuery.of(Get.context!!).size.width,
    //   child:
    // );
  }
}
