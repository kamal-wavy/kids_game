import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:KidsPlan/color.dart';

import '../../../../custom/simpleText.dart';
import '../../../../image.dart';
import '../../controller/image/image_picked_solve_controller.dart';

class ImagePickedSolveScreen extends GetView<ImagePickedSolveController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ImagePickedSolveController>(
        init: ImagePickedSolveController(),
        builder: (context) {
          return Scaffold(body: _bodyWidget(controller));
        });
  }
}

_bodyWidget(ImagePickedSolveController controller) {
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
              child: Container(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 0.0,
                    crossAxisSpacing: 0.0,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: controller.puzzlePieces!.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        controller.onPieceTap(index);
                      },
                      child: controller.buildPuzzlePiece(index),
                    );
                  },
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                controller.getRoleId == '0'
                    ? Image.asset(controller.getImage ?? "",
                        height: 80, width: 80, fit: BoxFit.fill)
                    : Image.file(
                        controller.image!,
                        height: 80,
                        width: 80,
                        fit: BoxFit.fill,
                      ),
                GestureDetector(
                  onTap: () {
                    controller.update();
                    controller.stopTimer();
                    controller.startGame();
                    controller.moves = 0;
                    controller.shufflePuzzle();
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

showDialogBox(ImagePickedSolveController controller) {
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
                    hintText: "Reassemble the scrambled image by sliding "
                        "puzzle pieces into the empty space. Rearrange "
                        "pieces to complete the picture and solve the puzzle.",
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
