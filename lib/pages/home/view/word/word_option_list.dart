import 'package:KidsPlan/color.dart';
import 'package:KidsPlan/pages/home/view/word/word_history.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../../custom/simpleText.dart';
import '../../../../image.dart';
import '../../../../string.dart';
import '../../../initial/view/select_game_screen.dart';
import '../../controller/word/word_option_controller.dart';
import '../chnages+word/chnage_screen.dart';
import 'demo_play.dart';

class WordOptionListScreen extends GetView<WordOptionListController> {
  @override
  Widget build(BuildContext context) {
    Get.put(WordOptionListController());
    return GetBuilder<WordOptionListController>(
        init: WordOptionListController(),
        builder: (context) {
          return Scaffold(body: _bodyWidget(controller));
        });
  }
}

_bodyWidget(WordOptionListController controller) {
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
                  hintText: txtGameCategories,
                  fontfamily: 'summary',
                  textSize: MediaQuery.of(Get.context!).size.height * 0.04,
                  hintColor: appColor,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                      onTap: () {
                        Get.to(WordHistoryScreen());
                      },
                      child: Image.asset(appHistory)),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.items.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 30.0, right: 30, bottom: 10, top: 10),
                      child: GestureDetector(
                        onTap: () {
                          Get.to(
                              ChangeScreen(),
                              // WordGameScreen(),
                              arguments: {
                            'option_game': controller.items[index] == 'Animals'
                                ? 1
                                : controller.items[index] == 'Birds'
                                    ? 2
                                    : controller.items[index] == 'Vegetables'
                                        ? 3
                                        : 4

                            // 'option_game': controller.items[index] == 'Easy'
                            //     ? 6
                            //     : controller.items[index] == 'Medium'
                            //     ? 8
                            //     : 9
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
                                    hintText: controller.items[index],
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

Widget checkRobot(WordOptionListController controller) {
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

showDialogBox(WordOptionListController controller) {
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
