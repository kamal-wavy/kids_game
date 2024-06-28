import 'package:KidsPlan/pages/home/view/chnages+word/chnage_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../../color.dart';
import '../../../../custom/simpleText.dart';
import '../../../../image.dart';

class ChangeScreen extends GetView<ChangeController> {
  @override
  Widget build(BuildContext context) {
    Get.put(ChangeController());
    return WillPopScope(
      onWillPop: () async {
        controller.togglePlayPause();
        return true;
        // return false;
      },
      child: GetBuilder<ChangeController>(
        init: ChangeController(),
        builder: (context) {
          return Scaffold(
            body: _bodyWidget(controller),
          );
        },
      ),
    );
  }

  _bodyWidget(ChangeController controller) {
    return Stack(
      children: [
        Image.asset(
          appselectbg,
          fit: BoxFit.fill,
          height: double.infinity,
          width: double.infinity,
        ),
        SafeArea(
          child: SingleChildScrollView(
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
                          controller.cellIntersections.value.clear();
                          controller.cellIntersections.notifyListeners();
                          controller.generateRandomWord();
            
                          controller.stopTimer();
                          controller.startGame();
                          controller.moves = 0;
                          controller.update();
                        },
                        child: Image.asset(
                          appRstbtn,
                          // appSkipbtn,
                          height: MediaQuery.of(Get.context!).size.height * 0.07,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        controller.start == 1
            ? Lottie.asset(
                fit: BoxFit.fitHeight,

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
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Listener(
        onPointerUp: (event) {
          controller.onDragEnd(event);
        },
        onPointerMove: (event) {
          controller.onDragUpdate(event);
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            controller.sizeBox =
                Size(constraints.maxWidth, constraints.maxWidth);
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
                            painter: GradientCellPainter(intersectingColors),
                            child: Center(
                              child: Text(
                                char.toUpperCase(),
                                style: TextStyle(
                                  color:
                                      controller.charsDone.value.contains(index)
                                          ? Colors.white
                                          : appRedColor1,
                                  fontSize: 19,
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
                          border: Border.all(color: appRedColor1),
                          color: cellColor,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          char.toUpperCase(),
                          style: TextStyle(
                            color: (value.currentDragLine.contains(index) ||
                                    controller.charsDone.value.contains(index))
                                ? Colors.white
                                : appRedColor1,
                            fontSize: 19,
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
  //                 controller.listChars.value.expand((e) => e).toList()[index];
  //
  //             return Listener(
  //               onPointerDown: (event) {
  //                 controller.onDragStart(index);
  //               },
  //               child: ValueListenableBuilder(
  //                 valueListenable: controller.currentDragObj,
  //                 builder: (context, CurrentDragObj value, child) {
  //                   Color cellColor = Colors.transparent;
  //                   if (value.currentDragLine.contains(index)) {
  //                     cellColor = appPinkColor;
  //                   } else if (controller.charsDone.value.contains(index)) {
  //                     List<Color>? intersectingColors =
  //                         controller.cellIntersections.value[index];
  //
  //                     if (intersectingColors != null &&
  //                         intersectingColors.length > 1) {
  //                       return CustomPaint(
  //                         size: Size(double.infinity, double.infinity),
  //                         painter: OverlappingCellPainter(intersectingColors),
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
  //                     } else if (intersectingColors != null &&
  //                         intersectingColors.isNotEmpty) {
  //                       cellColor = intersectingColors.first;
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
  Widget drawAnswerList() {
    return GetBuilder<ChangeController>(
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

                return Row(
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
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 5.0),
                          // Add some spacing between containers if needed
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: value[indexArray].done
                                    ? appPinkColor
                                    : appColor1,
                                // Change this to your desired color
                                width: 4.0, // Change this to your desired width
                              ),
                            ),
                            gradient:
                                value[indexArray].done ? null : appGradient5,
                            color: appPinkColor,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: Offset(
                                    0, 3), // shadow only on the bottom side
                              ),
                              // BoxShadow(
                              //   color: appColor.withOpacity(0.8),
                              //   offset: Offset(0, 25),
                              //   blurRadius: 1,
                              //   spreadRadius: -18,
                              // ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            // Add some padding inside the container if needed
                            child: Text(
                              "${value[indexArray].wsLocation.word.toUpperCase()}",
                              style: TextStyle(
                                fontFamily: "Montstreat",
                                //'Digitalt',
                                // fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.021,
                                color: value[indexArray].done
                                    ? Colors.white
                                    : Colors.white,
                                decoration: value[indexArray].done
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Container(); // Empty container for unused slots
                      }
                    },
                  ).toList(),
                );
              },
            ).toList();

            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: list,
              ),
            );
          },
        );
      },
    );
  }

  // Widget drawAnswerList() {
  //   return GetBuilder<ChangeController>(
  //     builder: (_) {
  //       return ValueListenableBuilder<List<CrosswordAnswer>>(
  //         valueListenable: controller.answerList,
  //         builder: (context, value, child) {
  //           int perColTotal = 3;
  //           List<Widget> list = List.generate(
  //             (value.length ~/ perColTotal) +
  //                 ((value.length % perColTotal) > 0 ? 1 : 0),
  //             (int index) {
  //               int maxColumn = (index + 1) * perColTotal;
  //
  //               return Container(
  //                 margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
  //                 child: Row(
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                   children: List.generate(
  //                     maxColumn > value.length
  //                         ? maxColumn - value.length
  //                         : perColTotal,
  //                     (indexChild) {
  //                       int indexArray = (index) * perColTotal + indexChild;
  //                       if (indexArray < value.length) {
  //                         WidgetsBinding.instance.addPostFrameCallback((_) {
  //                           controller.updateCheckResult(indexArray);
  //                           if (controller.checkResult.value > 0) {
  //                             drawCrosswordBox(value[indexArray]
  //                                 .wsLocation
  //                                 .word); // Pass series number
  //                           }
  //                         });
  //                         print(controller.checkResult.value);
  //                         return Text(
  //                           "${value[indexArray].wsLocation.word.toUpperCase()}",
  //                           style: TextStyle(
  //                             fontSize:
  //                                 MediaQuery.of(context).size.height * 0.021,
  //                             color: value[indexArray].done
  //                                 ? Colors.yellow
  //                                 : Colors.white,
  //                             decoration: value[indexArray].done
  //                                 ? TextDecoration.lineThrough
  //                                 : TextDecoration.none,
  //                           ),
  //                         );
  //                       } else {
  //                         return Container(); // Empty container for unused slots
  //                       }
  //                     },
  //                   ).toList(),
  //                 ),
  //               );
  //             },
  //           ).toList();
  //
  //           return Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: Container(
  //               decoration: BoxDecoration(
  //                 color: Colors.pink,
  //                 borderRadius: BorderRadiusDirectional.circular(10),
  //               ),
  //               child: Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: Column(
  //                   children: list,
  //                 ),
  //               ),
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  showDialogBox(ChangeController controller) {
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

  dd(ChangeController controller) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),

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
