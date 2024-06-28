import 'package:KidsPlan/pages/home/view/word/word_option_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../color.dart';
import '../../../../custom/simpleText.dart';
import '../../../../image.dart';
import '../../../../sqlite_data/word_game_data.dart';
import '../../controller/word/word_history_controller.dart';

class WordHistoryScreen extends GetView<WordHistoryController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<WordHistoryController>(
        init: WordHistoryController(),
        builder: (context) {
          return Scaffold(
              body: SingleChildScrollView(child: _bodyWidget(controller)));
        });
  }
}

_bodyWidget(WordHistoryController controller) {
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
                          Get.to(WordOptionListScreen());
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
                future: controller.dbWordManager.getStudentList(),
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
                                      hintText: 'Category',
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
                                  // Padding(
                                  //   padding: const EdgeInsets.only(top: 10.0),
                                  //   child: CustomSimpleTextField(
                                  //     textSizeValue: true,
                                  //     hintText: 'Moves',
                                  //     textSize: 24,
                                  //     hintColor: blackColor,
                                  //     fontfamily: 'summary',
                                  //   ),
                                  // ),
                                ],
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: controller.userDataList == null
                                    ? 0
                                    : controller.userDataList!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  WordUserData st =
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
                                              // Column(
                                              //   children: [
                                              //     Padding(
                                              //       padding:
                                              //           const EdgeInsets.all(
                                              //               8.0),
                                              //       child:
                                              //           CustomSimpleTextField(
                                              //         textSizeValue: true,
                                              //         hintText:
                                              //             st.userMoves ?? "-",
                                              //         textSize: 22,
                                              //         hintColor: appColor,
                                              //         fontfamily: 'Montstreat',
                                              //       ),
                                              //     ),
                                              //   ],
                                              // ),
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
