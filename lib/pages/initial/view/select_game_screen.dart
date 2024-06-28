import 'package:KidsPlan/color.dart';
import 'package:KidsPlan/custom/simpleText.dart';
import 'package:KidsPlan/image.dart';
import 'package:KidsPlan/pages/home/view/chnages+word/chnage_screen.dart';
import 'package:KidsPlan/pages/home/view/word/word_option_list.dart';
import 'package:KidsPlan/pages/initial/controller/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../app_argument.dart';
import '../../../dlt.dart';
import '../../home/view/math/math_grid.dart';
import '../../home/view/memory/memory_grid.dart';
import '../../home/view/number/number_puzzle_list_screen.dart';
import '../../home/view/pair/pair_grid.dart';
import '../../home/view/selectImage/animal_grid_screen.dart';
import '../../home/view/spelling/spelling_grid_screen.dart';
import '../../home/view/story/stories_oprtions_grid.dart';
import '../../home/view/tictoe/select_tic_toe_avtar_screen.dart';
import '../controller/select_game_contoller.dart';

class SelectGameScreen extends GetView<SelectGameController> {
  @override
  Widget build(BuildContext context) {
    Get.put<SelectGameController>(SelectGameController());
    return GetBuilder<SelectGameController>(
        init: SelectGameController(),
        builder: (context) {
          return WillPopScope(
              onWillPop: () async {
                SystemNavigator.pop();
                return true;
              },
              child: Scaffold(body: _bodyWidget(controller)));
        });
  }
}

_bodyWidget(SelectGameController controller) {
  return Stack(
    alignment: Alignment.bottomCenter,
    children: [
      Image.asset(
        height: MediaQuery.of(Get.context!).size.height,
        width: MediaQuery.of(Get.context!).size.height,
        appgameBg,
        fit: BoxFit.fill,
      ),
      Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: appLightGreenColor,
                image: DecorationImage(
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.grey.withOpacity(0.6),
                      // Adjust the opacity value as needed
                      BlendMode.darken,
                    ),
                    image: controller.assetImage!),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30))),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 15, right: 15, top: 20, bottom: 20),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius:
                              MediaQuery.of(Get.context!).size.height.toInt() *
                                  0.04,
                          backgroundColor: appBackColor,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Image.asset(controller.AvtarImage ?? ""
                                // apppp
                                ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CustomSimpleTextField(
                                    hintText: int.parse(DateFormat("HH")
                                                .format(DateTime.now())) <
                                            12
                                        ? "Good Morning"
                                        : int.parse(DateFormat("HH")
                                                    .format(DateTime.now())) <
                                                16
                                            ? "Good AfterNoon"
                                            : int.parse(DateFormat("HH").format(
                                                        DateTime.now())) <
                                                    21
                                                ? "Good Evening"
                                                : "Good night",
                                    textSizeValue: true,
                                    textSize: MediaQuery.of(Get.context!)
                                            .size
                                            .height
                                            .toInt() *
                                        0.03,
                                    //24,
                                    // borderLineValue: true,
                                    fontfamily: 'summary',
                                    // hintColor: appyellowColor,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: Image.asset(
                                      appSmile,
                                      height: 25,
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  CustomSimpleTextField(
                                    letterpsacingValue: true,
                                    textSizeValue: true,
                                    borderLineValue: true,
                                    hintText: controller.truncateText(
                                            controller.editName == 1
                                                ? controller
                                                    .textFieldController.text
                                                : controller.AvtarName,
                                            13) ??
                                        "",
                                    // hintText: controller.AvtarName ?? "",
                                    textSize: MediaQuery.of(Get.context!)
                                            .size
                                            .height
                                            .toInt() *
                                        0.03,
                                    hintColor: appyellowColor,
                                    fontfamily: 'summary',
                                  ),
                                  Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: GestureDetector(
                                          onTap: () {
                                            _showResumePopup(controller);
                                          },
                                          child: Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                          )))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                        onPressed: () {
                          showDialogBox(controller);
                        },
                        icon: Icon(
                          Icons.settings,
                          color: Colors.white,
                          size: 30,
                        ))
                  ],
                ),
              ),
            ),
          ),
          Expanded(
              // flex: 7,
              flex: MediaQuery.of(Get.context!).size.height.toInt() * 2,
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 15.0, right: 15, bottom: 15),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    //  controller.calculateCrossAxisCount(Get.context!),
                    crossAxisSpacing: 15.0,
                    mainAxisSpacing: 15.0,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        controller.playAudio();
                        controller.mixedData[index].num == 1
                            ? Get.to(() => NumberPuzzleListScreen())
                            // Get.to(NumberPuzzleListScreen())
                            : controller.mixedData[index].num == 3
                                ? Get.to(AnimalGridScreen())
                                : controller.mixedData[index].num == 4
                                    ? Get.to(SpellingGridScreen())
                                    : controller.mixedData[index].num == 5
                                        ? Get.to(TicToeSelectAvtarScreen())
                                        : controller.mixedData[index].num == 6
                                            ? Get.to(PairGridScreen())
                                            : controller.mixedData[index].num ==
                                                    7
                                                ? Get.to(MathGridScreen())
                                                : controller.mixedData[index]
                                                            .num ==
                                                        9
                                                    ? Get.to(
                                                        StoryOptionGridScreen())
                                                    : controller
                                                                .mixedData[
                                                                    index]
                                                                .num ==
                                                            10
                                                        ? 
                         //   Navigator.push(context, MaterialPageRoute(builder: (context)=>WordSearch()))
                        Get.to(

                          // WordSearchGame(
                          //   words: ['FLUTTER', 'WORD', 'SEARCH', 'GAME'],
                          //   gridSize: 10,
                          // ),
                                                   WordOptionListScreen()
                        )
                                                        : Get.to(
                                                            MemoryGridScreen());

                        controller.incrementGamesPlayed();
                        if (controller.gamesPlayed.value == 5) {
                          // controller.requestReview();
                          controller.showReviewDialog();
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.4),
                                  // Adjust the opacity value as needed
                                  BlendMode.darken,
                                ),
                                fit: BoxFit.cover,
                                image: AssetImage(
                                    controller.mixedData[index].imagePathBg)),
                            color: controller.mixedData[index].color,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [shadow]),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                controller.mixedData[index].imagePath,
                                height:
                                    MediaQuery.of(Get.context!).size.height *
                                        0.07,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 8.0, bottom: 2),
                                child: CustomSimpleTextField(
                                  hintText: controller.mixedData[index].title,
                                  textSizeValue: true,
                                  textSize:
                                      MediaQuery.of(context).size.height * 0.02,
                                  hintColor: Colors.white,
                                  fontfamily: 'Monstreat',
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 5.0, right: 5, bottom: 5),
                                child: CustomSimpleTextField(
                                  hintText:
                                      controller.mixedData[index].subtitle,
                                  textSizeValue: true,
                                  textSize:
                                      MediaQuery.of(context).size.height * 0.02,
                                  hintColor: Colors.white,
                                  fontfamily: 'Monstreat',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: controller.mixedData.length,
                ),
              )),
        ],
      ),
    ],
  );
}

showDialogBox(SelectGameController controller) {
  showDialog<void>(
    context: Get.context!,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: Material(
          type: MaterialType.transparency,
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  appBgMusic,
                  height: MediaQuery.of(Get.context!).size.height * 0.4,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(Get.context!).size.height * 0.09,
                      ),
                      child: SizedBox(
                        width: MediaQuery.of(Get.context!).size.width * 0.6,
                        child: CustomSimpleTextField(
                          textAlign: TextAlign.center,
                          hintText: 'Background Music',
                          textSize:
                              MediaQuery.of(Get.context!).size.width * 0.07,
                          hintColor: appPinkColor,
                          fontfamily: 'summary',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Column(
                        children: [
                          Obx(
                            () => Transform.scale(
                                scale: 1.2,
                                // You can adjust this value to increase or decrease the size
                                child: Switch(
                                  activeColor: appPinkColor,
                                  value: Get.find<SplashController>()
                                      .isMusicPlaying
                                      .value,
                                  onChanged: (value) {
                                    Get.find<SplashController>().toggleMusic();

                                    Get.find<SplashController>().playMusic(
                                      Get.find<SplashController>()
                                          .isMusicPlaying
                                          .value,
                                    );
                                  },
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: appColor,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CustomSimpleTextField(
                                    hintText: '   CLOSE   ',
                                    textSizeValue: true,
                                    textSize:
                                        MediaQuery.of(Get.context!).size.width *
                                            0.05,
                                    fontfamily: 'summary',
                                    hintColor: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

void _showResumePopup(SelectGameController controller) {
  showDialog(
    context: Get.context!,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              appEdit,
              height: MediaQuery.of(Get.context!).size.height * 0.4,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Material(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 80.0, right: 80, top: 20, bottom: 10),
                    child: SizedBox(
                      width: MediaQuery.of(Get.context!).size.width * 0.5,
                      child: Form(
                        key: controller.formKey,
                        child: TextFormField(
                          controller: controller.textFieldController,
                          autofocus: true,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(color: appColor, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(color: appColor, width: 2),
                            ),

                            labelText: "Your Name",
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(color: appColor, width: 2),
                            ),
                            //fillColor: Colors.green
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter name';
                            }
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                controller.alphanumericRegex),
                            FilteringTextInputFormatter.deny(RegExp("[0-9]")),
                          ],
                          keyboardType: TextInputType.emailAddress,
                          style: new TextStyle(
                            fontFamily: "Poppins",
                          ),
                        ),
                      ),
                    ),
                  ),
                  // TextFormField(
                  //         controller: controller
                  //             .textFieldController,
                  //         decoration: InputDecoration(
                  //             hintText: 'Enter Name'),
                  //       ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: GestureDetector(
                      onTap: () {
                        if (controller.formKey.currentState!.validate()) {
                          controller.userData.write(
                              userName, controller.textFieldController.text);
                          controller.editName = 1;
                          controller.update();
                          Get.back();
                        }
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(appbtn,
                              width: MediaQuery.of(context).size.width * 0.5),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomSimpleTextField(
                                textSizeValue: true,
                                underLineValue: false,
                                textAlign: TextAlign.center,
                                hintText: 'OKAY',
                                textSize:
                                    MediaQuery.of(Get.context!).size.height *
                                        0.03,
                                hintColor: Colors.white,
                                fontfamily: 'summary',
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: CustomSimpleTextField(
                    hintText: 'CANCEL',
                    textSize: MediaQuery.of(Get.context!).size.height * 0.03,
                    hintColor: appRedColor,
                    fontfamily: 'summary',
                  ),
                ),
              ],
            )
          ],
        ),
      );
    },
  );
}
