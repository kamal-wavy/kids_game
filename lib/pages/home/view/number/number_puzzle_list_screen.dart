import 'package:KidsPlan/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../../custom/simpleText.dart';
import '../../../../image.dart';
import '../../../../string.dart';
import '../../../initial/view/select_game_screen.dart';
import '../../controller/number/number_puzzle_list_controller.dart';
import 'new_number_slide_solve.dart';
import 'numner_history.dart';

class NumberPuzzleListScreen extends GetView<NumberPuzzleListController> {
  @override
  Widget build(BuildContext context) {
    Get.put(NumberPuzzleListController());
    return GetBuilder<NumberPuzzleListController>(
        init: NumberPuzzleListController(),
        builder: (context) {
          return Scaffold(body: _bodyWidget(controller));
        });
  }
}

_bodyWidget(NumberPuzzleListController controller) {
  return Stack(
    alignment: Alignment.bottomCenter,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                      onTap: () {
                        // Get.to(SelectGameScreen());
                        // Get.to(() => SelectGameScreen());
                        Get.offAll(SelectGameScreen());
                      },
                      child: Image.asset(appBack)),
                ),
                CustomSimpleTextField(
                  hintText: txtGameLevel,
                  fontfamily: 'summary',
                  textSize: MediaQuery.of(Get.context!).size.height * 0.04,
                  hintColor: appColor,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                      onTap: () {
                        Get.to(NumberHistoryScreen());
                      },
                      child: Image.asset(appHistory)),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.containerList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 30.0, right: 30, bottom: 10, top: 10),
                      child: GestureDetector(
                        onTap: () {
                          Get.to(NewNumberPuzzleSlideSolveScreen(), arguments: {
                            'numGrid': controller.containerList[index],
                            'boxLength': controller.containerList[index] == '1'
                                ? 9
                                : controller.containerList[index] == '2'
                                    ? 16
                                    : 25,
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: appLightGreenColor,
                              borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.orange,
                                    width: 10,
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Center(
                                  child: CustomSimpleTextField(
                                    textSizeValue: true,
                                    hintText: controller.containerList[index] ==
                                            '1'
                                        ? '3*3'
                                        : controller.containerList[index] == '2'
                                            ? '4*4'
                                            : '5*5',
                                    fontfamily: 'Montstreat',
                                    textSize: MediaQuery.of(Get.context!)
                                            .size
                                            .height *
                                        0.03,
                                    hintColor: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
      controller.isNumberPuzzleRobotShown == false
          ? checkRobot(controller)
          : Text('')
      // controller.showRobot()

      //  Row(
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //    children: [
      //      Hero(tag: 'heroTag',
      //      child: Lottie.asset('assets/robt.json',height: 140,)),
      //      Expanded(
      //        child: Container(
      //
      //          decoration: BoxDecoration(
      //              color:appPinkColor,
      //              borderRadius: BorderRadius.only(
      //                topRight: Radius.circular(25),
      //                topLeft:Radius.circular(25),
      //                bottomRight: Radius.circular(25),
      //              )
      //          ),
      //          child: Padding(
      //            padding: const EdgeInsets.all(8),
      //            child: CustomSimpleTextField(letterpsacingValue: true,
      //              textSizeValue: true,
      //              textAlign: TextAlign.center,
      //              hintText: controller.text,
      //              textSize: MediaQuery.of(Get.context!).size.width * 0.04,
      //              hintColor: Colors.white,
      //              fontfamily: 'summary',
      //            ),
      //          ),
      //        ),
      //      ),
      //    ],
      //  ),
    ],
  );
}

Widget checkRobot(NumberPuzzleListController controller) {
  if (!controller.isNumberPuzzleRobotShown) {
    // Display UI containing Lottie animation and text field
    Widget robotUI = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Hero(
          tag: 'heroTag',
          child: Lottie.asset(
            'assets/robt.json',
            height: 140,
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: appPinkColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(25),
                topLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: CustomSimpleTextField(
                letterpsacingValue: true,
                textSizeValue: true,
                textAlign: TextAlign.center,
                hintText: controller.text,
                textSize: MediaQuery.of(Get.context!).size.width * 0.04,
                hintColor: Colors.white,
                fontfamily: 'summary',
              ),
            ),
          ),
        ),
      ],
    );

    // Write to controller.box that isNumberPuzzleRobotShown is true
    // controller.box.write('isNumberPuzzleRobotShown', true);

    return robotUI; // Return the UI
  } else {
    return Text('kamalmal'); // Return the text widget
  }
}

showDialogBox(NumberPuzzleListController controller) {
  return showDialog<void>(
    context: Get.context!,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('How to play this game!!'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Given a name, display multiple"
                " images below. Your task is to select the"
                " correct image that matches the given name. If your selection"
                " is correct,"
                " proceed to the next round; otherwise, display an error message."),
          ],
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              controller.playAudio();
              Get.back();
            },
          ),
        ],
      );
    },
  );
}
