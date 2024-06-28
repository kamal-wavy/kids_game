import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:esys_flutter_share_plus/esys_flutter_share_plus.dart';
import 'package:flutter_native_screenshot/flutter_native_screenshot.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class ScreenshotController extends GetxController {
  Future<void> takeScreenshotAndShare() async {
    try {
      // Capture the screenshot and get the file path
      String? imagePath = await FlutterNativeScreenshot.takeScreenshot();

      if (imagePath != null) {
        // Read the contents of the image file as bytes
        Uint8List imageBytes = File(imagePath).readAsBytesSync();

        // Get the directory where the screenshot will be saved
        final directory = await getApplicationDocumentsDirectory();
        File imgFile = File('${directory.path}/screenshot.png');

        // Save the screenshot to a file
        await imgFile.writeAsBytes(imageBytes);

        print("File Saved to Gallery");
        // Share.text('Smart Kidz', 'https://play.google.com/store/apps/details?id=com.example.quickgameapp',
        //     'text/plain');
        // Share the captured screenshot
        await Share.file('Smart Kidz', 'screenshot.png', imageBytes, 'image/png',
            text:
                'https://play.google.com/store/apps/details?id=com.kidsiq.quickgameapp&hl=en_US&gl=TR');
      } else {
        print("Failed to capture screenshot");
      }
    } catch (error) {
      print(error);
    }
  }
}
