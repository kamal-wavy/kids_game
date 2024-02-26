// music_controller.dart
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';

class MusicController extends GetxController {
  var isMusicOn = true.obs;
  var isMusicControlActive = false.obs; // New flag
  late AudioPlayer audioPlayer;
  String audioPath = 'audio/fullMusic.mp3';
  @override
  void onInit() {
    super.onInit();
    audioPlayer = AudioPlayer();
    _initListeners();
  }

  void _initListeners() {
    audioPlayer.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.completed && isMusicOn.value) {
        audioPlayer.seek(Duration.zero);
        audioPlayer.play(AssetSource(audioPath));
      }
    });
  }

  void toggleMusic() {
    if (isMusicControlActive.value) {
      if (isMusicOn.value) {
        audioPlayer.pause();
      } else {
        audioPlayer.resume();
      }
      isMusicOn.toggle();
    }
  }

  void activateMusicControl() {
    isMusicControlActive.value = true;
  }

  void deactivateMusicControl() {
    isMusicControlActive.value = false;
  }

  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }
}
