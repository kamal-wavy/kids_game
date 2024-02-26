import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;

class ImagePuzzleOptionController extends GetxController {
  @override
  // String? getRoleId;
  final AudioPlayer audioPlayer = AudioPlayer();
  File? imageFile;
  List<Uint8List> puzzlePieces = [];

  // String audioPath = 'audio/ping.mp3';
  String audioPath = 'audio/click.mp3';
  List<String> containerList = ['1', '2', '3'];

  @override
  void onInit() {
    super.onInit();
  }

  void playAudio() async {
    try {
      await audioPlayer.play(AssetSource(audioPath));
      print('Audio playing');
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  List<Uint8List> cutImageIntoPieces(img.Image image) {
    final List<Uint8List> pieces = [];

    final pieceWidth =
        (image.width - 4) ~/ 3; // Adjusted width with a 4-pixel overlap
    final pieceHeight =
        (image.height - 4) ~/ 3; // Adjusted height with a 4-pixel overlap

    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 3; col++) {
        final piece = img.copyCrop(
          image,
          x: col * pieceWidth,
          y: row * pieceHeight,
          width: pieceWidth + 4, // Add 4-pixel overlap
          height: pieceHeight + 4,
          // interpolation: img.Interpolation.linear,// Add 4-pixel overlap
        );
        pieces.add(Uint8List.fromList(img.encodePng(piece)));
      }
    }

    return pieces;
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
