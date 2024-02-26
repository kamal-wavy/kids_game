import 'package:KidsPlan/color.dart';
import 'package:KidsPlan/custom/simpleText.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../../image.dart';
import '../../controller/math/math_quiz_solve_controller.dart';

class MathQuizSolveScreen extends GetView<MathQuizSolveController> {
  @override
  Widget build(BuildContext context) {
    Get.put(MathQuizSolveController());
    return WillPopScope(
      onWillPop: () async {
        controller.togglePlayPause();
        return true;
        // return false;
      },
      child: GetBuilder<MathQuizSolveController>(
          init: MathQuizSolveController(),
          builder: (context) {
            return Scaffold(body: _bodyWidget(controller));
          }),
    );
  }
}

_bodyWidget(MathQuizSolveController controller) {
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

            // ConfettiWidget(
            //   confettiController: controller.blastController,
            //   shouldLoop: true,
            //   blastDirectionality: BlastDirectionality.explosive,
            //   maxBlastForce: 100,
            //   numberOfParticles: 50,
            // ),
            Expanded(
              flex: 9,
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(15.0),
                            child: CustomSimpleTextField(
                              textAlign: TextAlign.center,
                              hintText: 'Choose the correct calculation',
                              fontfamily: 'summary',
                              textSize:
                                  MediaQuery.of(Get.context!).size.height *
                                      0.03,
                              hintColor: appPinkColor,
                            ),
                          ),
                          Stack(alignment: Alignment.center, children: [
                            Image.asset(appMathbtn),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomSimpleTextField(
                                    textSizeValue: true,
                                    hintText: controller.getRoleId == '1'
                                        ? "${controller.num1} + ${controller.num2} ="
                                        : controller.getRoleId == '2'
                                            ? "${controller.num1} - ${controller.num2} ="
                                            : controller.getRoleId == '3'
                                                ? "${controller.num1} * ${controller.num2} ="
                                                : "${controller.num1} / ${controller.num2} =",
                                    fontfamily: 'Montstreat',
                                    textSize:
                                        MediaQuery.of(Get.context!).size.width *
                                            0.10,
                                    hintColor: Colors.white,
                                  ),
                                  Image.asset(appQuestion),
                                ],
                              ),
                            )
                          ]),
                          controller.getRoleId == '4'
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      for (double option
                                          in controller.answerOptionsDivision)
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: GestureDetector(
                                              onTap: () {
                                                controller
                                                    .checkDivisionGame(option);
                                              },
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Image.asset(appMathBox),
                                                  CustomSimpleTextField(
                                                    textSizeValue: true,
                                                    hintText: hasDecimal(option)
                                                        ? option
                                                            .toStringAsFixed(1)
                                                        : option.toString(),
                                                    fontfamily: 'Montstreat',
                                                    textSize: MediaQuery.of(
                                                                Get.context!)
                                                            .size
                                                            .width *
                                                        0.06,
                                                    hintColor: Colors.white,
                                                  ),
                                                ],
                                              )),
                                        ),
                                    ],
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      for (int option
                                          in controller.answerOptions)
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: GestureDetector(
                                              onTap: () {
                                                controller.checkGame(option);
                                              },
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Image.asset(appMathBox),
                                                  CustomSimpleTextField(
                                                    textSizeValue: true,
                                                    hintText: option.toString(),
                                                    fontfamily: 'Montstreat',
                                                    textSize: MediaQuery.of(
                                                                Get.context!)
                                                            .size
                                                            .width *
                                                        0.08,
                                                    hintColor: Colors.white,
                                                  ),
                                                ],
                                              )),
                                        ),
                                    ],
                                  ),
                                ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            controller.generateQuestion();
                            controller.update();
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.asset(appPlaybtn),
                              CustomSimpleTextField(
                                textSizeValue: true,
                                hintText: 'Skip',
                                fontfamily: 'summary',
                                textSize:
                                    MediaQuery.of(Get.context!).size.width *
                                        0.08,
                                hintColor: Colors.white,
                              ),
                            ],
                          ),
                        ),
                        CustomSimpleTextField(
                          hintText: 'Question:  ${controller.currentStep} / 11',
                          fontfamily: 'Montstreat',
                          textSize:
                              MediaQuery.of(Get.context!).size.width * 0.05,
                          hintColor: appColor,
                        ),
                      ],
                    ),
                    controller.showMessage
                        ? CustomSimpleTextField(
                            hintText: controller.message,
                            fontfamily: 'summary',
                            textSize: 30,
                            hintColor: controller.message == 'Correct!'
                                ? appLightGreenColor
                                : appRedColor,
                          )
                        : Container(),
                  ],
                ),
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

bool hasDecimal(double number) {
  // Check if the number has a decimal part
  return number % 1 != 0;
}

showDialogBox(MathQuizSolveController controller) {
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
                padding: EdgeInsets.only(
                    top: MediaQuery.of(Get.context!).size.height * 0.01),
                child: SizedBox(
                  width: MediaQuery.of(Get.context!).size.width * 0.6,
                  // height: MediaQuery.of(Get.context!).size.height * 0.2,
                  child: CustomSimpleTextField(
                    textAlign: TextAlign.center,
                    hintText: controller.getRoleId == '1'
                        ? "Add the two given numbers,"
                            " and the sum is displayed in three options "
                            "at the bottom. Select the correct one to proceed to the"
                            " next question,"
                            " and use the skip button to change the question."
                        : controller.getRoleId == '2'
                            ? "Subtract the two given numbers,"
                                " and the result is displayed in three options "
                                "at the bottom. Select the correct one to proceed to the"
                                " next question,"
                                " and use the skip button to change the question."
                            : controller.getRoleId == '3'
                                ? "Multiple of two given numbers,"
                                    " and the result is displayed in three options "
                                    "at the bottom. Select the correct one to proceed to the"
                                    " next question,"
                                    " and use the skip button to change the question."
                                : "Division between two given numbers,"
                                    " and the result is displayed in three options "
                                    "at the bottom. Select the correct one to proceed to the"
                                    " next question,"
                                    " and use the skip button to change the question.",
                    hintColor: blackColor,
                    textSize: MediaQuery.of(Get.context!).size.width * 0.04,
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
                        width: MediaQuery.of(context).size.width * 0.6,
                      ),
                      Center(
                        child: CustomSimpleTextField(
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
