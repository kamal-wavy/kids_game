// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:lottie/lottie.dart';
//
// import '../../../../color.dart';
// import '../../../../custom/simpleText.dart';
// import '../../../../image.dart';
// import '../../controller/word/word_game_controller.dart';
//
// class WordGameScreen extends GetView<WordSolveController> {
//   @override
//   Widget build(BuildContext context) {
//     Get.put(WordSolveController());
//     return WillPopScope(
//       onWillPop: () async {
//         controller.togglePlayPause();
//         return true;
//         // return false;
//       },
//       child: GetBuilder<WordSolveController>(
//         init: WordSolveController(),
//         builder: (context) {
//           return Scaffold(
//             body: _bodyWidget(controller),
//           );
//         },
//       ),
//     );
//   }
//
//   _bodyWidget(WordSolveController controller) {
//     return Stack(
//       children: [
//         Image.asset(
//           appselectbg,
//           fit: BoxFit.fill,
//           height: double.infinity,
//           width: double.infinity,
//         ),
//         SafeArea(
//           child: Column(
//             children: [
//               Padding(
//                 padding: EdgeInsets.symmetric(vertical: 8.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         controller.playAudio();
//                         controller.togglePlayPause();
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: Colors.pink,
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(4.0),
//                           child: Icon(
//                             controller.isTimerPaused
//                                 ? Icons.play_arrow
//                                 : Icons.pause,
//                             size: 30,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                     Container(
//                       width: 150,
//                       child: Stack(
//                         alignment: Alignment.centerLeft,
//                         children: [
//                           Positioned(
//                             left: 50,
//                             // Adjust the distance between the circle and text
//                             child: Container(
//                               width: 100,
//                               margin: EdgeInsets.zero,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.only(
//                                   topRight: Radius.circular(10),
//                                   bottomRight: Radius.circular(10),
//                                 ),
//                                 color: Colors.pink,
//                               ),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(5.0),
//                                 child: Center(
//                                     child: CustomSimpleTextField(
//                                   textSizeValue: true,
//                                   hintText: controller
//                                       .formatTime(controller.secondsElapsed),
//                                   hintColor: Colors.white,
//                                   textSize: 15,
//                                   fontfamily: 'Montstreat',
//                                 )),
//                               ),
//                             ),
//                           ),
//                           CircleAvatar(
//                             radius: 30,
//                             backgroundColor: Colors.amber,
//                             backgroundImage: AssetImage(appalarm),
//                           ),
//                         ],
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         controller.playAudio();
//                         showDialogBox(controller);
//                       },
//                       child: Image.asset(appTips),
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                   padding: EdgeInsets.only(top: 15, left: 15, right: 15),
//                   child: dd(controller)),
//               // dd(controller),
//               Padding(
//                 padding: EdgeInsets.only(
//                     top: MediaQuery.of(Get.context!).size.height * 0.05),
//                 child: Column(
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         controller.charsDone.value.clear();
//                         controller.charsDone.notifyListeners();
//                         controller.currentDragObj.value = CurrentDragObj();
//                         controller.currentDragObj.notifyListeners();
//                         controller.generateRandomWord();
//
//                         controller.stopTimer();
//                         controller.startGame();
//                         controller.moves = 0;
//                         controller.update();
//                       },
//                       child: Image.asset(
//                         appSkipbtn,
//                         height: MediaQuery.of(Get.context!).size.height * 0.07,
//                       ),
//                     ),
//                     // CustomSimpleTextField(
//                     //   hintText: 'Moves: ${controller.moves.toString() ?? ""}',
//                     //   fontfamily: 'Montstreat',
//                     //   textSize: MediaQuery.of(Get.context!).size.width * 0.05,
//                     //   hintColor: appColor,
//                     // ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         controller.start == 1
//             ? Lottie.asset(
//                 fit: BoxFit.fitHeight,
// //repeat: true,
//                 'assets/s.json',
//                 // animate: true,
//                 controller: controller.animationControllerBlast,
//                 // Use animationController here
//                 onLoaded: (composition) {
//                   controller.animationControllerBlast!.duration =
//                       composition.duration;
//                 },
//               )
//             : Text('')
//       ],
//     );
//   }
//
//   Widget drawCrosswordBox() {
//     return Listener(
//       onPointerUp: (event) {
//         controller.onDragEnd(event);
//       },
//       onPointerMove: (event) {
//         controller.onDragUpdate(event);
//       },
//       child: LayoutBuilder(
//         builder: (context, constraints) {
//           controller.sizeBox = Size(constraints.maxWidth, constraints.maxWidth);
//           return GridView.builder(
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               childAspectRatio: 1,
//               crossAxisCount: controller.numBoxPerRow,
//               crossAxisSpacing: controller.padding,
//               mainAxisSpacing: controller.padding,
//             ),
//             itemCount: controller.numBoxPerRow * controller.numBoxPerRow,
//             itemBuilder: (context, index) {
//               String char =
//                   controller.listChars.value.expand((e) => e).toList()[index];
//               return Listener(
//                 onPointerDown: (event) {
//                   controller.onDragStart(index);
//                 },
//                 child: ValueListenableBuilder(
//                   valueListenable: controller.currentDragObj,
//                   builder: (context, CurrentDragObj value, child) {
//                     Color color = Colors.transparent;
//                     // appColor;
//                     //Colors.blue;
//                     if (value.currentDragLine.contains(index))
//                       color = appPinkColor;
//                     //Colors.yellow;
//                     else if (controller.charsDone.value.contains(index))
//                       color = appSkyColor;
//                     return Container(
//                       decoration: BoxDecoration(
//                         color: color,
//                       ),
//                       alignment: Alignment.center,
//                       child: Text(
//                         char.toUpperCase(),
//                         style: TextStyle(
//                             fontSize: 28,
//                             fontWeight: FontWeight.bold,
//                             fontFamily: 'summary'),
//                       ),
//                     );
//                   },
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
//
//   Widget drawAnswerList() {
//     return ValueListenableBuilder(
//       valueListenable: controller.answerList,
//       builder: (context, List<CrosswordAnswer> value, child) {
//         int perColTotal = 3;
//         List<Widget> list = List.generate(
//           (value.length ~/ perColTotal) +
//               ((value.length % perColTotal) > 0 ? 1 : 0),
//           (int index) {
//             int maxColumn = (index + 1) * perColTotal;
//
//             return Container(
//               margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: List.generate(
//                   maxColumn > value.length
//                       ? maxColumn - value.length
//                       : perColTotal,
//                   (indexChild) {
//                     int indexArray = (index) * perColTotal + indexChild;
//
//                     return Text(
//                       "${value[indexArray].wsLocation.word}",
//                       style: TextStyle(
//                         fontSize: MediaQuery.of(context).size.height * 0.025,
//                         color: value[indexArray].done
//                             ? Colors.yellow
//                             : Colors.white,
//                         decoration: value[indexArray].done
//                             ? TextDecoration.lineThrough
//                             : TextDecoration.none,
//                       ),
//                     );
//                   },
//                 ).toList(),
//               ),
//             );
//           },
//         ).toList();
//
//         return Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Container(
//             decoration: BoxDecoration(
//                 color: appPinkColor,
//                 borderRadius: BorderRadiusDirectional.circular(10)),
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 children: list,
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   showDialogBox(WordSolveController controller) {
//     return showDialog<void>(
//       context: Get.context!,
//       builder: (BuildContext context) {
//         return Stack(
//           alignment: Alignment.center,
//           children: [
//             Image.asset(
//               apphow,
//               height: MediaQuery.of(context).size.width * 0.9,
//             ),
//             Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Padding(
//                   padding: EdgeInsets.only(
//                       top: MediaQuery.of(Get.context!).size.height * 0.01),
//                   child: SizedBox(
//                     width: MediaQuery.of(Get.context!).size.width * 0.6,
//                     // height: MediaQuery.of(Get.context!).size.height * 0.2,
//                     child: CustomSimpleTextField(
//                       textAlign: TextAlign.center,
//                       hintText:
//                           "I have six different words which are also hidden in a grid of letters. "
//                           "If you find them, swipe on those words.",
//                       textSize: MediaQuery.of(Get.context!).size.width * 0.04,
//                       hintColor: blackColor,
//                       fontfamily: 'Monstreat',
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: GestureDetector(
//                     onTap: () {
//                       controller.playAudio();
//                       Get.back();
//                     },
//                     child: Stack(
//                       alignment: Alignment.center,
//                       children: [
//                         Image.asset(
//                           appbtn,
//                           width: MediaQuery.of(context).size.width * 0.5,
//                         ),
//                         Center(
//                           child: CustomSimpleTextField(
//                             textSizeValue: true,
//                             underLineValue: false,
//                             textAlign: TextAlign.center,
//                             hintText: 'OKAY!!',
//                             textSize:
//                                 MediaQuery.of(Get.context!).size.width * 0.06,
//                             hintColor: Colors.white,
//                             fontfamily: 'summary',
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             )
//           ],
//         );
//       },
//     );
//   }
//
//   dd(WordSolveController controller) {
//     return Column(
//       children: [
//         Container(
//           // color: Colors.white,
//           alignment: Alignment.center,
//           width: double.maxFinite,
//           height: MediaQuery.of(Get.context!).size.height * 0.45,
//           // height: controller.size.width - controller.padding * 2,
//           padding: EdgeInsets.all(controller.padding),
//           margin: EdgeInsets.all(controller.padding),
//           child: drawCrosswordBox(),
//         ),
//         Container(
//           alignment: Alignment.center,
//           child: drawAnswerList(),
//         ),
//       ],
//     );
//     //   SizedBox(
//     //   height: MediaQuery.of(Get.context!!).size.height * 0.6,
//     //   width: MediaQuery.of(Get.context!!).size.width,
//     //   child:
//     // );
//   }
// }
