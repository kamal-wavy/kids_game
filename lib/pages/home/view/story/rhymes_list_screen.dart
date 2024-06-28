import 'package:KidsPlan/color.dart';
import 'package:KidsPlan/pages/home/view/story/s2.dart';
import 'package:KidsPlan/pages/home/view/story/stories_oprtions_grid.dart';
import 'package:KidsPlan/pages/home/view/story/test.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../custom/simpleText.dart';
import '../../../../image.dart';
import '../../controller/story/rhyme_list_controller.dart';

class RhymeListScreen extends GetView<RhymeListController> {
  @override
  Widget build(BuildContext context) {
    Get.put(RhymeListController());
    return GetBuilder<RhymeListController>(
        init: RhymeListController(),
        builder: (context) {
          return Scaffold(body: _bodyWidget(controller));
        });
  }
}

_bodyWidget(RhymeListController controller) {
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
                      // Get.offAll(StoryOptionGridScreen());
                      // Get.offAll(StoryListScreen());
                      Get.off(StoryListScreen(),arguments: {
                        'roleId':controller.getRoleId,
                      });

                      // Get.offAllNamed(AppRoutes.storyOptionGridScreen);
                    },
                    child: Image.asset(appBack)),
              ),
              CustomSimpleTextField(
                hintText: "Rhymes",
                fontfamily: 'summary',
                textSize: MediaQuery.of(Get.context!).size.height * 0.04,
                hintColor: appColor,
              ),
              SizedBox(
                width: 40,
              )
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 30.0, left: 15, right: 15),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of columns
                  crossAxisSpacing: 8.0, // Spacing between columns
                  mainAxisSpacing: 8.0, // Spacing between rows
                ),
                itemCount: controller.getRoleId == '1'||controller.getNewId == '1'
                    ? controller.nurseyPoemList.length
                    : controller.getRoleId == '2'||controller.getNewId == '2'
                        ? controller.secondPoemList.length
                        : controller.fifthPoemList.length,
                // Replace with your actual data list length
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: GestureDetector(
                      onTap: () {
                        controller.playAudio();
                        Get.to(s2Screen(), arguments: {
                          'numGrid': controller.getRoleId == '1'||controller.getNewId == '1'
                              ? controller.nurseyPoemList[index].id
                              : controller.getRoleId == '2'||controller.getNewId == '2'
                                  ? controller.secondPoemList[index].id
                                  : controller.fifthPoemList[index].id,
                          'story_title': controller.getRoleId == '1'||controller.getNewId == '1'
                              ? controller.nurseyPoemList[index].title
                              : controller.getRoleId == '2'||controller.getNewId == '2'
                                  ? controller.secondPoemList[index].title
                                  : controller.fifthPoemList[index].title,
                          'sendGameId':controller.getGameId,
                          'sendRoleId':controller.getRoleId ?? controller.getNewId,

                        });
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
                                image: AssetImage(controller.getRoleId == '1'||controller.getNewId == '1'
                                    ? controller
                                        .nurseyPoemList[index].imagePathBg
                                    : controller.getRoleId == '2'||controller.getNewId == '2'
                                        ? controller
                                            .secondPoemList[index].imagePathBg
                                        : controller
                                            .fifthPoemList[index].imagePathBg)),
                            // color: controller.storeList[index].color,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [shadow]),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: CustomSimpleTextField(
                              textAlign: TextAlign.center,
                              hintText: controller.getRoleId == '1'||controller.getNewId == '1'
                                  ? controller.nurseyPoemList[index].title
                                  : controller.getRoleId == '2'||controller.getNewId == '2'
                                      ? controller.secondPoemList[index].title
                                      : controller.fifthPoemList[index].title,
                              textSizeValue: true,
                              textSize:
                                  MediaQuery.of(context).size.height * 0.022,
                              hintColor: Colors.white,
                              fontfamily: 'Monstreat',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ); // Replace with your data model
                },
              ),
            ),
          )
        ],
      )),
    ],
  );
}
