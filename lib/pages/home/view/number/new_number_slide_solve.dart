import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../../color.dart';
import '../../../../custom/simpleText.dart';
import '../../../../image.dart';
import '../../controller/number/new_slide_controller.dart';

class NewNumberPuzzleSlideSolveScreen
    extends GetView<NewNumberPuzzleSlideSolveController> {
  @override
  Widget build(BuildContext context) {
    Get.put(NewNumberPuzzleSlideSolveController());
    return WillPopScope(
      onWillPop: () async {
        controller.togglePlayPause();
        return true;
        // return false;
      },
      child: GetBuilder<NewNumberPuzzleSlideSolveController>(
        init: NewNumberPuzzleSlideSolveController(),
        builder: (context) {
          return Scaffold(
            body: _bodyWidget(controller),
          );
        },
      ),
    );
  }

  _bodyWidget(NewNumberPuzzleSlideSolveController controller) {
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
              // ConfettiWidget(
              //   confettiController: controller.blastController,
              //   shouldLoop: true,
              //   blastDirectionality: BlastDirectionality.explosive,
              //   maxBlastForce: 100,
              //   numberOfParticles: 50,
              // ),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(Get.context!).size.height * 0.02,
                    left: MediaQuery.of(Get.context!).size.width * 0.04,
                    right: MediaQuery.of(Get.context!).size.width * 0.05),
                child: dd(controller),
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      controller.shufflePuzzle();
                      controller.update();
                      controller.stopTimer();
                      controller.startGame();
                      controller.moves = 0;
                    },
                    child: Image.asset(appShuffle),
                  ),
                  CustomSimpleTextField(
                    hintText: 'Moves: ${controller.moves.toString() ?? ""}',
                    fontfamily: 'Montstreat',
                    textSize: MediaQuery.of(Get.context!).size.width * 0.05,
                    hintColor: appColor,
                  ),
                ],
              ),
            ],
          ),
        ),
        controller.start==1?
        Lottie.asset(
          fit: BoxFit.fitHeight,
//repeat: true,
          'assets/s.json',
          // animate: true,
          controller: controller.animationControllerBlast, // Use animationController here
          onLoaded: (composition) {
            controller.animationControllerBlast!.duration = composition.duration;
          },
        ):Text('')
      ],
    );
  }

  showDialogBox(NewNumberPuzzleSlideSolveController controller) {
    return showDialog<void>(
      context: Get.context!,
      builder: (BuildContext context) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(apphow,height:  MediaQuery.of(context).size.width * 0.9,),
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
                          "Slide numbers in a 3x3 grid to arrange them in ascending order."
                          " Use the empty space strategically to solve the puzzle. Good luck!",
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
                            underLineValue: false ,
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

  dd(NewNumberPuzzleSlideSolveController controller) {
    return SizedBox(
      height: MediaQuery.of(Get.context!!).size.height * 0.6,
      width: MediaQuery.of(Get.context!!).size.width,
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: controller.gridSize!,
        ),
        itemCount: controller.puzzleNumbers!.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onPanStart: (details) {
              controller.initialX = details.globalPosition.dx;
              controller.initialY = details.globalPosition.dy;
            },
            onPanUpdate: (details) {
              if (!controller.isHandlingGesture &&
                  controller.puzzleNumbers[index] !=
                      (controller.gridSize! * controller.gridSize!)) {
                controller.isHandlingGesture = true;

                double deltaX = details.globalPosition.dx - controller.initialX;
                double deltaY = details.globalPosition.dy - controller.initialY;

                if (deltaX.abs() >
                    MediaQuery.of(Get.context!).size.width * 0.1) {
                  controller.moveNumber(
                    index,
                    deltaX > 0 ? 'left' : 'right',
                  );
                } else if (deltaY.abs() >
                    MediaQuery.of(Get.context!).size.width * 0.1) {
                  controller.moveNumber(
                    index,
                    deltaY > 0 ? 'up' : 'down',
                  );
                }

                Future.delayed(Duration(milliseconds: 1), () {
                  controller.isHandlingGesture = false;
                });
              }
            },
            child: Padding(
              padding: EdgeInsets.all(controller.gridSize == 3
                  ? 10
                  : controller.gridSize == 4
                      ? 2
                      : 0),
              child: Stack(
                children: [
                  Positioned(
                    top: (index ~/ controller.gridSize!).toDouble() *
                        MediaQuery.of(Get.context!).size.width *
                        0.005,
                    left: (index % controller.gridSize!).toDouble() *
                        MediaQuery.of(Get.context!).size.width *
                        0.005,
                    child: Padding(
                      padding: EdgeInsets.all(controller.gridSize == 3
                          ? MediaQuery.of(Get.context!).size.width * 0.02
                          : MediaQuery.of(Get.context!).size.width * 0.005),
                      child: Container(
                        height: controller.gridSize == 3
                            ? MediaQuery.of(Get.context!).size.width * 0.2
                            : controller.gridSize == 4
                                ? MediaQuery.of(Get.context!).size.width * 0.18
                                : MediaQuery.of(Get.context!).size.width * 0.15,
                        width: controller.gridSize == 3
                            ? MediaQuery.of(Get.context!).size.width * 0.2
                            : controller.gridSize == 4
                                ? MediaQuery.of(Get.context!).size.width * 0.18
                                : MediaQuery.of(Get.context!).size.width * 0.15,
                        child: AnimatedContainer(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                controller.puzzleNumbers[index] !=
                                        (controller.gridSize! *
                                            controller.gridSize!)
                                    ? appNumberBox
                                    : appNumbernot,
                              ),
                              fit: BoxFit.fill,
                            ),
                          ),
                          duration: controller.animateController.duration!,
                          child: Center(
                            child: CustomSimpleTextField(
                              textSizeValue: true,
                              hintText: controller.puzzleNumbers[index] !=
                                      (controller.gridSize! *
                                          controller.gridSize!)
                                  ? '${controller.puzzleNumbers[index]}'
                                  : '',
                              fontfamily: 'Montstreat',
                              textSize: controller.gridSize == 3
                                  ? MediaQuery.of(Get.context!).size.width *
                                      0.08
                                  : controller.gridSize == 4
                                      ? MediaQuery.of(Get.context!).size.width *
                                          0.07
                                      : MediaQuery.of(Get.context!).size.width *
                                          0.06,
                              hintColor: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
