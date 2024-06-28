import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../color.dart';
import '../../../../image.dart';

class RhymeListController extends GetxController {
  @override
  String? getRoleId;
  String? getGameId;
  String? getNewId;
  final AudioPlayer audioPlayer = AudioPlayer();

  // String audioPath = 'audio/ping.mp3';
  String audioPath = 'audio/click.mp3';
  List<String> containerList = ['1', '2', '3'];
  String text = "";
  int index = 0;
  final String fullText = "Tackle these quick\npuzzles!";
  bool isNumberPuzzleRobotShown = false;
  final box = GetStorage();
  var selectedIndex = 0.obs;
  TabController? tabController;

  void changeTabIndex(int index) {
    selectedIndex.value = index;
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

  @override
  void onInit() async {
    super.onInit();
    getData();
    startTyping();
    box.initStorage;
    isNumberPuzzleRobotShown = box.read('isNumberPuzzleRobotShown') ?? false;
    // showRobot();
  }

  getData() {
    if (Get.arguments != null) {
      if (Get.arguments["roleId"] != null ||
              Get.arguments["sendGameId"] != null ||
          Get.arguments["sendRoleId"] != null) {
        getRoleId = (Get.arguments["roleId"]);
        getGameId = (Get.arguments["sendGameId"]);
        getNewId = (Get.arguments["sendRoleId"]);

        debugPrint('$getRoleId');
        debugPrint('$getGameId');
        debugPrint('$getNewId');
      }
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

  List<YourDataModel> yourDataList = [
    YourDataModel(
        roleId: "1",
        imageUrl: appB1,
        name: 'NRS - LKG',
        gradientColor: appGradient4),
    YourDataModel(
        roleId: "2",
        imageUrl: appB2,
        //appGsta,
        name: 'UKG - 1st',
        gradientColor: appGradient2),
    YourDataModel(
        roleId: "3",
        imageUrl: appB2,
        //appGsta,
        name: '2nd - 5th',
        gradientColor: appGradient2),
  ];

  List<StoreList> nurseyPoemList = [
    StoreList(title: 'Snowball By Shel', id: 9, imagePathBg: appNr),
    StoreList(title: 'The Crocodile', id: 10, imagePathBg: appNr1),
    StoreList(title: 'Now We Are Six', id: 11, imagePathBg: appNr2),
    StoreList(title: 'Rabbits by Shannon', id: 12, imagePathBg: appNr3),
  ];

  List<StoreList> secondPoemList = [
    StoreList(title: 'Mary Had a Little Lamb', id: 13, imagePathBg: appTr),
    StoreList(title: 'Rain, Rain, Go Away', id: 14, imagePathBg: appTr1),
    StoreList(title: """I'm a Little Teapot""", id: 15, imagePathBg: appTr2),
    StoreList(title: 'Baa, Baa, Black Sheep', id: 16, imagePathBg: appTr3),
  ];
  List<StoreList> fifthPoemList = [
    StoreList(title: 'Stopping by Woods', id: 17, imagePathBg: appFh),
    StoreList(title: 'The Eagle', id: 18, imagePathBg: appFh1),
    StoreList(title: 'Daffodils', id: 19, imagePathBg: appFh2),
    StoreList(title: 'Fire and Ice', id: 20, imagePathBg: appFh3),
  ];

  @override
  void dispose() {
    audioPlayer.dispose();

    super.dispose();
  }

  @override
  void onReady() {
    super.onReady();
  }
}

class StoreList {
  final String title;
  final int id;
  final String imagePathBg;

  StoreList({
    required this.title,
    required this.id,
    required this.imagePathBg,
  });
}

class YourDataModel {
  final String imageUrl;
  final String roleId;
  final String name;
  final Gradient gradientColor;

  YourDataModel(
      {required this.imageUrl,
      required this.roleId,
      required this.name,
      required this.gradientColor});
}
