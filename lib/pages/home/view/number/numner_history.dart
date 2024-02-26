import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:KidsPlan/sqlite_data/number_game_data/data.dart';

import '../../../../color.dart';
import '../../../../custom/simpleText.dart';
import '../../../../image.dart';
import '../../controller/number/number_history_controller.dart';
import 'number_puzzle_list_screen.dart';

class NumberHistoryScreen extends GetView<NumberHistoryController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<NumberHistoryController>(
        init: NumberHistoryController(),
        builder: (context) {
          return Scaffold(
              body: SingleChildScrollView(child: _bodyWidget(controller)));
        });
  }
}

_bodyWidget(NumberHistoryController controller) {
  return Stack(
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(
            appselectbg,
            fit: BoxFit.fill,
          ),
        ],
      ),
      SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                        onTap: () {
                          Get.to(NumberPuzzleListScreen());
                        },
                        child: Image.asset(appBack)),
                  ),
                  CustomSimpleTextField(
                    textSizeValue: true,
                    hintText: 'History',
                    textSize: 30,
                    hintColor: appColor,
                    fontfamily: 'summary',
                  ),
                  SizedBox(
                    width: 50,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder(
                future: controller.dbStudentManager.getStudentList(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    controller.userDataList = snapshot.data;
                    return snapshot.data!.isEmpty
                        ? Center(
                            child: CustomSimpleTextField(
                              textSizeValue: true,
                              hintText: 'No data found',
                              textSize: 25,
                              hintColor: blackColor,
                              fontfamily: 'summary',
                            ),
                          )
                        : Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: CustomSimpleTextField(
                                      textSizeValue: true,
                                      hintText: 'Type',
                                      textSize: 24,
                                      hintColor: blackColor,
                                      fontfamily: 'summary',
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: CustomSimpleTextField(
                                      textSizeValue: true,
                                      hintText: 'Time',
                                      textSize: 24,
                                      hintColor: blackColor,
                                      fontfamily: 'summary',
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: CustomSimpleTextField(
                                      textSizeValue: true,
                                      hintText: 'Moves',
                                      textSize: 24,
                                      hintColor: blackColor,
                                      fontfamily: 'summary',
                                    ),
                                  ),
                                ],
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: controller.userDataList == null
                                    ? 0
                                    : controller.userDataList!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  NumberUserData st =
                                      controller.userDataList![index];
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, left: 10, right: 10),
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [shadow],
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child:
                                                        CustomSimpleTextField(
                                                      textSizeValue: true,
                                                      hintText:
                                                          st.userNames ?? "-",
                                                      textSize: 22,
                                                      hintColor: appColor,
                                                      fontfamily: 'Montstreat',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child:
                                                        CustomSimpleTextField(
                                                      textSizeValue: true,
                                                      hintText: st.result ?? "",
                                                      textSize: 22,
                                                      hintColor: appColor,
                                                      fontfamily: 'Montstreat',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child:
                                                        CustomSimpleTextField(
                                                      textSizeValue: true,
                                                      hintText:
                                                          st.userMoves ?? "-",
                                                      textSize: 22,
                                                      hintColor: appColor,
                                                      fontfamily: 'Montstreat',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )),
                                  );
                                },
                              ),
                            ],
                          );
                  }
                  return CircularProgressIndicator();
                },
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
