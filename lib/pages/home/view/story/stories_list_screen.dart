// import 'package:KidsPlan/color.dart';
// import 'package:KidsPlan/pages/home/view/story/rhymes_list_screen.dart';
// import 'package:KidsPlan/pages/home/view/story/s2.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../../custom/simpleText.dart';
// import '../../../../image.dart';
// import '../../../initial/view/select_game_screen.dart';
// import '../../controller/story/stories_list_controller.dart';
//
// class StoryListScreen extends GetView<StoryListController> {
//   @override
//   Widget build(BuildContext context) {
//     Get.put(StoryListController());
//     return GetBuilder<StoryListController>(
//         init: StoryListController(),
//         builder: (context) {
//           return Scaffold(body: _bodyWidget(controller));
//         });
//   }
// }
//
// _bodyWidget(StoryListController controller) {
//   return Stack(
//     alignment: Alignment.bottomCenter,
//     children: [
//       Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Expanded(
//               child: Image.asset(
//             appselectbg,
//             fit: BoxFit.fill,
//           )),
//         ],
//       ),
//       SafeArea(
//           child: controller.getRoleId == '1'
//               ? Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: GestureDetector(
//                               onTap: () {
//                                 Get.to(SelectGameScreen());
//                               },
//                               child: Image.asset(appBack)),
//                         ),
//                         CustomSimpleTextField(
//                           hintText: "Stories",
//                           fontfamily: 'summary',
//                           textSize:
//                               MediaQuery.of(Get.context!).size.height * 0.04,
//                           hintColor: appColor,
//                         ),
//                         SizedBox(
//                           width: 40,
//                         )
//                       ],
//                     ),
//                     Expanded(
//                       child: Padding(
//                         padding: const EdgeInsets.only(top: 15.0),
//                         child: ListView.builder(
//                             shrinkWrap: true,
//                             itemCount: controller.storeList.length,
//                             itemBuilder: (BuildContext context, int index) {
//                               return Padding(
//                                 padding: const EdgeInsets.only(
//                                     left: 30.0, right: 30, bottom: 10, top: 10),
//                                 child: GestureDetector(
//                                   onTap: () {
//                                     // Get.to(StoryScreen(), arguments: {
//                                     //   'numGrid': controller.storeList[index].id,
//                                     // });
//                                     Get.to(s2Screen(), arguments: {
//                                       'numGrid': controller.storeList[index].id,
//                                       'story_title':
//                                           controller.storeList[index].title
//                                     });
//                                   },
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                         color: appLightGreenColor,
//                                         borderRadius:
//                                             BorderRadius.circular(20)),
//                                     child: Padding(
//                                       padding: const EdgeInsets.only(
//                                           left: 20.0, right: 20),
//                                       child: Container(
//                                         decoration: BoxDecoration(
//                                           border: Border(
//                                             bottom: BorderSide(
//                                               color: Colors.orange,
//                                               width: 10,
//                                             ),
//                                           ),
//                                         ),
//                                         child: Padding(
//                                           padding: const EdgeInsets.all(10.0),
//                                           child: Center(
//                                             child: CustomSimpleTextField(
//                                               textAlign: TextAlign.start,
//                                               textSizeValue: true,
//                                               hintText: controller
//                                                   .storeList[index].title,
//                                               fontfamily: 'Montstreat',
//                                               textSize:
//                                                   MediaQuery.of(Get.context!)
//                                                           .size
//                                                           .height *
//                                                       0.025,
//                                               hintColor: Colors.white,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             }),
//                       ),
//                     )
//                   ],
//                 )
//               : Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: GestureDetector(
//                             onTap: () {
//                               Get.to(SelectGameScreen());
//                             },
//                             child: Image.asset(appBack),
//                           ),
//                         ),
//                         CustomSimpleTextField(
//                           hintText: "Poems",
//                           fontfamily: 'summary',
//                           textSize:
//                               MediaQuery.of(Get.context!).size.height * 0.04,
//                           hintColor: appColor,
//                         ),
//                         SizedBox(
//                           width: 40,
//                         )
//                       ],
//                     ),
//                     Expanded(
//                       flex: 9,
//                       child: Padding(
//                         padding: const EdgeInsets.only(
//                             top: 50.0, left: 25, right: 25),
//                         child: GridView.builder(
//                           gridDelegate:
//                               SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount: 2, // Number of columns
//                             crossAxisSpacing: 8.0, // Spacing between columns
//                             mainAxisSpacing: 8.0, // Spacing between rows
//                           ),
//                           itemCount: controller.yourDataList.length,
//                           // Replace with your actual data list length
//                           itemBuilder: (context, index) {
//                             return Padding(
//                               padding: const EdgeInsets.all(5.0),
//                               child: GestureDetector(
//                                 onTap: () {
//                                   controller.playAudio();
//                                   Get.to(RhymeListScreen(), arguments: {
//                                     'roleId':
//                                         controller.yourDataList[index].roleId,
//                                   });
//                                   print(controller.yourDataList[index].roleId);
//                                 },
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(20),
//                                       gradient: controller
//                                           .yourDataList[index].gradientColor),
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Image.asset(
//                                         controller.yourDataList[index].imageUrl,
//                                         height: MediaQuery.of(Get.context!)
//                                                 .size
//                                                 .height
//                                                 .toInt() *
//                                             0.09,
//                                         // Replace with the image URL from your data model
//                                         // height: 80, // Adjust the height as needed
//                                         // width: 80, // Adjust the width as needed
//                                         fit: BoxFit.cover,
//                                       ),
//                                       SizedBox(height: 8.0),
//                                       Flexible(
//                                         child: CustomSimpleTextField(
//                                           hintText: controller
//                                               .yourDataList[index].name,
//                                           textSize: MediaQuery.of(Get.context!)
//                                                   .size
//                                                   .height *
//                                               0.02,
//                                           hintColor: Colors.white,
//                                           fontfamily: 'Montstreat',
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ); // Replace with your data model
//                           },
//                         ),
//                       ),
//                     ),
//                   ],
//                 )
//
//           // DefaultTabController(
//           //         length: 3,
//           //         child:
//           //         Column(
//           //           children: [
//           //             Row(
//           //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           //               children: [
//           //                 Padding(
//           //                   padding: const EdgeInsets.all(8.0),
//           //                   child: GestureDetector(
//           //                     onTap: () {
//           //                       Get.to(SelectGameScreen());
//           //                     },
//           //                     child: Image.asset(appBack),
//           //                   ),
//           //                 ),
//           //                 CustomSimpleTextField(
//           //                   hintText: "Poems",
//           //                   fontfamily: 'summary',
//           //                   textSize:
//           //                       MediaQuery.of(Get.context!).size.height * 0.04,
//           //                   hintColor: appColor,
//           //                 ),
//           //                 SizedBox(
//           //                   width: 40,
//           //                 )
//           //               ],
//           //             ),
//           //             Padding(
//           //               padding: const EdgeInsets.all(8.0),
//           //               child: Container(
//           //                 height: 45,
//           //                 decoration: BoxDecoration(
//           //                   borderRadius: BorderRadius.circular(10.0),
//           //                 ),
//           //                 child: TabBar(
//           //                   indicator: BoxDecoration(
//           //                     color: appColor,
//           //                     borderRadius: BorderRadius.circular(10.0),
//           //                   ),
//           //                   labelColor: Colors.white,
//           //                   unselectedLabelColor: Colors.black,
//           //                   tabs: [
//           //                     Padding(
//           //                       padding: EdgeInsets.all(10.0),
//           //                       child: Tab(
//           //                         text: "Nursery-LKG",
//           //                       ),
//           //                     ),
//           //                     Padding(
//           //                       padding: EdgeInsets.all(10.0),
//           //                       child: Tab(
//           //                         text: "UKG-2ND",
//           //                       ),
//           //                     ),
//           //                     Padding(
//           //                       padding: EdgeInsets.all(10.0),
//           //                       child: Tab(
//           //                         text: "2ND-5TH",
//           //                       ),
//           //                     ),
//           //                   ],
//           //                 ),
//           //               ),
//           //             ),
//           //             Expanded(
//           //               child: TabBarView(
//           //                 children: [
//           //                   Padding(
//           //                     padding: const EdgeInsets.only(top: 15.0),
//           //                     child: ListView.builder(
//           //                         shrinkWrap: true,
//           //                         itemCount: controller.nurseyPoemList.length,
//           //                         itemBuilder:
//           //                             (BuildContext context, int index) {
//           //                           return Padding(
//           //                             padding: const EdgeInsets.only(
//           //                                 left: 30.0,
//           //                                 right: 30,
//           //                                 bottom: 10,
//           //                                 top: 10),
//           //                             child: GestureDetector(
//           //                               onTap: () {
//           //                                 // Get.to(StoryScreen(), arguments: {
//           //                                 //   'numGrid': controller.storeList[index].id,
//           //                                 // });
//           //                                 Get.to(s2Screen(), arguments: {
//           //                                   'numGrid': controller
//           //                                       .nurseyPoemList[index].id,
//           //                                   'story_title': controller
//           //                                       .nurseyPoemList[index].title
//           //                                 });
//           //                               },
//           //                               child: Container(
//           //                                 decoration: BoxDecoration(
//           //                                     color: appLightGreenColor,
//           //                                     borderRadius:
//           //                                         BorderRadius.circular(20)),
//           //                                 child: Padding(
//           //                                   padding: const EdgeInsets.only(
//           //                                       left: 20.0, right: 20),
//           //                                   child: Container(
//           //                                     decoration: BoxDecoration(
//           //                                       border: Border(
//           //                                         bottom: BorderSide(
//           //                                           color: Colors.orange,
//           //                                           width: 10,
//           //                                         ),
//           //                                       ),
//           //                                     ),
//           //                                     child: Padding(
//           //                                       padding:
//           //                                           const EdgeInsets.all(10.0),
//           //                                       child: Center(
//           //                                         child: CustomSimpleTextField(
//           //                                           textAlign: TextAlign.start,
//           //                                           textSizeValue: true,
//           //                                           hintText: controller
//           //                                               .nurseyPoemList[index]
//           //                                               .title,
//           //                                           fontfamily: 'Montstreat',
//           //                                           textSize: MediaQuery.of(
//           //                                                       Get.context!)
//           //                                                   .size
//           //                                                   .height *
//           //                                               0.025,
//           //                                           hintColor: Colors.white,
//           //                                         ),
//           //                                       ),
//           //                                     ),
//           //                                   ),
//           //                                 ),
//           //                               ),
//           //                             ),
//           //                           );
//           //                         }),
//           //                   ),
//           //                   Padding(
//           //                     padding: const EdgeInsets.only(top: 15.0),
//           //                     child: ListView.builder(
//           //                         shrinkWrap: true,
//           //                         itemCount:
//           //                             controller.secondPoemList.length,
//           //                         itemBuilder:
//           //                             (BuildContext context, int index) {
//           //                           return Padding(
//           //                             padding: const EdgeInsets.only(
//           //                                 left: 30.0,
//           //                                 right: 30,
//           //                                 bottom: 10,
//           //                                 top: 10),
//           //                             child: GestureDetector(
//           //                               onTap: () {
//           //                                 // Get.to(StoryScreen(), arguments: {
//           //                                 //   'numGrid': controller.storeList[index].id,
//           //                                 // });
//           //                                 Get.to(s2Screen(), arguments: {
//           //                                   'numGrid':
//           //                                       controller.secondPoemList[index].id,
//           //                                   'story_title': controller
//           //                                       .secondPoemList[index].title
//           //                                 });
//           //                               },
//           //                               child: Container(
//           //                                 decoration: BoxDecoration(
//           //                                     color: appLightGreenColor,
//           //                                     borderRadius:
//           //                                         BorderRadius.circular(20)),
//           //                                 child: Padding(
//           //                                   padding: const EdgeInsets.only(
//           //                                       left: 20.0, right: 20),
//           //                                   child: Container(
//           //                                     decoration: BoxDecoration(
//           //                                       border: Border(
//           //                                         bottom: BorderSide(
//           //                                           color: Colors.orange,
//           //                                           width: 10,
//           //                                         ),
//           //                                       ),
//           //                                     ),
//           //                                     child: Padding(
//           //                                       padding:
//           //                                           const EdgeInsets.all(10.0),
//           //                                       child: Center(
//           //                                         child: CustomSimpleTextField(
//           //                                           textAlign: TextAlign.start,
//           //                                           textSizeValue: true,
//           //                                           hintText: controller
//           //                                               .secondPoemList[index].title,
//           //                                           fontfamily: 'Montstreat',
//           //                                           textSize: MediaQuery.of(
//           //                                                       Get.context!)
//           //                                                   .size
//           //                                                   .height *
//           //                                               0.025,
//           //                                           hintColor: Colors.white,
//           //                                         ),
//           //                                       ),
//           //                                     ),
//           //                                   ),
//           //                                 ),
//           //                               ),
//           //                             ),
//           //                           );
//           //                         }),
//           //                   ),
//           //                   Padding(
//           //                     padding: const EdgeInsets.only(top: 15.0),
//           //                     child: ListView.builder(
//           //                         shrinkWrap: true,
//           //                         itemCount: controller.fifthPoemList.length,
//           //                         itemBuilder:
//           //                             (BuildContext context, int index) {
//           //                           return Padding(
//           //                             padding: const EdgeInsets.only(
//           //                                 left: 30.0,
//           //                                 right: 30,
//           //                                 bottom: 10,
//           //                                 top: 10),
//           //                             child: GestureDetector(
//           //                               onTap: () {
//           //                                 // Get.to(StoryScreen(), arguments: {
//           //                                 //   'numGrid': controller.storeList[index].id,
//           //                                 // });
//           //                                 Get.to(s2Screen(), arguments: {
//           //                                   'numGrid':
//           //                                       controller.fifthPoemList[index].id,
//           //                                   'story_title': controller
//           //                                       .fifthPoemList[index].title
//           //                                 });
//           //                               },
//           //                               child: Container(
//           //                                 decoration: BoxDecoration(
//           //                                     color: appLightGreenColor,
//           //                                     borderRadius:
//           //                                         BorderRadius.circular(20)),
//           //                                 child: Padding(
//           //                                   padding: const EdgeInsets.only(
//           //                                       left: 20.0, right: 20),
//           //                                   child: Container(
//           //                                     decoration: BoxDecoration(
//           //                                       border: Border(
//           //                                         bottom: BorderSide(
//           //                                           color: Colors.orange,
//           //                                           width: 10,
//           //                                         ),
//           //                                       ),
//           //                                     ),
//           //                                     child: Padding(
//           //                                       padding:
//           //                                           const EdgeInsets.all(10.0),
//           //                                       child: Center(
//           //                                         child: CustomSimpleTextField(
//           //                                           textAlign: TextAlign.start,
//           //                                           textSizeValue: true,
//           //                                           hintText: controller
//           //                                               .fifthPoemList[index].title,
//           //                                           fontfamily: 'Montstreat',
//           //                                           textSize: MediaQuery.of(
//           //                                                       Get.context!)
//           //                                                   .size
//           //                                                   .height *
//           //                                               0.025,
//           //                                           hintColor: Colors.white,
//           //                                         ),
//           //                                       ),
//           //                                     ),
//           //                                   ),
//           //                                 ),
//           //                               ),
//           //                             ),
//           //                           );
//           //                         }),
//           //                   )
//           //                 ],
//           //               ),
//           //             )
//           //           ],
//           //         ),
//           //       )
//           ),
//     ],
//   );
// }
