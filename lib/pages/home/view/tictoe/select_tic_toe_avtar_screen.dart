import 'package:KidsPlan/color.dart';
import 'package:KidsPlan/pages/home/view/tictoe/play_tic_toe_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../custom/simpleText.dart';
import '../../../../image.dart';
import '../../../../routes/app_routes.dart';
import '../../../../string.dart';
import '../../controller/tictoe/select_tictoe_avtar_controller.dart';
import 'history.dart';

class TicToeSelectAvtarScreen extends GetView<TicToeSelectAvtarController> {
  @override
  Widget build(BuildContext context) {
    Get.put(TicToeSelectAvtarController());
    return GetBuilder<TicToeSelectAvtarController>(
        init: TicToeSelectAvtarController(),
        builder: (context) {
          return Scaffold(body: _bodyWidget(controller));
        });
  }
}

_bodyWidget(TicToeSelectAvtarController controller) {
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
      SingleChildScrollView(
        child: SafeArea(
          child: Container(
            height: MediaQuery.of(Get.context!).size.height,
            padding: EdgeInsets.only(left: 30, right: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                              onTap: () {
                                Get.offAllNamed(AppRoutes.selectGameScreen);
                              },
                              child: Image.asset(appBack)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                              onTap: () {
                                Get.to(HistoryPlayTicToeScreen());
                              },
                              child: Image.asset(appHistory)),
                        ),
                      ],
                    ),
                    Image.asset(
                      appNewTic,
                      height: 150,
                    ),
                  ],
                ),
                Column(
                  children: [
                    CustomSimpleTextField(
                      textSizeValue: true,
                      textAlign: TextAlign.center,
                      hintText: 'Welcome!',
                      textSize: 28,
                      hintColor: appRedColor,
                      fontfamily: 'summary',
                    ),
                    CustomSimpleTextField(
                      textSizeValue: true,
                      textAlign: TextAlign.center,
                      hintText: txtWelcome,
                      textSize: 25,
                      hintColor: appRedColor,
                      fontfamily: 'summary',
                    ),
                    SizedBox(height: 20),
                    controller.selectedValue == 0
                        ? Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [shadow],
                                      borderRadius: BorderRadius.circular(40)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8),
                                    child: DropdownButton<DropdownItem>(
                                      underline: SizedBox(),
                                      value: controller.selectedItem1,
                                      items: controller.items
                                          .map((DropdownItem item) {
                                        return DropdownMenuItem<DropdownItem>(
                                          value: item,
                                          child: Row(
                                            children: <Widget>[
                                              Image.asset(item.imageAsset,
                                                  width: 40, height: 40),
                                              SizedBox(width: 8),
                                              CustomSimpleTextField(
                                                textSizeValue: true,
                                                hintText: item.text,
                                                textSize: 25,
                                                hintColor: appColor,
                                                fontfamily: 'summary',
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (DropdownItem? newValue) {
                                        controller.selectedItem1 = newValue;
                                        controller.update();
                                      },
                                      hint: Center(
                                        child: CustomSimpleTextField(
                                          textSizeValue: true,
                                          hintText: txtAvtar1,
                                          textSize: 20,
                                          hintColor: appColor,
                                          fontfamily: 'Montstreat',
                                        ),
                                      ),
                                      isExpanded: true,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [shadow],
                                      borderRadius: BorderRadius.circular(40)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8),
                                    child: DropdownButton<DropdownItem>(
                                      underline: SizedBox(),
                                      value: controller.selectedItem,
                                      items: controller.items1
                                          .map((DropdownItem item) {
                                        return DropdownMenuItem<DropdownItem>(
                                          value: item,
                                          child: Row(
                                            children: <Widget>[
                                              Image.asset(item.imageAsset,
                                                  width: 40, height: 40),
                                              SizedBox(width: 8),
                                              CustomSimpleTextField(
                                                textSizeValue: true,
                                                hintText: item.text,
                                                textSize: 25,
                                                hintColor: appColor,
                                                fontfamily: 'summary',
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (DropdownItem? newValue) {
                                        controller.selectedItem = newValue;
                                        controller.update();
                                      },
                                      hint: Center(
                                        child: CustomSimpleTextField(
                                          textSizeValue: true,
                                          hintText: txtAvtar2,
                                          textSize: 20,
                                          hintColor: appColor,
                                          fontfamily: 'Montstreat',
                                        ),
                                      ),
                                      isExpanded: true,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        : Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(40)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8),
                                    child: DropdownButton<DropdownItem>(
                                      underline: SizedBox(),
                                      value: controller.selectedItem1,
                                      items: controller.items
                                          .map((DropdownItem item) {
                                        return DropdownMenuItem<DropdownItem>(
                                          value: item,
                                          child: Row(
                                            children: <Widget>[
                                              Image.asset(item.imageAsset,
                                                  width: 40, height: 40),
                                              SizedBox(width: 8),
                                              CustomSimpleTextField(
                                                textSizeValue: true,
                                                hintText: item.text,
                                                textSize: 25,
                                                hintColor: appColor,
                                                fontfamily: 'summary',
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (DropdownItem? newValue) {
                                        controller.selectedItem1 = newValue;
                                        controller.update();
                                        print(controller.selectedItem1);
                                      },
                                      hint: Center(
                                        child: CustomSimpleTextField(
                                          textSizeValue: true,
                                          hintText: txtMyAvtar,
                                          textSize: 25,
                                          hintColor: appColor,
                                          fontfamily: 'summary',
                                        ),
                                      ),
                                      isExpanded: true,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(40)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8, top: 5, bottom: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Image.asset('assets/s6.png',
                                            width: 40, height: 40),
                                        SizedBox(width: 8),
                                        CustomSimpleTextField(
                                          textSizeValue: true,
                                          hintText: 'Jerry',
                                          textSize: 25,
                                          hintColor: appColor,
                                          fontfamily: 'summary',
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                    SizedBox(height: 20),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomSimpleTextField(
                        hintText: txtSeries,
                        textSize: 25,
                        hintColor: appRedColor,
                        fontfamily: 'summary',
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                            onTap: () {
                              controller.selectedSeriesNum = 3;
                              controller.update();
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset(
                                  appNumberBox,
                                  height: 70,
                                  color: controller.selectedSeriesNum == 3
                                      ? appRedColor
                                      : null,
                                ),
                                CustomSimpleTextField(
                                  textSizeValue: true,
                                  hintText: '3',
                                  textSize: 30,
                                  hintColor: Colors.white,
                                  fontfamily: 'Montstreat',
                                ),
                              ],
                            )),
                        SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                            onTap: () {
                              controller.selectedSeriesNum = 5;
                              controller.update();
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset(appNumberBox,
                                    height: 70,
                                    color: controller.selectedSeriesNum == 5
                                        ? appRedColor
                                        : null),
                                CustomSimpleTextField(
                                  textSizeValue: true,
                                  hintText: '5',
                                  textSize: 30,
                                  hintColor: Colors.white,
                                  fontfamily: 'Montstreat',
                                ),
                              ],
                            )),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: GestureDetector(
                        onTap: () {
                          print(controller.selectedValue);
                          if (controller.selectedSeriesNum == null ||
                              controller.selectedItem == null ||
                              controller.selectedItem1 == null) {
                            Get.snackbar(
                              icon: Icon(Icons.notification_important_outlined),
                              backgroundColor: appColor,
                              'Warning',
                              '',
                              messageText: CustomSimpleTextField(
                                textSizeValue: true,
                                hintText: 'Please select player and series',
                                textSize: 18,
                                hintColor: blackColor,
                                fontfamily: 'Monstreat',
                              ),
                            );
                          } else {
                            controller.selectedValue == 0
                                ? Get.to(PlayTicToeScreen(), arguments: {
                                    'numSeries': controller.selectedSeriesNum,
                                    'selectedItem': controller.selectedItem,
                                    'selectedItem1': controller.selectedItem1,
                                  })
                                : Get.to(PlayTicToeScreen(), arguments: {});
                          }
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(appbtn2),
                            CustomSimpleTextField(
                              textSizeValue: true,
                              hintText: txtSubmit,
                              textSize: 30,
                              hintColor: Colors.white,
                              fontfamily: 'summary',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}
