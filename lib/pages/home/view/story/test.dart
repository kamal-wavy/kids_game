import 'package:KidsPlan/color.dart';
import 'package:KidsPlan/pages/home/view/story/rhymes_list_screen.dart';
import 'package:KidsPlan/pages/home/view/story/s2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../custom/simpleText.dart';
import '../../../../image.dart';
import '../../../../routes/app_routes.dart';
import '../../controller/story/stories_list_controller.dart';

class StoryListScreen extends GetView<StoryListController> {
  @override
  Widget build(BuildContext context) {
    Get.put(StoryListController());
    return GetBuilder<StoryListController>(
        init: StoryListController(),
        builder: (context) {
          return Scaffold(body: _bodyWidget(controller));
        });
  }
}

_bodyWidget(StoryListController controller) {
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
          child: controller.getRoleId == '1'
              ? Column(
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
                                Get.offAllNamed(
                                    AppRoutes.storyOptionGridScreen);
                              },
                              child: Image.asset(appBack)),
                        ),
                        CustomSimpleTextField(
                          hintText: "Stories",
                          fontfamily: 'summary',
                          textSize:
                              MediaQuery.of(Get.context!).size.height * 0.04,
                          hintColor: appColor,
                        ),
                        SizedBox(
                          width: 40,
                        )
                      ],
                    ),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomSimpleTextField(
                              letterpsacingValue: true,
                              hintText: "Adventure",
                              fontfamily: 'summary',
                              textSize:
                                  MediaQuery.of(Get.context!).size.height *
                                      0.03,
                              hintColor: appColor,
                            ),
                            Flexible(
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: controller.storeListAdventure.length,
                                // Replace with your actual data list length
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        controller.playAudio();
                                        Get.to(s2Screen(), arguments: {
                                          'numGrid': controller
                                              .storeListAdventure[index].id,
                                          'story_title': controller
                                              .storeListAdventure[index].title,
                                          "sendGameId": controller.getRoleId
                                        });
                                      },
                                      child: Container(
                                        width: MediaQuery.of(Get.context!)
                                                .size
                                                .height *
                                            0.2,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                              colorFilter: ColorFilter.mode(
                                                Colors.black.withOpacity(0.4),
                                                // Adjust the opacity value as needed
                                                BlendMode.darken,
                                              ),
                                              fit: BoxFit.fill,
                                              image: AssetImage(
                                                controller
                                                        .storeListAdventure[
                                                            index]
                                                        .imagePathBg ??
                                                    "",
                                              ),
                                            ),
                                            // color: controller.storeList[index].color,
                                            borderRadius: BorderRadius.circular(20),
                                            boxShadow: [shadow]),
                                        child: Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: CustomSimpleTextField(
                                              textAlign: TextAlign.center,
                                              hintText: controller
                                                  .storeListAdventure[index]
                                                  .title,
                                              textSizeValue: true,
                                              textSize: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.022,
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
                            CustomSimpleTextField(
                              letterpsacingValue: true,
                              hintText: "Myth",
                              fontfamily: 'summary',
                              textSize:
                                  MediaQuery.of(Get.context!).size.height *
                                      0.03,
                              hintColor: appColor,
                            ),
                            Flexible(
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: controller.storeList.length,
                                // Replace with your actual data list length
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        controller.playAudio();
                                        Get.to(s2Screen(), arguments: {
                                          'numGrid':
                                              controller.storeList[index].id,
                                          'story_title':
                                              controller.storeList[index].title,
                                          "sendGameId": controller.getRoleId
                                        });
                                      },
                                      child: Container(
                                        width: MediaQuery.of(Get.context!)
                                                .size
                                                .height *
                                            0.2,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                colorFilter: ColorFilter.mode(
                                                  Colors.black.withOpacity(0.6),
                                                  // Adjust the opacity value as needed
                                                  BlendMode.darken,
                                                ),
                                                fit: BoxFit.fill,
                                                image: AssetImage(controller
                                                        .storeList[index]
                                                        .imagePathBg ??
                                                    "")),
                                            // color: controller.storeList[index].color,
                                            borderRadius: BorderRadius.circular(20),
                                            boxShadow: [shadow]),
                                        child: Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: CustomSimpleTextField(
                                              textAlign: TextAlign.center,
                                              hintText: controller
                                                  .storeList[index].title,
                                              textSizeValue: true,
                                              textSize: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.022,
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
                            CustomSimpleTextField(
                              hintText: "Comedy",
                              fontfamily: 'summary',
                              textSize:
                                  MediaQuery.of(Get.context!).size.height *
                                      0.03,
                              hintColor: appColor,
                            ),
                            Flexible(
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: controller.storeListComedy.length,
                                // Replace with your actual data list length
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        controller.playAudio();
                                        Get.to(s2Screen(), arguments: {
                                          'numGrid': controller
                                              .storeListComedy[index].id,
                                          'story_title': controller
                                              .storeListComedy[index].title,
                                          "sendGameId": controller.getRoleId
                                        });
                                      },
                                      child: Container(
                                        width: MediaQuery.of(Get.context!)
                                                .size
                                                .height *
                                            0.2,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                colorFilter: ColorFilter.mode(
                                                  Colors.black.withOpacity(0.6),
                                                  // Adjust the opacity value as needed
                                                  BlendMode.darken,
                                                ),
                                                fit: BoxFit.cover,
                                                image: AssetImage(controller
                                                        .storeListComedy[index]
                                                        .imagePathBg ??
                                                    "")),
                                            // color: controller.storeList[index].color,
                                            borderRadius: BorderRadius.circular(20),
                                            boxShadow: [shadow]),
                                        child: Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: CustomSimpleTextField(
                                              textAlign: TextAlign.center,
                                              hintText: controller
                                                  .storeListComedy[index].title,
                                              textSizeValue: true,
                                              textSize: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.022,
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
                            // CustomSimpleTextField(
                            //   hintText: "Stories O",
                            //   fontfamily: 'summary',
                            //   textSize:
                            //       MediaQuery.of(Get.context!).size.height *
                            //           0.03,
                            //   hintColor: appColor,
                            // ),
                            // Expanded(
                            //   child: ListView.builder(
                            //     scrollDirection: Axis.horizontal,
                            //     itemCount: controller.storeList.take(2).length,
                            //     // Replace with your actual data list length
                            //     itemBuilder: (context, index) {
                            //       return Padding(
                            //         padding: const EdgeInsets.all(5.0),
                            //         child: GestureDetector(
                            //           onTap: () {
                            //             controller.playAudio();
                            //             Get.to(s2Screen(), arguments: {
                            //               'numGrid':
                            //                   controller.storeList[index].id,
                            //               'story_title':
                            //                   controller.storeList[index].title,
                            //               "sendGameId": controller.getRoleId
                            //             });
                            //           },
                            //           child: Container(
                            //             decoration: BoxDecoration(
                            //                 image: DecorationImage(
                            //                     colorFilter: ColorFilter.mode(
                            //                       Colors.black.withOpacity(0.4),
                            //                       // Adjust the opacity value as needed
                            //                       BlendMode.darken,
                            //                     ),
                            //                     fit: BoxFit.cover,
                            //                     image: AssetImage(controller
                            //                             .storeList[index]
                            //                             .imagePathBg ??
                            //                         "")),
                            //                 // color: controller.storeList[index].color,
                            //                 borderRadius: BorderRadius.circular(20),
                            //                 boxShadow: [shadow]),
                            //             child: Align(
                            //               alignment: Alignment.bottomCenter,
                            //               child: Padding(
                            //                 padding: const EdgeInsets.all(20.0),
                            //                 child: CustomSimpleTextField(
                            //                   textAlign: TextAlign.center,
                            //                   hintText: controller
                            //                       .storeList[index].title,
                            //                   textSizeValue: true,
                            //                   textSize: MediaQuery.of(context)
                            //                           .size
                            //                           .height *
                            //                       0.022,
                            //                   hintColor: Colors.white,
                            //                   fontfamily: 'Monstreat',
                            //                 ),
                            //               ),
                            //             ),
                            //           ),
                            //         ),
                            //       ); // Replace with your data model
                            //     },
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    )

                    // Expanded(
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(
                    //         top: 30.0, left: 15, right: 15),
                    //     child: GridView.builder(
                    //       gridDelegate:
                    //           SliverGridDelegateWithFixedCrossAxisCount(
                    //         crossAxisCount: 2, // Number of columns
                    //         crossAxisSpacing: 8.0, // Spacing between columns
                    //         mainAxisSpacing: 8.0, // Spacing between rows
                    //       ),
                    //       itemCount: controller.storeList.length,
                    //       // Replace with your actual data list length
                    //       itemBuilder: (context, index) {
                    //         return Padding(
                    //           padding: const EdgeInsets.all(5.0),
                    //           child: GestureDetector(
                    //             onTap: () {
                    //               controller.playAudio();
                    //               Get.to(s2Screen(), arguments: {
                    //                 'numGrid': controller.storeList[index].id,
                    //                 'story_title':
                    //                     controller.storeList[index].title,
                    //                 "sendGameId":controller.getRoleId
                    //               });
                    //             },
                    //             child: Container(
                    //               decoration: BoxDecoration(
                    //                   image: DecorationImage(
                    //                       colorFilter: ColorFilter.mode(
                    //                         Colors.black.withOpacity(0.4),
                    //                         // Adjust the opacity value as needed
                    //                         BlendMode.darken,
                    //                       ),
                    //                       fit: BoxFit.cover,
                    //                       image: AssetImage(controller
                    //                               .storeList[index]
                    //                               .imagePathBg ??
                    //                           "")),
                    //                   // color: controller.storeList[index].color,
                    //                   borderRadius: BorderRadius.circular(20),
                    //                   boxShadow: [shadow]),
                    //               child: Align(
                    //                 alignment: Alignment.bottomCenter,
                    //                 child: Padding(
                    //                   padding: const EdgeInsets.all(20.0),
                    //                   child: CustomSimpleTextField(
                    //                     textAlign: TextAlign.center,
                    //                     hintText:
                    //                         controller.storeList[index].title,
                    //                     textSizeValue: true,
                    //                     textSize:
                    //                         MediaQuery.of(context).size.height *
                    //                             0.022,
                    //                     hintColor: Colors.white,
                    //                     fontfamily: 'Monstreat',
                    //                   ),
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //         ); // Replace with your data model
                    //       },
                    //     ),
                    //   ),
                    // )
                  ],
                )
              : Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              Get.offAllNamed(AppRoutes.storyOptionGridScreen);
                              // Get.to(SelectGameScreen());
                            },
                            child: Image.asset(appBack),
                          ),
                        ),
                        CustomSimpleTextField(
                          hintText: "Poems",
                          fontfamily: 'summary',
                          textSize:
                              MediaQuery.of(Get.context!).size.height * 0.04,
                          hintColor: appColor,
                        ),
                        SizedBox(
                          width: 40,
                        )
                      ],
                    ),
                    Expanded(
                      flex: 9,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 50.0, left: 25, right: 25),
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
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
                                  Get.to(RhymeListScreen(), arguments: {
                                    'roleId':
                                        controller.yourDataList[index].roleId,
                                    "sendGameId": controller.getRoleId
                                  });
                                  print(controller.yourDataList[index].roleId);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      gradient: controller
                                          .yourDataList[index].gradientColor),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        controller.yourDataList[index].imageUrl,
                                        height: MediaQuery.of(Get.context!)
                                                .size
                                                .height
                                                .toInt() *
                                            0.09,
                                        // Replace with the image URL from your data model
                                        // height: 80, // Adjust the height as needed
                                        // width: 80, // Adjust the width as needed
                                        fit: BoxFit.cover,
                                      ),
                                      SizedBox(height: 8.0),
                                      Flexible(
                                        child: CustomSimpleTextField(
                                          hintText: controller
                                              .yourDataList[index].name,
                                          textSize: MediaQuery.of(Get.context!)
                                                  .size
                                                  .height *
                                              0.02,
                                          hintColor: Colors.white,
                                          fontfamily: 'Montstreat',
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
                )),
    ],
  );
}
