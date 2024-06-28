import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:lottie/lottie.dart';

import '../../../app_argument.dart';
import '../../../color.dart';
import '../../../custom/simpleText.dart';
import '../../../image.dart';
import '../../../string.dart';

class SelectGameController extends GetxController {
  bool? loginCheck;
  var dark = false;
  final userData = GetStorage();
  var AvtarName;
  var AvtarImage;
  final TextEditingController textEditingController = TextEditingController();
  final maxLength = 12;

  // int gamesPlayed = 0;
  RxInt gamesPlayed = 0.obs;
  final InAppReview inAppReview = InAppReview.instance;

  RxBool isToggleSwitchOn = true.obs;
  final AudioPlayer audioPlayer = AudioPlayer();
  TextEditingController textFieldController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // final RegExp alphanumericRegex = RegExp(r'^[a-zA-Z0-9]+$');
  final RegExp alphanumericRegex = RegExp(r'^[a-zA-Z\s]+$');

  String audioPath = 'audio/click.mp3';
  String audioBackGroundPath = 'audio/fullMusic.mp3';

  String text = "";
  int index = 0;
  final String fullText = "Hey kid! play games that\nmake you super smart!";

  int editName = 0;

  void toggleSwitch() {
    isToggleSwitchOn.value = !isToggleSwitchOn.value;
    userData.write('toggleState', isToggleSwitchOn.value);
  }

  void loadGamesPlayed() {
    // gamesPlayed = userData.read('gamesPlayed') ?? 0;
    gamesPlayed.value = userData.read('gamesPlayed') ?? 0;
    update();
    print(gamesPlayed.value);
  }

  void incrementGamesPlayed() {
    gamesPlayed.value++;
    userData.write('gamesPlayed', gamesPlayed.value);
    update();
  }

  void requestReview() async {
    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview().then((value) {
        print('kamal');
      });
    } else {
      // inAppReview.openStoreListing();
      print('In-app review is not available on this device.');
    }
  }

  // showReviewDialog() {
  //   showDialog<void>(
  //     context: Get.context!,
  //     builder: (BuildContext context) {
  //       return WillPopScope(
  //         onWillPop: () async => false,
  //         child: Material(
  //           type: MaterialType.transparency,
  //           child: Center(
  //             child: Stack(
  //               alignment: Alignment.center,
  //               children: [
  //                 Image.asset(
  //                   appBgRating,
  //                   height: MediaQuery.of(Get.context!).size.height * 0.4,
  //                 ),
  //                 Column(
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Padding(
  //                         padding: EdgeInsets.only(
  //                           top: MediaQuery.of(Get.context!).size.height * 0.03,
  //                           left: MediaQuery.of(Get.context!).size.width * 0.12,
  //                           right:
  //                               MediaQuery.of(Get.context!).size.width * 0.12,
  //                         ),
  //                         child: ListTile(
  //                           title: CustomSimpleTextField(
  //                             hintText: 'Enjoying the app?',
  //                             textSizeValue: true,
  //                             textSize:
  //                                 MediaQuery.of(context).size.height * 0.02,
  //                             hintColor: blackColor,
  //                             fontfamily: 'Monstreat',
  //                           ),
  //                           subtitle: CustomSimpleTextField(
  //                             hintText:
  //                                 'Please take a moment to rate us on the Play Store.',
  //                             textSizeValue: true,
  //                             textSize:
  //                                 MediaQuery.of(context).size.height * 0.02,
  //                             hintColor: greyColor,
  //                             fontfamily: 'Monstreat',
  //                           ),
  //                         )),
  //                     Padding(
  //                       padding: EdgeInsets.only(
  //                           right:
  //                               MediaQuery.of(Get.context!).size.width * 0.15,
  //                           top: 8,
  //                           bottom:
  //                               MediaQuery.of(Get.context!).size.height * 0.01),
  //                       child: Row(
  //                         mainAxisAlignment: MainAxisAlignment.end,
  //                         children: [
  //                           TextButton(
  //                             child: CustomSimpleTextField(
  //                               hintText: 'Later',
  //                               textSizeValue: true,
  //                               textSize:
  //                                   MediaQuery.of(context).size.height * 0.02,
  //                               hintColor: appPinkColor,
  //                               fontfamily: 'Monstreat',
  //                             ),
  //                             onPressed: () {
  //                               Get.back();
  //                               userData.write('gamesPlayed', 0);
  //                               update();
  //                               print(userData.read('gamesPlayed'));
  //                             },
  //                           ),
  //                           TextButton(
  //                             child: CustomSimpleTextField(
  //                               hintText: 'Rate Now',
  //                               textSizeValue: true,
  //                               textSize:
  //                                   MediaQuery.of(context).size.height * 0.02,
  //                               hintColor: appPinkColor,
  //                               fontfamily: 'Monstreat',
  //                             ),
  //                             onPressed: () {
  //                               requestReview();
  //                               Get.back();
  //                             },
  //                           ),
  //                         ],
  //                       ),
  //                     )
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
  void showReviewDialog() {
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
                    appBgRating,
                    height: MediaQuery.of(Get.context!).size.height * 0.4,
                    width: MediaQuery.of(Get.context!).size.width * 0.8,
                    fit: BoxFit.fill,
                  ),
                  Positioned(
                    top: MediaQuery.of(Get.context!).size.height * 0.1,
                    left: MediaQuery.of(Get.context!).size.width * 0.1,
                    right: MediaQuery.of(Get.context!).size.width * 0.1,
                    child: Column(
                      children: [
                        CustomSimpleTextField(
                          hintText: 'Enjoying the app?',
                          textSizeValue: true,
                          textSize: MediaQuery.of(context).size.height * 0.025,
                          hintColor: blackColor,
                          fontfamily: 'Monstreat',
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        CustomSimpleTextField(
                          hintText:
                              'Please take a moment to rate us on the Play Store.',
                          textSizeValue: true,
                          textSize: MediaQuery.of(context).size.height * 0.02,
                          hintColor: greyColor,
                          fontfamily: 'Monstreat',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    // top: MediaQuery.of(Get.context!).size.height * 0.2,
                    bottom: MediaQuery.of(Get.context!).size.height * 0.05,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          child: CustomSimpleTextField(
                            hintText: 'Later',
                            textSizeValue: true,
                            textSize: MediaQuery.of(context).size.height * 0.02,
                            hintColor: appPinkColor,
                            fontfamily: 'Monstreat',
                          ),
                          onPressed: () {
                            Get.back();
                            userData.write('gamesPlayed', 0);
                            update();
                            print(userData.read('gamesPlayed'));
                          },
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.05),
                        TextButton(
                          child: CustomSimpleTextField(
                            hintText: 'Rate Now',
                            textSizeValue: true,
                            textSize: MediaQuery.of(context).size.height * 0.02,
                            hintColor: appPinkColor,
                            fontfamily: 'Monstreat',
                          ),
                          onPressed: () {
                            requestReview();
                            Get.back();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // showReviewDialog() {
  //   showDialog(
  //     context: Get.context!,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         backgroundColor: appColor,
  //         title: CustomSimpleTextField(
  //           hintText: 'Enjoying the app?',
  //           textSizeValue: true,
  //           textSize: MediaQuery.of(context).size.height * 0.02,
  //           hintColor: Colors.white,
  //           fontfamily: 'Monstreat',
  //         ),
  //         content: CustomSimpleTextField(
  //           hintText: 'Please take a moment to rate us on the Play Store.',
  //           textSizeValue: true,
  //           textSize: MediaQuery.of(context).size.height * 0.02,
  //           hintColor: Colors.white,
  //           fontfamily: 'Monstreat',
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: CustomSimpleTextField(
  //               hintText: 'Later',
  //               textSizeValue: true,
  //               textSize: MediaQuery.of(context).size.height * 0.02,
  //               hintColor: Colors.white,
  //               fontfamily: 'Monstreat',
  //             ),
  //             onPressed: () {
  //               Get.back();
  //               userData.write('gamesPlayed', 0);
  //               update();
  //               print(userData.read('gamesPlayed'));
  //             },
  //           ),
  //           TextButton(
  //             child: CustomSimpleTextField(
  //               hintText: 'Rate Now',
  //               textSizeValue: true,
  //               textSize: MediaQuery.of(context).size.height * 0.02,
  //               hintColor: Colors.white,
  //               fontfamily: 'Monstreat',
  //             ),
  //             onPressed: () {
  //               requestReview();
  //               Get.back();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  void startTyping() {
    const duration = const Duration(milliseconds: 100);

    Timer.periodic(duration, (timer) {
      if (index < fullText.length) {
        text += fullText[index];
        index++;
        update();
      } else {
        timer.cancel();
      }
    });
  }

  AssetImage? assetImage;
  AssetImage? assetImage1;
  AssetImage? assetImage2;
  AssetImage? assetImage3;
  AssetImage? assetImage4;
  AssetImage? assetImage5;
  AssetImage? assetImage6;
  RxBool isBottomSheetOpen = false.obs;
  var df = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // startTyping();

    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      openBottomSheet();
      // final box = GetStorage();
      // await box.initStorage;
      //
      // final bool isBottomSheetShown = box.read('isBottomSheetShown') ?? false;
      // if (!isBottomSheetShown) {
      //   openBottomSheet();
      //   await box.write('isBottomSheetShown', true);
      // }
    });

    assetImage = AssetImage(appbg7);
    assetImage1 = AssetImage(appg1);
    assetImage2 = AssetImage(appg2);
    assetImage3 = AssetImage(appg3);
    assetImage4 = AssetImage(appg4);
    assetImage5 = AssetImage(appg5);
    assetImage6 = AssetImage(appg6);
    precacheImage(assetImage!, Get.context!);
    precacheImage(assetImage1!, Get.context!);
    precacheImage(assetImage2!, Get.context!);
    precacheImage(assetImage3!, Get.context!);
    precacheImage(assetImage4!, Get.context!);
    precacheImage(assetImage5!, Get.context!);
    precacheImage(assetImage6!, Get.context!);

    userData.writeIfNull(isVerifiedUser, false);

    isToggleSwitchOn.value = userData.read('toggleState') ?? true;

    AvtarName = userData.read(userName);
    print(AvtarName);
    AvtarImage = userData.read(userImage);
    if (AvtarName == null || AvtarName == "") {
      getData();
    }
    textFieldController.addListener(limitTextLength);
    loadGamesPlayed();
  }

  final InAppReview _inAppReview = InAppReview.instance;
  String _appStoreId = '';
  String _microsoftStoreId = '';

  Future<void> openStoreListing() => _inAppReview.openStoreListing(
        appStoreId: _appStoreId,
        microsoftStoreId: _microsoftStoreId,
      );

  void limitTextLength() {
    if (textFieldController.text.length > maxLength) {
      textFieldController.text =
          textFieldController.text.substring(0, maxLength);
      textFieldController.selection = TextSelection.fromPosition(
          TextPosition(offset: textFieldController.text.length));
    }
    update();
  }

  getData() {
    if (Get.arguments != null) {
      if (Get.arguments["name"] != null && Get.arguments["avtar"] != null) {
        AvtarName = (Get.arguments["name"]);
        AvtarImage = (Get.arguments["avtar"]);
        debugPrint('$AvtarName');
        debugPrint('$AvtarImage');
      }
    }
  }

  String? truncateText(String? text, int maxLength) {
    if (text != null && text.length > maxLength) {
      return '${text.substring(0, maxLength)}...';
    } else {
      return text;
    }
  }

  void openBottomSheet() {
    // if (isBottomSheetOpen.value) {
    //   // Bottom sheet is already open, no need to open again
    //   return;
    // }
    //
    // isBottomSheetOpen.value = true;
    const duration = const Duration(milliseconds: 100);
    int index = 0;
    update();
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Hero(
              tag: 'heroTag',
              child: Lottie.asset(
                'assets/robt.json',
                height: 120,
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: appPinkColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25),
                    topLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Obx(() => CustomSimpleTextField(
                        letterpsacingValue: true,
                        textSizeValue: true,
                        textAlign: TextAlign.center,
                        hintText: df.value,
                        textSize: MediaQuery.of(Get.context!).size.width * 0.04,
                        hintColor: Colors.white,
                        fontfamily: 'summary',
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Timer.periodic(duration, (timer) {
      if (index < fullText.length) {
        df.value += fullText[index]; // Update df value
        index++;
        print(df.value);
      } else {
        timer.cancel();
        // Close the bottom sheet after 3 seconds
        Future.delayed(Duration(seconds: 3), () {
          //  Get.back(); // Close the bottom sheet
          // isBottomSheetOpen.value = false;
        });
      }
    });
  }

  void playBackgroundAudio(bool value) async {
    try {
      if (value!) {
        await audioPlayer.play(AssetSource(audioBackGroundPath));
        audioPlayer.setReleaseMode(ReleaseMode.loop);
        print('Audio playing background 2');
      } else {
        audioPlayer.stop();
        print('stoooooooooop');
      }
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  int? d;

  void playAudio() async {
    try {
      await audioPlayer.play(AssetSource(audioPath));
      print('Audio playing');

      print(gamesPlayed);
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
  }

  final List<ListItem> mixedData = [

    ListItem(
        title: txtRead1,
        subtitle: txtRead2,
        imagePath: appg9,
        imagePathBg: appg1,
        color: appOrangeColor,
        num: 9),
    ListItem(
        title: txtWord,
        subtitle: txtFindWord,
        imagePath: appWord,
        imagePathBg: appg4,
        color: appLightGreenColor,
        num: 10),
    ListItem(
        title: txtAnimalQuiz,
        subtitle: txtFind,
        imagePath: appanimal,
        imagePathBg: appg2,
        color: appyellowColor,
        num: 3),
    ListItem(
        title: txtColorPuzzle,
        subtitle: txtColorPuzzleAll,
        imagePath: appImageColor,
        imagePathBg: appg3,
        color: appyellowColor,
        num: 4),
    ListItem(
        title: txtNumbers,
        subtitle: txtAll,
        imagePath: appnumber,
        imagePathBg: appg1,
        color: appOrangeColor,
        num: 1),
    ListItem(
        title: txtToe,
        subtitle: txtJoin,
        imagePath: apptoe,
        imagePathBg: appg4,
        color: appLightGreenColor,
        num: 5),
    ListItem(
        title: txtPair1,
        subtitle: txtMatch1,
        imagePath: appNum,
        imagePathBg: appg2,
        color: appOrangeColor,
        num: 8),
    ListItem(
        title: txtPair,
        subtitle: txtMatch,
        imagePath: appPair1,
        //appAnswer,
        imagePathBg: appg5,
        color: appSkyColor,
        num: 6),
    ListItem(
        title: txtMathQuiz,
        subtitle: txtMathAccurate,
        imagePath: appMath,
        imagePathBg: appg6,
        color: appOrangeColor,
        num: 7),

  ];

  int calculateCrossAxisCount(BuildContext context) {
    // Calculate the number of columns based on the screen width
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount =
        (screenWidth / 150).floor(); // Adjust the 150 based on your item width

    // Ensure a minimum of one column
    return crossAxisCount > 0 ? crossAxisCount : 1;
  }

  @override
  void onReady() {
    super.onReady();
  }
}

class ListItem {
  final String title;
  final String subtitle;
  final String imagePath;
  final String imagePathBg;
  final Color color;
  final int num;

  ListItem({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.imagePathBg,
    required this.color,
    required this.num,
  });
}
