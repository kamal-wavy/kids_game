import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:KidsPlan/sqlite_data/sqlite_data_store.dart';

import '../../../../color.dart';
import '../../../../custom/simpleText.dart';
import '../../../../image.dart';
import '../../../../routes/app_routes.dart';
import '../../controller/tictoe/history_controller.dart';

class HistoryPlayTicToeScreen extends GetView<HistoryTicToeController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HistoryTicToeController>(
        init: HistoryTicToeController(),
        builder: (context) {
          return Scaffold(
              body: SingleChildScrollView(child: _bodyWidget(controller)));
        });
  }
}

_bodyWidget(HistoryTicToeController controller) {
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
                  child: CustomSimpleTextField(
                    textSizeValue: true,
                    hintText: 'History',
                    textSize: 30,
                    hintColor: appColor,
                    fontfamily: 'summary',
                  ),
                ),
                SizedBox(
                  width: 30,
                )
              ],
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
                                  CustomSimpleTextField(
                                    textSizeValue: true,
                                    hintText: 'Match',
                                    textSize: 25,
                                    hintColor: blackColor,
                                    fontfamily: 'summary',
                                  ),
                                  SizedBox(
                                    width: 40,
                                  ),
                                  CustomSimpleTextField(
                                    textSizeValue: true,
                                    hintText: 'Result',
                                    textSize: 25,
                                    hintColor: blackColor,
                                    fontfamily: 'summary',
                                  ),
                                ],
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: controller.userDataList == null
                                    ? 0
                                    : controller.userDataList!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  UserData st = controller.userDataList![index];

                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 15, top: 10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [shadow],
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              children: [
                                                CustomSimpleTextField(
                                                  textSizeValue: true,
                                                  hintText: st.userNames ?? "",
                                                  textSize: 20,
                                                  hintColor: appColor,
                                                  fontfamily: 'summary',
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                CustomSimpleTextField(
                                                  textSizeValue: true,
                                                  hintText: st.result ?? "",
                                                  textSize: 20,
                                                  hintColor: appColor,
                                                  fontfamily: 'summary',
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
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
