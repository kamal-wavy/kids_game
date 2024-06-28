import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../color.dart';
import '../../../../image.dart';

class StoryListController extends GetxController {
  @override
  String? getRoleId;

  // String getRoleId = '1';
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
    shuffleStoreList();
    startTyping();
    box.initStorage;
    isNumberPuzzleRobotShown = box.read('isNumberPuzzleRobotShown') ?? false;
    // showRobot();
  }

  void shuffleStoreList() {
    storeList.shuffle();
    storeListComedy.shuffle();
    storeListAdventure.shuffle();
  }

  getData() {
    if (Get.arguments != null) {
      if (Get.arguments["roleId"] != null) {
        getRoleId = (Get.arguments["roleId"]);

        debugPrint('$getRoleId');
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
        imageUrl: appN,
        name: 'NRS - LKG',
        gradientColor: appGradient4),
    YourDataModel(
        roleId: "2",
        imageUrl: appT,
        //appGsta,
        name: 'UKG - 1st',
        gradientColor: appGradient2),
    YourDataModel(
        roleId: "3",
        imageUrl: appF,
        //appGsta,
        name: '2nd - 5th',
        gradientColor: appGradient2),
  ];
  List<StoreList> storeList = [
    StoreList(title: 'The boy who cried wolf', id: 1, imagePathBg: appS1),
    // StoreList(title: 'The Thirsty crow', id: 2, imagePathBg: appS2),
    // StoreList(title: 'The Golden touch', id: 3, imagePathBg: appS3),
    StoreList(title: 'The Fox and the grapes', id: 4, imagePathBg: appS4),
    // StoreList(title: 'The Proud rose', id: 5, imagePathBg: appS5),
    StoreList(title: 'The Milkmaid and her pail', id: 6, imagePathBg: appS6),
    // StoreList(title: 'A wise old owl', id: 7, imagePathBg: appS8),
    // StoreList(title: 'The Golden egg', id: 8, imagePathBg: appS9),
    // StoreList(title: 'The Magic Garden', id: 21, imagePathBg: appS10),
    // StoreList(title: 'The Great Race', id: 22, imagePathBg: appS11),
    // StoreList(title: 'The Helpful Ant', id: 23, imagePathBg: appS12),
    StoreList(title: 'The Magical Toy Shop', id: 24, imagePathBg: appS13),
  ];

  // Adventure
  List<StoreList> storeListAdventure = [
    StoreList(
        title: 'The Magical Forest Adventure', id: 25, imagePathBg: appA17),
    StoreList(title: 'The Underwater Kingdom', id: 26, imagePathBg: appA18),
    StoreList(title: 'The Time-Traveling Twins', id: 27, imagePathBg: appA19),
    StoreList(
        title: """Journey to the Dragon's Cave""", id: 28, imagePathBg: appA20),
  ];

  // comedy

  List<StoreList> storeListComedy = [
    StoreList(
        title: 'The Silly Circus Catastrophe', id: 29, imagePathBg: appC21),
    StoreList(
        title: 'The Pizza Parlor Pandemonium', id: 30, imagePathBg: appC22),
    StoreList(title: 'The Giggle Ghost Mystery', id: 31, imagePathBg: appC23),
    StoreList(
        title: """The Daring Dinosaur Dilemma""", id: 32, imagePathBg: appC24),
  ];
  List<StoreList> nurseyPoemList = [
    StoreList(title: 'Snowball By Shel', id: 9, imagePathBg: ''),
    StoreList(title: 'The Crocodile', id: 10, imagePathBg: ''),
    StoreList(title: 'Now We Are Six', id: 11, imagePathBg: ''),
    StoreList(title: 'Rabbits by Shannon', id: 12, imagePathBg: ''),
  ];

  List<StoreList> secondPoemList = [
    StoreList(title: 'Mary Had a Little Lamb', id: 13, imagePathBg: ''),
    StoreList(title: 'Rain, Rain, Go Away', id: 14, imagePathBg: ''),
    StoreList(title: """I'm a Little Teapot""", id: 15, imagePathBg: ''),
    StoreList(title: 'Baa, Baa, Black Sheep', id: 16, imagePathBg: ''),
  ];
  List<StoreList> fifthPoemList = [
    StoreList(title: 'Stopping by Woods', id: 17, imagePathBg: ''),
    StoreList(title: 'The Eagle', id: 18, imagePathBg: ''),
    StoreList(title: 'Daffodils', id: 19, imagePathBg: ''),
    StoreList(title: 'Fire and Ice', id: 20, imagePathBg: ''),
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
