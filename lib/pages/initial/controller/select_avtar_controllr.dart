import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SelectAvtarController extends GetxController {
  RxString selectedAvatar = ''.obs;
  TextEditingController textFieldController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final AudioPlayer audioPlayer = AudioPlayer();

  final userData = GetStorage();
  String validationMessage = '';
  String audioPath = 'audio/click.mp3';

  final List<String> avatars = [
    'assets/avtars/a1.png',
    'assets/avtars/a2.png',
    'assets/avtars/a9.png',
    'assets/avtars/a10.png',
    'assets/avtars/a11.png',
    'assets/avtars/a7.png',
  ].obs;

  void playAudio() async {
    try {
      await audioPlayer.play(AssetSource(audioPath));
      print('Audio playing');
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }
}
