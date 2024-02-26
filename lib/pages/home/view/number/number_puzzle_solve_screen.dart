import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:KidsPlan/color.dart';

import '../../../../custom/simpleText.dart';
import '../../../../image.dart';
import '../../controller/number/number_puzzle_solve_controller.dart';

class NumberPuzzleSolveScreen extends GetView<NumberPuzzleSolveController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<NumberPuzzleSolveController>(
        init: NumberPuzzleSolveController(),
        builder: (context) {
          return Scaffold(body: _bodyWidget(controller));
        });
  }
}

_bodyWidget(NumberPuzzleSolveController controller) {
  return Stack(
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
              child: Image.asset(
            appselectbg,
            fit: BoxFit.fill,
          )),
        ],
      ),
      SafeArea(
          child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
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
                            borderRadius: BorderRadius.circular(8)),
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
                      )),
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
                                child: Text(
                                  controller
                                      .formatTime(controller.secondsElapsed),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
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
                      child: Image.asset(appTips)),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 10, right: 10),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: controller.gridSize!,
                ),
                itemCount: controller.numbers!.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                      onTap: () {
                        controller.onTilePressed(index);
                      },
                      child: Container(
                        margin: EdgeInsets.all(controller.gridSize == 3
                            ? 3
                            : controller.gridSize == 4
                                ? 8
                                : 8),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    controller.numbers![index] == 0
                                        ? appNumbernot
                                        : appNumberBox))),
                        child: Center(
                          child: CustomSimpleTextField(
                            textSizeValue: true,
                            hintText: controller.numbers![index] != 0
                                ? controller.numbers![index].toString()
                                : '',
                            fontfamily: 'Montstreat',
                            textSize: controller.gridSize == 3
                                ? 40
                                : controller.gridSize == 4
                                    ? 35
                                    : 29,
                            hintColor: Colors.white,
                          ),
                        ),
                      ));
                },
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    controller.initializeGame();
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
                  textSize: 25,
                  hintColor: appColor,
                ),
              ],
            ),
          ),
        ],
      )),
    ],
  );
}

showDialogBox(NumberPuzzleSolveController controller) {
  return showDialog<void>(
    context: Get.context!,
    builder: (BuildContext context) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(apphow),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: CustomSimpleTextField(
                    textAlign: TextAlign.center,
                    hintText: "Arrange the numbers in a 3x3 grid by sliding "
                        "them into the empty space. The objective is to arrange the "
                        "numbers in ascending order from left to right,"
                        " top to bottom. Use the empty space strategically to solve "
                        "the puzzle. Good luck!",
                    textSize: 20,
                    hintColor: blackColor,
                    fontfamily: 'summary',
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
                        Image.asset(appbtn),
                        Center(
                          child: CustomSimpleTextField(
                            textAlign: TextAlign.center,
                            hintText: 'OKAY!!',
                            textSize: 32,
                            hintColor: Colors.white,
                            fontfamily: 'summary',
                          ),
                        ),
                      ],
                    )),
              ),
            ],
          )
        ],
      );
    },
  );
}
