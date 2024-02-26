import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../app_argument.dart';
import '../../../color.dart';
import '../../../image.dart';
import '../../../string.dart';

class SelectGameController extends GetxController {
  bool? loginCheck;
  var dark = false;
  final userData = GetStorage();
  var AvtarName;
  var AvtarImage;

  RxBool isToggleSwitchOn = true.obs;
  final AudioPlayer audioPlayer = AudioPlayer();
  TextEditingController textFieldController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String audioPath = 'audio/click.mp3';
  String audioBackGroundPath = 'audio/fullMusic.mp3';

  String text = "";
  int index = 0;
  final String fullText = "Hey kids! play games that\nmake you super smart!";

  int editName = 0;

  void toggleSwitch() {
    isToggleSwitchOn.value = !isToggleSwitchOn.value;
    userData.write('toggleState', isToggleSwitchOn.value);
  }

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

  @override
  void onInit() {
    super.onInit();
    startTyping();
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

  void playAudio() async {
    try {
      await audioPlayer.play(AssetSource(audioPath));
      print('Audio playing');
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
        title: txtNumbers,
        subtitle: txtAll,
        imagePath: appnumber,
        imagePathBg: appg1,
        color: appOrangeColor,
        num: 1),
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
        title: txtToe,
        subtitle: txtJoin,
        imagePath: apptoe,
        imagePathBg: appg4,
        color: appLightGreenColor,
        num: 5),
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
