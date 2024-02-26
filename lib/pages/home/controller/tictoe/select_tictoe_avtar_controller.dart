import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TicToeSelectAvtarController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  final AudioPlayer audioPlayer = AudioPlayer();

  String audioPath = 'audio/click.mp3';

  void playAudio() async {
    try {
      await audioPlayer.play(AssetSource(audioPath));
      print('Audio playing');
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
  }

  TextEditingController textField1Controller = TextEditingController();
  TextEditingController textField2Controller = TextEditingController();
  List<DropdownItem> items = [
    DropdownItem('Peter', 'assets/avtars/a1.png'),
    DropdownItem('Hazel', 'assets/avtars/a2.png'),
    DropdownItem('Rocky', 'assets/avtars/a9.png'),
  ];
  List<DropdownItem> items1 = [
    DropdownItem('Akilla', 'assets/avtars/a10.png'),
    DropdownItem('John', 'assets/avtars/a11.png'),
    DropdownItem('Amele', 'assets/avtars/a7.png'),
  ];
  int selectedValue = 0;
  int? selectedSeriesNum;

  String seriesNum3 = '3';
  String seriesNum5 = '5';
  DropdownItem? selectedItem;
  DropdownItem? selectedItem1;
}

class DropdownItem {
  final String text;
  final String imageAsset;

  DropdownItem(this.text, this.imageAsset);
}
