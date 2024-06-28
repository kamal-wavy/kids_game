import 'package:KidsPlan/pages/home/view/story/rhymes_list_screen.dart';
import 'package:KidsPlan/pages/home/view/story/test.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../color.dart';
import '../../../../custom/simpleText.dart';
import '../../../../image.dart';
import '../../../initial/controller/splash_controller.dart';
import '../../controller/story/stories_controller.dart';

class s2Screen extends GetView<StoryController> {
  @override
  Widget build(BuildContext context) {
    Get.put(StoryController());
    return GetBuilder<StoryController>(
      init: StoryController(),
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            // Stop TTS when back button is pressed
            await controller.flutterTts.stop();
            Get.offAll(StoryListScreen());
            return true; // Allow navigation
          },
          child: Scaffold(
            body: _buildBody(controller),
          ),
        );
      },
    );
  }

  Widget _buildBody(StoryController controller) {
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
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller.getGameId == '1'
                            ? Get.offAll(StoryListScreen(), arguments: {
                                'roleId': controller.getGameId,
                              })
                            : Get.offAll(RhymeListScreen(), arguments: {
                                // 'roleId': controller.getGameId,
                                'sendRoleId': controller.getRoleId,
                                'sendGameId': controller.getGameId,
                              });
                        // Get.offAll(StoryListScreen());
                        // Get.offAllNamed(AppRoutes.storyOptionGridScreen);
                        controller.flutterTts.stop();
                      },
                      child: Image.asset(appBack),
                    ),
                    CustomSimpleTextField(
                      hintText: controller.getTitle.toString(),
                      fontfamily: 'summary',
                      textSize: MediaQuery.of(Get.context!).size.height * 0.03,
                      hintColor: appPinkColor,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (controller.speaking) {
                          controller.pauseSpeech();
                          controller.speaking = false;
                          controller.update();
                        } else {
                          String text = _getCurrentText(controller);
                          controller.speakText(text);

                          controller.speaking = true;
                          Get.find<SplashController>().playMusic(
                            false,
                          );
                          controller.update();
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.pink,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Icon(
                            controller.speaking
                                ? Icons.pause
                                : Icons.volume_up_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: controller.scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Add spacing at the top
                      Obx(() {
                        String text = _getCurrentText(controller);
                        List<String> words = text.split(' '); // split by spaces
                        int currentWordIndex =
                            controller.currentWordIndex.value;

                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 25, right: 25),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 20.0, bottom: 30),
                                child: getImageWidget(
                                    controller.getNumId.toString()),
                              ),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  children:
                                      List.generate(words.length, (index) {
                                    return TextSpan(
                                      text: '${words[index]} ',
                                      style: TextStyle(
                                        letterSpacing: 1,
                                        color: index == currentWordIndex
                                            ? appPinkColor
                                            : Colors.black87,
                                        // color:  Colors.black87,
                                        fontSize: 22,
                                        fontFamily: 'summary',
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      SizedBox(height: 25), // Add spacing at the bottom
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getCurrentText(StoryController controller) {
    switch (controller.getNumId) {
      case 1:
        return controller.storyContent1.join(' ');
      case 2:
        return controller.storyContent2.join(' ');
      case 3:
        return controller.storyContent3.join(' ');
      case 4:
        return controller.storyContent4.join(' ');
      case 5:
        return controller.storyContent5.join(' ');
      case 6:
        return controller.storyContent6.join(' ');
      case 7:
        return controller.storyContent7.join(' ');
      case 8:
        return controller.storyContent8.join(' ');
      case 9:
        return controller.nurserPoems1.join(' ');
      case 10:
        return controller.nurserPoems2.join(' ');
      case 11:
        return controller.nurserPoems3.join(' ');
      case 12:
        return controller.nurserPoems4.join(' ');
      case 13:
        return controller.nurserPoems5.join(' ');
      case 14:
        return controller.nurserPoems6.join(' ');
      case 15:
        return controller.nurserPoems7.join(' ');
      case 16:
        return controller.nurserPoems8.join(' ');
      case 17:
        return controller.nurserPoems9.join(' ');
      case 18:
        return controller.nurserPoems10.join(' ');
      case 19:
        return controller.nurserPoems11.join(' ');
      case 20:
        return controller.nurserPoems12.join(' ');
      case 21:
        return controller.storyContent13.join(' ');
      case 22:
        return controller.storyContent14.join(' ');
      case 23:
        return controller.storyContent15.join(' ');
      case 24:
        return controller.storyContent16.join(' ');
      case 25:
        return controller.storyContent17.join(' ');
      case 26:
        return controller.storyContent18.join(' ');
      case 27:
        return controller.storyContent19.join(' ');
      case 28:
        return controller.storyContent20.join(' ');
      case 29:
        return controller.storyContent21.join(' ');
      case 30:
        return controller.storyContent22.join(' ');
      case 31:
        return controller.storyContent23.join(' ');
      case 32:
        return controller.storyContent24.join(' ');
      default:
        return '';
    }
  }

  Widget getImageWidget(String numId) {
    switch (numId) {
      case '1':
        return Container(
            height: MediaQuery.of(Get.context!).size.height * 0.2,
            decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.circular(15),
                image: DecorationImage(
                    image: AssetImage(appS1), fit: BoxFit.cover)));
      case '2':
        return Image.asset(appCrow);
      case '3':
        return Image.asset(appGolden);
      case '4':
        return Container(
            height: MediaQuery.of(Get.context!).size.height * 0.2,
            decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.circular(15),
                image: DecorationImage(
                    image: AssetImage(appS4), fit: BoxFit.cover)));
      case '5':
        return Image.asset(appRose);

      case '6':
        return Container(
            height: MediaQuery.of(Get.context!).size.height * 0.2,
            decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.circular(15),
                image: DecorationImage(
                    image: AssetImage(appS6), fit: BoxFit.cover)));
      case '7':
        return Image.asset(appOwl);
      case '8':
        return Image.asset(appEgg);

      case '9':
        return Image.asset(appSnowball);
      case '10':
        return Image.asset(appCroco);
      case '11':
        return Image.asset(appChildren);
      case '12':
        return Image.asset(appRabbit);
      case '13':
        return Image.asset(appLamb);
      case '14':
        return Image.asset(appKid);
      case '15':
        return Image.asset(appTea);
      case '16':
        return Image.asset(appSheep);
      case '17':
        return Image.asset(appLog);
      case '18':
        return Image.asset(appAnimal);
      case '19':
        return Image.asset(appDaffodil);
      case '20':
        return Image.asset(appIce);
      case '21':
        return Image.asset(appGarden);
      case '22':
        return Image.asset(appRace);
      case '23':
        return Image.asset(appAnt);
      case '24':
        return Container(
            height: MediaQuery.of(Get.context!).size.height * 0.2,
            decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.circular(15),
                image: DecorationImage(
                    image: AssetImage(appS13), fit: BoxFit.cover)));

      case '25':
        return Container(
            height: MediaQuery.of(Get.context!).size.height * 0.2,
            decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.circular(15),
                image: DecorationImage(
                    image: AssetImage(appA17), fit: BoxFit.cover)));

      case '26':
        return Container(
            height: MediaQuery.of(Get.context!).size.height * 0.2,
            decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.circular(15),
                image: DecorationImage(
                    image: AssetImage(appA18), fit: BoxFit.cover)));
      case '27':
        return Container(
            height: MediaQuery.of(Get.context!).size.height * 0.2,
            decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.circular(15),
                image: DecorationImage(
                    image: AssetImage(appA19), fit: BoxFit.cover)));
      case '28':
        return Container(
            height: MediaQuery.of(Get.context!).size.height * 0.2,
            decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.circular(15),
                image: DecorationImage(
                    image: AssetImage(appA20), fit: BoxFit.cover)));
      case '29':
        return Container(
            height: MediaQuery.of(Get.context!).size.height * 0.2,
            decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.circular(15),
                image: DecorationImage(
                    image: AssetImage(appC21), fit: BoxFit.cover)));
        Image.asset(appC21);
      case '30':
        return Container(
            height: MediaQuery.of(Get.context!).size.height * 0.2,
            decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.circular(15),
                image: DecorationImage(
                    image: AssetImage(appC22), fit: BoxFit.cover)));
        Image.asset(appC22);
      case '31':
        return Container(
            height: MediaQuery.of(Get.context!).size.height * 0.2,
            decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.circular(15),
                image: DecorationImage(
                    image: AssetImage(appC23), fit: BoxFit.cover)));
      case '32':
        return Container(
            height: MediaQuery.of(Get.context!).size.height * 0.2,
            decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.circular(15),
                image: DecorationImage(
                    image: AssetImage(appC24), fit: BoxFit.fill)));
      // Add more cases as needed for other values of numId
      default:
        return Image.asset(appLandscape);
    }
  }
}
