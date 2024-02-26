import 'package:KidsPlan/custom/simpleText.dart';
import 'package:KidsPlan/image.dart';
import 'package:KidsPlan/pages/initial/view/select_game_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app_argument.dart';
import '../../../color.dart';
import '../../../string.dart';
import '../controller/select_avtar_controllr.dart';

class SelectAvtarScreen extends GetView<SelectAvtarController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SelectAvtarController>(
        init: SelectAvtarController(),
        builder: (context) {
          return Scaffold(
              body: Stack(
            children: [
              Image.asset(
                appgameBg,
                fit: BoxFit.fill,
                height: double.infinity,
                width: double.infinity,
              ),
              SingleChildScrollView(
                child: SafeArea(
                    child: Form(
                  key: controller.formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Obx(() {
                        return Column(
                          children: [
                            CustomSimpleTextField(
                              hintText: 'Selected Avtar',
                              textSizeValue: true,
                              hintColor: appColor,
                              textSize: 30,
                              fontfamily: 'summary',
                            ),
                            controller.selectedAvatar.value == ''
                                ? CircleAvatar(
                                    radius: 50,
                                    backgroundImage: AssetImage(appPholder),
                                  )
                                : Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Image.asset(
                                        appBigCircle,
                                        height: 110,
                                      ),
                                      Image.asset(
                                        controller.selectedAvatar.value,
                                        height: 50,
                                        fit: BoxFit.fill,
                                      ),
                                    ],
                                  ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomSimpleTextField(
                                hintText: 'Select Avtar',
                                textSizeValue: true,
                                hintColor: appRedColor,
                                textSize: 30,
                                fontfamily: 'summary',
                              ),
                            ),
                          ],
                        );
                      }),
                      Obx(() {
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                          ),
                          itemCount: controller.avatars.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                controller.playAudio();
                                controller.selectedAvatar.value =
                                    controller.avatars[index];
                              },
                              child: Container(
                                  margin: const EdgeInsets.all(8.0),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Image.asset(appCircle),
                                      Image.asset(
                                        controller.avatars[index],
                                        height: 80,
                                        fit: BoxFit.fill,
                                      ),
                                    ],
                                  )),
                            );
                          },
                        );
                      }),
                      Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 50.0, right: 50),
                            child: new TextFormField(
                              controller: controller.textFieldController,
                              decoration: new InputDecoration(
                                labelText: "Your Name",
                                fillColor: Colors.white,
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(25.0),
                                  borderSide: new BorderSide(),
                                ),
                                //fillColor: Colors.green
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter name';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.emailAddress,
                              style: new TextStyle(
                                fontFamily: "Poppins",
                              ),
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: GestureDetector(
                                onTap: () {
                                  controller.playAudio();
                                  if (controller.formKey.currentState
                                          ?.validate() ??
                                      false) {
                                    if (controller.selectedAvatar.value == '') {
                                      Get.snackbar(
                                        icon: Icon(Icons
                                            .notification_important_outlined),
                                        backgroundColor: appColor,
                                        'Warning',
                                        '',
                                        messageText: CustomSimpleTextField(
                                          textSizeValue: true,
                                          hintText: 'Please select avtar',
                                          textSize: 18,
                                          hintColor: blackColor,
                                          fontfamily: 'Monstreat',
                                        ),
                                      );
                                    } else {
                                      controller.userData
                                          .write(isVerifiedUser, true);
                                      controller.userData.write(userName,
                                          controller.textFieldController.text);
                                      controller.userData.write(userImage,
                                          controller.selectedAvatar.value);
                                      Get.to(SelectGameScreen(), arguments: {
                                        'name':
                                            controller.textFieldController.text,
                                        'avtar': controller.selectedAvatar.value
                                      });
                                    }
                                  }
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Image.asset(appGnext),
                                    CustomSimpleTextField(
                                      hintText: txtSubmit,
                                      textSizeValue: true,
                                      hintColor: Colors.white,
                                      textSize: 30,
                                      fontfamily: 'summary',
                                    ),
                                  ],
                                ),
                              ))
                        ],
                      )
                    ],
                  ),
                )),
              )
            ],
          ));
        });
  }
}
