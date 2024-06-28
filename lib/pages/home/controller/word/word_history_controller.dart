import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../sqlite_data/number_game_data/data.dart';
import '../../../../sqlite_data/sqlite_data_store.dart';
import '../../../../sqlite_data/word_game_data.dart';

class WordHistoryController extends GetxController
    with SingleGetTickerProviderMixin {
  @override
  final DBWordGame dbWordManager = new DBWordGame();

  UserData? userData;
  int? updateindex;

  List<WordUserData>? userDataList;

  @override
  void onInit() {
    super.onInit();
  }

  int currentSetIndex = 0;
  int correctAnswers = 0;
  Timer? timer;
  int secondsElapsed = 0;
  String message = '';
  late List<Color> starColors;
  late List<AnimationController> controllers;
  bool isTimerPaused = false;

  @override
  void onReady() {
    super.onReady();
  }
}
