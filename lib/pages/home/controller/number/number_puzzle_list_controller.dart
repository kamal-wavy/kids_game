import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NumberPuzzleListController extends GetxController {
  @override
  String? getRoleId;
  final AudioPlayer audioPlayer = AudioPlayer();

  // String audioPath = 'audio/ping.mp3';
  String audioPath = 'audio/click.mp3';
  List<String> containerList = ['1', '2', '3'];
  String text = "";
  int index = 0;
  final String fullText = "Hi, tackle these quick\npuzzles!";

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
  void onInit() {
    super.onInit();
    getData();
    startTyping();
  }

  void playAudio() async {
    try {
      await audioPlayer.play(AssetSource(audioPath));
      print('Audio playing');
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  getData() {
    if (Get.arguments != null) {
      if (Get.arguments["roleId"] != null) {
        getRoleId = (Get.arguments["roleId"]);

        debugPrint('$getRoleId');
      }
    }
  }

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
