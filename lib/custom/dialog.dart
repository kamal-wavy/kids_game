import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:KidsPlan/custom/simpleText.dart';

import '../color.dart';
import '../image.dart';
import '../string.dart';
import 'material_button.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String content;

  CustomDialog({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: const Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: [
              // Image.asset(appWarning),
              SizedBox(
                width: 10,
              ),
              CustomSimpleTextField(
                textSizeValue: true,
                hintText: title,
                hintColor: Colors.red,
                textSize: 18,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: CustomSimpleTextField(
              textSizeValue: true,
              hintText: content,
              hintColor: greyColor,
              textSize: 16,
              textAlign: TextAlign.center,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CustomButton(
                text: 'txtCancel',
                onPressed: () {
                  Get.back();
                },
                miniButton: true,
              ),
              CustomButton(
                text: 'txtConfirm',
                onPressed: () {},
                miniButton: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// To show the dialog, you can use the following:
