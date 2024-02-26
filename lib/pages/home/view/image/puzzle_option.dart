import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
// import 'package:image_picker/image_picker.dart';
import 'package:KidsPlan/color.dart';

import '../../../../custom/simpleText.dart';
import '../../../../image.dart';
import '../../../../string.dart';
import '../../../initial/view/select_game_screen.dart';
import '../../controller/image/image_option_controller.dart';
import 'image_picked_solve_screen.dart';

class ImagePuzzleOptionScreen extends GetView<ImagePuzzleOptionController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ImagePuzzleOptionController>(
        init: ImagePuzzleOptionController(),
        builder: (context) {
          Get.put(ImagePuzzleOptionController());
          return Scaffold(body: _bodyWidget(controller));
        });
  }
}

_bodyWidget(ImagePuzzleOptionController controller) {
  return Stack(
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
              child: Image.asset(
            appselectbg,
            fit: BoxFit.fill,
          )),
        ],
      ),
      SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                      onTap: () {
                        Get.to(SelectGameScreen());
                      },
                      child: Image.asset(appBack)),
                ),
                CustomSimpleTextField(
                  hintText: txtGameOptions,
                  fontfamily: 'summary',
                  textSize: 40,
                  hintColor: appColor,
                ),
                SizedBox(
                  width: 50,
                )
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final ByteData data =
                          await rootBundle.load('assets/dog.jpg');
                      final List<int> bytes = data.buffer.asUint8List();
                      final image = img.decodeImage(Uint8List.fromList(bytes));

                      controller.puzzlePieces = controller
                          .cutImageIntoPieces(image!) as List<Uint8List>;
                      controller.update();
                      Duration(seconds: 5);
                      print('kamal');
                      Get.to(ImagePickedSolveScreen(), arguments: {
                        'puzzlePieces': controller.puzzlePieces ?? "",
                        'assetImage': 'assets/dog.jpg',
                        'getRoleId': '0',
                      });
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(appGnext),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomSimpleTextField(
                            hintText: txtPStart,
                            textSizeValue: true,
                            hintColor: Colors.white,
                            textSize: 25,
                            fontfamily: 'summary',
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      // final imagePicker = ImagePicker();
                      // final pickedFile = await imagePicker.getImage(
                      //   source: ImageSource.gallery,
                      // );
                      //
                      // if (pickedFile != null) {
                      //   final image = img.decodeImage(
                      //       File(pickedFile.path).readAsBytesSync());
                      //
                      //   controller.imageFile = File(pickedFile.path);
                      //   controller.puzzlePieces =
                      //       controller.cutImageIntoPieces(image!);
                      //   controller.update();
                      // }
                      // Get.to(ImagePickedSolveScreen(), arguments: {
                      //   'puzzlePieces': controller.puzzlePieces ?? "",
                      //   'fullImage': controller.imageFile ?? "",
                      //   'getRoleId': '1',
                      // });
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(appbtn2),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomSimpleTextField(
                            hintText: txtPickImage,
                            textSizeValue: true,
                            hintColor: Colors.white,
                            textSize: 25,
                            fontfamily: 'summary',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ],
  );
}

showDialogBox(ImagePuzzleOptionController controller) {
  return showDialog<void>(
    context: Get.context!,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('How to play this game!!'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Given a name, display multiple"
                " images below. Your task is to select the"
                " correct image that matches the given name. If your selection"
                " is correct,"
                " proceed to the next round; otherwise, display an error message."),
          ],
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              controller.playAudio();
              Get.back();
            },
          ),
        ],
      );
    },
  );
}
