import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../sqlite_data/sqlite_data_store.dart';

class HistoryTicToeController extends GetxController
    with SingleGetTickerProviderMixin {
  @override
  final DBStudentManager dbStudentManager = new DBStudentManager();

  UserData? userData;
  int? updateindex;

  List<UserData>? userDataList;

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
