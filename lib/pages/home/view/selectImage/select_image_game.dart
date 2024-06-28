import 'package:KidsPlan/color.dart';
import 'package:KidsPlan/custom/simpleText.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../../image.dart';
import '../../controller/selectImage/select_image_game_controllr.dart';

class SelectImageScreen extends GetView<SelectImageController> {
  const SelectImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SelectImageController());
    return WillPopScope(
      onWillPop: () async {
        controller.togglePlayPause();
        return true;

        // return false;
      },
      child: GetBuilder<SelectImageController>(
          init: SelectImageController(),
          builder: (context) {
            return Scaffold(body: _bodyWidget(controller));
          }),
    );
  }
}

_bodyWidget(SelectImageController controller) {
  final currentImageSet =
      controller.animalImageSets[controller.currentSetIndex]['imageSet'];
  final currentAnimal =
      controller.animalImageSets[controller.currentSetIndex]['animalName']![0];

  final currentImageSet1 =
      controller.fruitImageSets[controller.currentSetIndex]['imageSet'];
  final currentAnimal1 =
      controller.fruitImageSets[controller.currentSetIndex]['animalName']![0];

  // final currentImageSet2 =
  //     controller.stationaryImageSets[controller.currentSetIndex]['imageSet'];
  // final currentAnimal2 = controller
  //     .stationaryImageSets[controller.currentSetIndex]['animalName']![0];
  final currentImageSet2 =
      controller.hindiImageSets[controller.currentSetIndex]['imageSet'];
  final currentAnimal2 =
      controller.hindiImageSets[controller.currentSetIndex]['animalName']![0];

  final currentImageSet3 =
      controller.birdsImageSets[controller.currentSetIndex]['imageSet'];
  // print(currentImageSet3);
  final currentAnimal3 =
      controller.birdsImageSets[controller.currentSetIndex]['animalName']![0];

  print('foooooooooooooooooo');
  print(currentAnimal3);
  print('errrrrrrrrrrrr');
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
                                  /* CustomSimpleTextField(
                                  hintText: controller
                                      .formatTime(controller.secondsElapsed),
                                  hintColor: Colors.white,
                                  textSize: 20,
                                  fontfamily: 'summary',
                                )*/
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
              flex: 9,
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(15.0),
                        child: CustomSimpleTextField(
                          textAlign: TextAlign.center,
                          hintText: 'Choose the correct '
                              '${controller.getRoleId == '1' ? 'Birds' :
                          controller.getRoleId == '2' ? 'Hindi Words' :
                          controller.getRoleId == '3' ? 'Fruit' : 'Animal'}:',
                          fontfamily: 'summary',
                          textSize:
                              MediaQuery.of(Get.context!).size.height * 0.03,
                          hintColor: blackColor,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // CustomSimpleTextField(
                        //   hintText: '${controller.imageSetIndex}.',
                        //   fontfamily: 'Montstreat',
                        //   textSize: 25,
                        //   hintColor: blackColor,
                        // ),controller.getRoleId == '2' ? currentAnimal2![0].toUpperCase() + currentAnimal2!.substring(1).toLowerCase()

                        controller.getRoleId == '2'
                            ? currentAnimal2![0].toUpperCase() == 'O'
                                ? Image.asset(
                                    'assets/hindi/s.png',
                                    height: 120,
                                  )
                                : currentAnimal2![0].toUpperCase() == 'W'
                                    ? Image.asset('assets/hindi/ta.png',
                                        height: 100)
                                    : currentAnimal2![0].toUpperCase() == 'B'
                                        ? Image.asset('assets/hindi/k.png',
                                            height: 100)
                                        : currentAnimal2![0].toUpperCase() ==
                                                'M'
                                            ? Image.asset('assets/hindi/aa.png',
                                                height: 120)
                                            : currentAnimal2![0]
                                                        .toUpperCase() ==
                                                    'S'
                                                ? Image.asset(
                                                    'assets/hindi/ch.png',
                                                    height: 120,
                                                  )
                                                : currentAnimal2![0]
                                                            .toUpperCase() ==
                                                        'G'
                                                    ? Image.asset(
                                                        'assets/hindi/a.png',
                                                        height: 120)
                                                    : currentAnimal2![0]
                                                                .toUpperCase() ==
                                                            'P'
                                                        ? Image.asset(
                                                            'assets/hindi/k.png',
                                                            height: 100)
                                                        : currentAnimal2![0]
                                                                    .toUpperCase() ==
                                                                'R'
                                                            ? Image.asset(
                                                                'assets/hindi/s.png',
                                                                height: 120,
                                                              )
                                                            : currentAnimal2![0]
                                                                        .toUpperCase() ==
                                                                    'G'
                                                                ? Image.asset(
                                                                    'assets/hindi/s2.png')
                                                                : currentAnimal2![0]
                                                                            .toUpperCase() ==
                                                                        'A'
                                                                    ? Image.asset(
                                                                        'assets/hindi/s.png',
                                                                        height:
                                                                            120,
                                                                      )
                                                                    : currentAnimal2![0].toUpperCase() == 'K'
                                                                        ? Image.asset(
                                                                            'assets/hindi/p.png',
                                                                            height:
                                                                                120,
                                                                          )
                                                                        : currentAnimal2![0].toUpperCase() == 'F'
                                                                            ? Image.asset(
                                                                                'assets/hindi/ga.png',
                                                                                height: 120,
                                                                              )
                                                                            : Image.asset(appHistory)
                            : Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: CustomSimpleTextField(
                                  hintText:
                                      ' ${controller.getRoleId == '1' ?
                                      currentAnimal3![0].toUpperCase() + currentAnimal3!.substring(1).toLowerCase() : controller.getRoleId == '2' ? currentAnimal2![0].toUpperCase() + currentAnimal2!.substring(1).toLowerCase() : controller.getRoleId == '3' ? currentAnimal1![0].toUpperCase() + currentAnimal1!.substring(1).toLowerCase() : currentAnimal![0].toUpperCase() + currentAnimal!.substring(1).toLowerCase()} ',
                                  fontfamily: 'summary',
                                  textSize: 40,
                                  hintColor: appColor,
                                ),
                              )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          for (String image in controller.getRoleId == '1'
                              ? currentImageSet3!
                              : controller.getRoleId == '2'
                                  ? currentImageSet2!
                                  : controller.getRoleId == '3'
                                      ? currentImageSet1!
                                      : currentImageSet!)
                            GestureDetector(
                              onTap: () {
                                controller.playAudio();
                                controller.checkAnswer(image);
                              },
                              child: Image.asset(
                                  controller.getRoleId == '1'
                                      ? 'assets/birds/$image'
                                      : controller.getRoleId == '2'
                                          ? 'assets/fruit/$image'
                                          // ? 'assets/stationary/$image'
                                          : controller.getRoleId == '3'
                                              ? 'assets/fruit/$image'
                                              : 'assets/animal/$image',
                                  width: 80,
                                  height: 80),
                            ),
                        ],
                      ),
                    ),
                    controller.showText == true
                        ? CustomSimpleTextField(
                            hintText: controller.message,
                            fontfamily: 'summary',
                            textSize: 30,
                            hintColor: controller.message == 'Correct!'
                                ? appLightGreenColor
                                : appRedColor,
                          )
                        : Text(''),
                  ],
                ),
              ),
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

showDialogBox(SelectImageController controller) {
  return showDialog<void>(
    context: Get.context!,
    builder: (BuildContext context) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(apphow,height:  MediaQuery.of(context).size.width * 0.9),
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
                    hintText: "Given a name, display multiple"
                        " images below. Your task is to select the"
                        " correct image that matches the given name. If your selection"
                        " is correct,"
                        " proceed to the next round; otherwise, display an error message.",
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
