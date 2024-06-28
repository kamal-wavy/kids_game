import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../../color.dart';
import '../../../../custom/simpleText.dart';
import '../../../../image.dart';
import '../../controller/spelling/select_spelling_controller.dart';

class SelectSpellingScreen extends GetView<SelectSpellingController> {
  @override
  Widget build(BuildContext context) {
    Get.put(SelectSpellingController());
    return WillPopScope(
      onWillPop: () async {
        controller.togglePlayPause();
        return true;
        // return false;
      },
      child: GetBuilder<SelectSpellingController>(
          init: SelectSpellingController(),
          builder: (context) {
            return WillPopScope(
                onWillPop: () async {
                  return false;
                },
                child: Scaffold(body: _bodyWidget(controller)));
          }),
    );
  }
}

_bodyWidget(SelectSpellingController controller) {
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
                        child: Image.asset(appTips)),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 9,
              child: Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: completeBody(controller)),
            ),
          ],
        ),
      ),
      controller.start == 1
          ? Lottie.asset(
              fit: BoxFit.fill,
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

completeBody(SelectSpellingController controller) {
  if (controller.currentIndex >=
      (controller.getRoleId == '1'
          ? controller.colorList.length
          : controller.getRoleId == '2'
              ? controller.vegetableList.length
              : controller.bodyPartsList.length)) {
    return null;
    //controller.dh()
    // );
  } else {
    final color = controller.getRoleId == '1'
        ? controller.colorList[controller.currentIndex]
        : controller.getRoleId == '2'
            ? controller.vegetableList[controller.currentIndex]
            : controller.bodyPartsList[controller.currentIndex];
    Color backgroundColor;

    if (controller.getRoleId == '2') {
      switch (color['correct']?.toLowerCase()) {
        case 'brinjal':
          controller.image = Image.asset(appbrinjal);
          break;
        case 'tomato':
          controller.image = Image.asset(apptomato);
          break;
        case 'carrot':
          controller.image = Image.asset(appcarrot);
          break;
        case 'potato':
          controller.image = Image.asset(apppotato);
          break;
        case 'onion':
          controller.image = Image.asset(apponion);
          break;
        case 'cabbage':
          controller.image = Image.asset(appcabbage);
          break;
        case 'broccoli':
          controller.image = Image.asset(appbrocoli);
          break;
        case 'spinach':
          controller.image = Image.asset(appspinach);
          break;
        case 'mushroom':
          controller.image = Image.asset(appmushroom);
          break;
        case 'mint':
          controller.image = Image.asset(appmint);
          break;
        default:
          controller.image = Image.network(
              'https://cdn-icons-png.flaticon.com/128/1790/1790387.png');
          break;
      }
    } else if (controller.getRoleId == '3') {
      switch (color['correct']?.toLowerCase()) {
        case 'nose':
          controller.image = Image.asset(appnose);
          break;
        case 'ear':
          controller.image = Image.asset(appear);
          break;
        case 'hand':
          controller.image = Image.asset(apphand);
          break;
        case 'heart':
          controller.image = Image.asset(appheart);
          break;
        case 'eye':
          controller.image = Image.asset(appeye);
          break;

        case 'lips':
          controller.image = Image.asset(applips);
          break;
        case 'leg':
          controller.image = Image.asset(appleg);
          break;
        case 'foot':
          controller.image = Image.asset(appfoot);
          break;
        case 'arm':
          controller.image = Image.asset(apparm);
          break;
        case 'neck':
          controller.image = Image.asset(appneck);
          break;
        default:
          controller.image = Image.asset(appnose);
          break;
      }
    }
    switch (color['correct']?.toLowerCase()) {
      case 'red':
        backgroundColor = Colors.red;
        break;
      case 'blue':
        backgroundColor = Colors.blue;
        break;
      case 'green':
        backgroundColor = Colors.green;
        break;
      case 'brown':
        backgroundColor = Colors.brown;
        break;
      case 'orange':
        backgroundColor = Colors.orange;
        break;
      case 'pink':
        backgroundColor = Colors.pink;
        break;
      case 'purple':
        backgroundColor = Colors.purple;
        break;
      case 'black':
        backgroundColor = Colors.black;
        break;
      case 'maroon':
        backgroundColor = Color(0xff590505);
        break;
      case 'grey':
        backgroundColor = Colors.grey;
        break;
      default:
        backgroundColor = Colors.white; // Default to white for unknown colors
        break;
    }

    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircleAvatar(
          radius: MediaQuery.of(Get.context!).size.height * 0.07,
          backgroundColor: backgroundColor,
          child: controller.image,
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: CustomSimpleTextField(
              textAlign: TextAlign.center,
              hintText: 'Select the right spelling box:',
              fontfamily: 'summary',
              textSize: MediaQuery.of(Get.context!).size.width * 0.06,
              hintColor: blackColor,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: buildBoxes(backgroundColor, controller),
          ),
        ),
        controller.showText == true
            ? CustomSimpleTextField(
                textSizeValue: true,
                hintText: controller.message,
                fontfamily: 'summary',
                textSize: 30,
                hintColor: controller.message == 'Correct!'
                    ? appLightGreenColor
                    : appRedColor,
              )
            : Text(''),
      ],
    );
  }
}

List<Widget> buildBoxes(
    Color backgroundColor, SelectSpellingController controller) {
  return controller.shuffledSpellings
      .map(
        (part) => Padding(
          padding: const EdgeInsets.all(2.0),
          child: GestureDetector(
            onTap: () {
              controller.checkSpelling(part);
            },
            child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10.0, left: 80, right: 80),
                    child: Container(
                      width: MediaQuery.of(Get.context!).size.width,
                      decoration: BoxDecoration(
                          color: appPinkColor,
                          borderRadius: BorderRadius.circular(40)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomSimpleTextField(
                          textAlign: TextAlign.center,
                          textSizeValue: true,
                          hintText: part,
                          fontfamily: 'Montstreat',
                          textSize:
                              MediaQuery.of(Get.context!).size.height * 0.03,
                          hintColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  // Add more widgets as needed
                ],
              ),
            ),
          ),
        ),
      )
      .toList();
}

showDialogBox(SelectSpellingController controller) {
  return showDialog<void>(
    context: Get.context!,
    builder: (BuildContext context) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(apphow, height: MediaQuery.of(context).size.width * 0.9),
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
                        "We have an image with three different spellings related to the image's content. We select the correct one, then proceed to the next step. Otherwise, an error is displayed on the screen.",
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
