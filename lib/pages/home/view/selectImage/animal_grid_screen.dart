import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:KidsPlan/pages/home/view/selectImage/select_image_game.dart';
import 'package:lottie/lottie.dart';

import '../../../../color.dart';
import '../../../../custom/simpleText.dart';
import '../../../../image.dart';
import '../../../../routes/app_routes.dart';
import '../../../../string.dart';
import '../../../initial/view/select_game_screen.dart';
import '../../controller/selectImage/animal_grid_controller.dart';

class AnimalGridScreen extends GetView<AnimalGridController> {
  @override
  Widget build(BuildContext context) {
    Get.put(AnimalGridController());
    return GetBuilder<AnimalGridController>(
        init: AnimalGridController(),
        builder: (context) {
          return WillPopScope(
              onWillPop: () async {
                Get.to(SelectGameScreen());
                return true;
              },
              child: Scaffold(body: _bodyWidget(controller)));
        });
  }
}

_bodyWidget(AnimalGridController controller) {
  return Stack(
    alignment: Alignment.bottomCenter,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
              child: Image.asset(
            appgameBg,
            fit: BoxFit.fill,
          )),
        ],
      ),
      SafeArea(
        child: Column(
          children: [
            Expanded(
                flex: 2,
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                              onTap: () {
                                Get.offAllNamed(AppRoutes.selectGameScreen);
                              },
                              child: Image.asset(appBack)),
                        ),
                        Flexible(
                          child: CustomSimpleTextField(
                            hintText: 'Welcome, ${
                                controller.truncateText(
                                    '${controller.AvtarName}!',11
                                )
                            } ',
                            textSize: 32,
                            hintColor: appyellowColor,
                            fontfamily: 'summary',
                          ),
                        ),
                        SizedBox(
                          width: 35,
                        )
                      ],
                    ),
                    Flexible(
                      child: CustomSimpleTextField(
                        hintText: txtGameSelect,
                        textSize: MediaQuery.of(Get.context!).size.width * 0.05,
                        hintColor: blackColor,
                        fontfamily: 'summary',
                      ),
                    )
                  ],
                )),
            Expanded(
              flex: 9,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of columns
                    crossAxisSpacing: 8.0, // Spacing between columns
                    mainAxisSpacing: 8.0, // Spacing between rows
                  ),
                  itemCount: controller.yourDataList.length,
                  // Replace with your actual data list length
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: GestureDetector(
                        onTap: () {
                          controller.playAudio();
                          Get.to(SelectImageScreen(), arguments: {
                            'roleId': controller.yourDataList[index].roleId,
                          });
                          print(controller.yourDataList[index].roleId);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient:
                                  controller.yourDataList[index].gradientColor),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                controller.yourDataList[index].imageUrl,
                                // Replace with the image URL from your data model
                                height: 80, // Adjust the height as needed
                                width: 80, // Adjust the width as needed
                                fit: BoxFit.cover,
                              ),
                              SizedBox(height: 8.0),
                              Flexible(
                                child: CustomSimpleTextField(
                                  hintText: controller.yourDataList[index].name,
                                  textSize: 20,
                                  hintColor: Colors.white,
                                  fontfamily: 'summary',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ); // Replace with your data model
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      Row(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Hero(tag: 'heroTag',
              child: Lottie.asset('assets/robt.json',height: 140,)),
          Container(

            decoration: BoxDecoration(
                color:appPinkColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(25),
                  topLeft:Radius.circular(25),
                  bottomRight: Radius.circular(25),
                )
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: CustomSimpleTextField(letterpsacingValue: true,
                textSizeValue: true,
                textAlign: TextAlign.center,
                hintText: controller.text,
                textSize: MediaQuery.of(Get.context!).size.width * 0.04,
                hintColor: Colors.white,
                fontfamily: 'summary',
              ),
            ),
          ),
        ],
      ),
    ],
  );
}
