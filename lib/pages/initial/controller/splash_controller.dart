import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../app_argument.dart';
import '../../../routes/app_routes.dart';
import '../../../test.dart';

class SplashController extends GetxController {
  bool? loginCheck;
  var dark = false;
  final userData = GetStorage();
  final AudioPlayer audioPlayer = AudioPlayer();

  String audioPath = 'audio/fullMusic.mp3';

  RxBool isMusicPlaying = true.obs;

  void toggleMusic() {
    if (isMusicPlaying.value) {
      audioPlayer.pause();
    } else {
      audioPlayer.resume();
    }
    isMusicPlaying.value = !isMusicPlaying.value;
    userData.write('toggleState', isMusicPlaying.value);
  }

  void playMusic(bool value) async {
    if (value!) {
      await audioPlayer.play(AssetSource(audioPath));
      audioPlayer.setReleaseMode(ReleaseMode.loop);
      print('Audio playing  background 1313');
    } else {
      audioPlayer.stop();
      print('stoooooooooop');
    }
  }

  @override
  void onInit() {
    WidgetsBinding.instance?.addObserver(_BackgroundMusicObserver(this));

    userData.writeIfNull(isVerifiedUser, false);
    isMusicPlaying.value = userData.read('toggleState') ?? true;
    Future.delayed(Duration.zero, () async {
      startTimer();
    });
    if (userData.read('toggleState') == true) {
      return playMusic(true);
    } else if (userData.read('toggleState') == false) {
      print('dooooooooooooooooone music falsseeeeeeeeeeeee');
      return null;
    } else {
      return playMusic(true);
    }

    super.onInit();
  }

  void playAudio(bool value) async {
    try {
      if (value!) {
        await audioPlayer.play(AssetSource(audioPath));
        audioPlayer.setReleaseMode(ReleaseMode.loop);
        print('Audio playing  background');
      } else {
        audioPlayer.stop();
        print('stoooooooooop');
      }
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  void pauseMusic() {
    audioPlayer.pause();
  }

  startTimer() async {
    var duration = Duration(seconds: 3);
    return Timer(duration, route);
  }

  route() {
    // Get.to(Blast());
    // Get.offNamed(AppRoutes.mathGridScreen);
    // Get.offNamed(AppRoutes.pairGridScreen);


    userData.read(isVerifiedUser)
        ? Get.offNamed(AppRoutes.selectGameScreen)
        : Get.offNamed(AppRoutes.selectAvtarScreen);
  }

  void changeTheme(state) {
    if (state == true) {
      dark = true;
      Get.changeTheme(ThemeData.dark());
    } else {
      dark = false;
      Get.changeTheme(ThemeData.light());
    }
    update();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    audioPlayer.dispose();
    print('rajja abeta music band ho gya hai');
    super.dispose();
  }

  @override
  void onClose() {
    WidgetsBinding.instance?.removeObserver(_BackgroundMusicObserver(this));
    audioPlayer.dispose();

    super.onClose();
  }
}

class _BackgroundMusicObserver extends WidgetsBindingObserver {
  final SplashController _splashController;

  _BackgroundMusicObserver(this._splashController);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        if (_splashController.userData.read('toggleState') == true) {
          return _splashController.playAudio(true);
        } else if (_splashController.userData.read('toggleState') == false) {
          print('dooooooooooooooooone music falsseeeeeeeeeeeee');
          return null;
        } else {
          return _splashController.playAudio(true);
        }
        _splashController.playAudio(true);
        print('App is in the foreground, start/resume background music');
        break;
      case AppLifecycleState.paused:
        _splashController.pauseMusic();
        print('App is in the background, stop background music');
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:
        // TODO: Handle this case.
    }
  }
}
