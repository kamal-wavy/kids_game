// import 'package:KidsPlan/custom/simpleText.dart';
// import 'package:KidsPlan/image.dart';
// import 'package:KidsPlan/pages/initial/view/select_game_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../app_argument.dart';
// import '../../../color.dart';
// import '../../../string.dart';
// import '../controller/select_avtar_controllr.dart';
//
// class SelectAvtarScreen extends GetView<SelectAvtarController> {
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<SelectAvtarController>(
//         init: SelectAvtarController(),
//         builder: (context) {
//           return Scaffold(
//               body: Stack(
//             children: [
//               Image.asset(
//                 appgameBg,
//                 fit: BoxFit.fill,
//                 height: double.infinity,
//                 width: double.infinity,
//               ),
//               SafeArea(
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: SingleChildScrollView(
//                     child: SizedBox(
//                       height: MediaQuery.of(Get.context!).size.height,
//                       child: Form(
//                         key: controller.formKey,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Obx(() => Expanded(
//                                   flex: 7,
//                                   child: Column(
//                                     children: [
//                                       CustomSimpleTextField(
//                                         hintText: 'Selected Avtar',
//                                         textSizeValue: true,
//                                         hintColor: appColor,
//                                         textSize: 30,
//                                         fontfamily: 'summary',
//                                       ),
//                                       const SizedBox(
//                                         height: 10,
//                                       ),
//                                       controller.selectedAvatar.value == ''
//                                           ? Stack(
//                                               alignment: Alignment.center,
//                                               children: [
//                                                 Image.asset(appBigCircle),
//                                                 // Image.asset(appPholder,height: 50,),
//                                                 CircleAvatar(
//                                                   radius: 62,
//                                                   backgroundImage:
//                                                       AssetImage(appPholder),
//                                                 ),
//                                               ],
//                                             )
//                                           : Stack(
//                                               alignment: Alignment.center,
//                                               children: [
//                                                 Image.asset(appBigCircle),
//                                                 Image.asset(
//                                                   controller
//                                                       .selectedAvatar.value,
//                                                   height: 80,
//                                                   fit: BoxFit.fill,
//                                                 ),
//                                               ],
//                                             ),
//                                       Padding(
//                                         padding: const EdgeInsets.all(8.0),
//                                         child: CustomSimpleTextField(
//                                           hintText: 'Select Avtar',
//                                           textSizeValue: true,
//                                           hintColor: appRedColor,
//                                           textSize: 30,
//                                           fontfamily: 'summary',
//                                         ),
//                                       ),
//                                       Expanded(
//                                         // flex: MediaQuery.of(Get.context!)
//                                         //     .size
//                                         //     .height
//                                         //     .toInt() *
//                                         //     3,
//                                         child: GridView.builder(
//                                           physics:
//                                               NeverScrollableScrollPhysics(),
//                                           gridDelegate:
//                                               SliverGridDelegateWithFixedCrossAxisCount(
//                                             crossAxisCount: 3,
//                                           ),
//                                           itemCount: controller.avatars.length,
//                                           itemBuilder: (context, index) {
//                                             return GestureDetector(
//                                               onTap: () {
//                                                 controller.playAudio();
//                                                 controller
//                                                         .selectedAvatar.value =
//                                                     controller.avatars[index];
//                                               },
//                                               child: Container(
//                                                   margin:
//                                                       const EdgeInsets.all(8.0),
//                                                   child: Stack(
//                                                     alignment: Alignment.center,
//                                                     children: [
//                                                       Image.asset(appCircle),
//                                                       Image.asset(
//                                                         controller
//                                                             .avatars[index],
//                                                         height: 80,
//                                                         fit: BoxFit.fill,
//                                                       ),
//                                                     ],
//                                                   )),
//                                             );
//                                           },
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 )),
//                             Expanded(
//                               flex: 3,
//                               child: Column(
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Padding(
//                                       padding: const EdgeInsets.only(
//                                           left: 30.0, right: 30, bottom: 10),
//                                       child: TextFormField(
//                                         controller:
//                                             controller.textFieldController,
//                                         decoration: InputDecoration(
//                                           filled: true,
//                                           // Set to true to fill the background color
//                                           fillColor: Colors.white,
//                                           labelText: 'Your Name',
//                                           enabledBorder: OutlineInputBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(50),
//                                             borderSide: BorderSide(
//                                                 color: Colors
//                                                     .white), // Set border color to white
//                                           ),
//                                           errorBorder: OutlineInputBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(50),
//                                             borderSide: BorderSide(
//                                                 color: Colors
//                                                     .white), // Set error border color to red
//                                           ),
//                                           focusedErrorBorder:
//                                               OutlineInputBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(50),
//                                             borderSide: BorderSide(
//                                                 color: Colors
//                                                     .white), // Set focused error border color to white
//                                           ),
//                                           focusedBorder: OutlineInputBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(50),
//                                             borderSide: BorderSide(
//                                                 color: Colors
//                                                     .white), // Set focused border color to white
//                                           ),
//                                           // You can customize other appearance properties as needed
//                                         ),
//                                         validator: (value) {
//                                           if (value == null || value.isEmpty) {
//                                             return 'Please enter name';
//                                           }
//                                           return null;
//                                         },
//                                       ),
//                                     ),
//                                   ),
//                                   Padding(
//                                       padding: const EdgeInsets.only(top: 20.0),
//                                       child: GestureDetector(
//                                         onTap: () {
//                                           controller.playAudio();
//                                           if (controller.formKey.currentState
//                                                   ?.validate() ??
//                                               false) {
//                                             if (controller
//                                                     .selectedAvatar.value ==
//                                                 '') {
//                                               Get.snackbar(
//                                                 icon: Icon(Icons.notification_important_outlined),
//                                                 backgroundColor: appColor,
//                                                 'Warning',
//                                                 '',
//                                                 messageText:
//                                                     CustomSimpleTextField(
//                                                   textSizeValue: true,
//                                                   hintText:
//                                                       'Please select avtar',
//                                                   textSize: 18,
//                                                   hintColor: blackColor,
//                                                   fontfamily: 'Monstreat',
//                                                 ),
//                                               );
//                                             } else {
//                                               controller.userData
//                                                   .write(isVerifiedUser, true);
//                                               controller.userData.write(
//                                                   userName,
//                                                   controller.textFieldController
//                                                       .text);
//                                               controller.userData.write(
//                                                   userImage,
//                                                   controller
//                                                       .selectedAvatar.value);
//                                               Get.to(SelectGameScreen(),
//                                                   arguments: {
//                                                     'name': controller
//                                                         .textFieldController
//                                                         .text,
//                                                     'avtar': controller
//                                                         .selectedAvatar.value
//                                                   });
//                                             }
//                                           }
//                                         },
//                                         child: Stack(
//                                           alignment: Alignment.center,
//                                           children: [
//                                             Image.asset(appGnext),
//                                             CustomSimpleTextField(
//                                               hintText: txtSubmit,
//                                               textSizeValue: true,
//                                               hintColor: Colors.white,
//                                               textSize: 30,
//                                               fontfamily: 'summary',
//                                             ),
//                                           ],
//                                         ),
//                                       ))
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           ));
//         });
//   }
// }
