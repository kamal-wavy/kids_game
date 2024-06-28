import 'package:KidsPlan/pages/home/controller/memory/memory_game_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../../color.dart';
import '../../../../custom/simpleText.dart';
import '../../../../image.dart';

class MemoryGameSolve extends GetView<MemoryGameSolveController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MemoryGameSolveController>(
      init: MemoryGameSolveController(),
      builder: (context) {
        return Scaffold(
          body: _bodyWidget(controller),
        );
      },
    );
  }
}

Widget _bodyWidget(MemoryGameSolveController controller) {
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
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                        onTap: () {
                          controller.playAudio();
                          controller.togglePlayPause();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.pink,
                              borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Icon(
                              controller.isTimerPaused
                                  ? Icons.play_arrow
                                  : Icons.pause,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        )),
                    Container(
                      width: 150,
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          Positioned(
                            left: 50,
                            // Adjust the distance between the circle and text
                            child: Container(
                              width: 100,
                              margin: EdgeInsets.zero,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                                color: Colors.pink,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Center(
                                    child: CustomSimpleTextField(
                                  textSizeValue: true,
                                  hintText: controller
                                      .formatTime(controller.secondsElapsed),
                                  hintColor: Colors.white,
                                  textSize: 15,
                                  fontfamily: 'Montstreat',
                                )),
                              ),
                            ),
                          ),
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.amber,
                            backgroundImage: AssetImage(appalarm),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          controller.playAudio();
                          showDialogBox(controller);
                        },
                        child: Image.asset(appTips)),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Padding(
                  padding:
                      const EdgeInsets.only(top: 30.0, left: 15, right: 15),
                  child:
                      //flipCardNumber
                      controller.getRoleId == '1'
                          ? GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                              ),
                              itemCount: controller.game.cards.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      _onCardTap(controller, index);
                                    },
                                    child: AnimatedSwitcher(
                                      duration: Duration(milliseconds: 500),
                                      transitionBuilder: (Widget child,
                                          Animation<double> animation) {
                                        return RotationTransition(
                                          turns: animation,
                                          child: child,
                                        );
                                      },
                                      child: controller.game.cards[index]
                                                  .isFlipped ||
                                              controller
                                                  .game.cards[index].isMatched
                                          ? RotationTransition(
                                              turns: AlwaysStoppedAnimation(
                                                  controller.game.cards[index]
                                                          .isFlipped
                                                      ? 1
                                                      : 0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          'assets/animal/d2.png')),
                                                  color: controller
                                                          .game
                                                          .cards[index]
                                                          .isMatched
                                                      ? Colors.grey
                                                      : Colors.blue,
                                                ),
                                                key: ValueKey<int>(controller
                                                    .game.cards[index].id),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  controller
                                                      .game.cards[index].id
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                      fontSize: 40,
                                                      fontFamily: 'Montstreat'),
                                                ),
                                              ),
                                            )
                                          : Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        'assets/animal/d1.png')),
                                                color: Colors.red,
                                              ),
                                              key: ValueKey<int>(-controller
                                                  .game.cards[index].id),
                                              alignment: Alignment.center,
                                              child: Text(
                                                '',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                    ),
                                  ),
                                );
                              },
                            )
                          : controller.getRoleId == '2'
                              ? GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                  ),
                                  itemCount:
                                      controller.gameImage.cardsImage.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          _onCardTap(controller, index);
                                        },
                                        child: AnimatedSwitcher(
                                          duration: Duration(milliseconds: 500),
                                          transitionBuilder: (Widget child,
                                              Animation<double> animation) {
                                            return RotationTransition(
                                              turns: animation,
                                              child: child,
                                            );
                                          },
                                          child: controller
                                                      .gameImage
                                                      .cardsImage[index]
                                                      .isFlipped ||
                                                  controller
                                                      .gameImage
                                                      .cardsImage[index]
                                                      .isMatched
                                              ? RotationTransition(
                                                  turns: AlwaysStoppedAnimation(
                                                      controller
                                                              .gameImage
                                                              .cardsImage[index]
                                                              .isFlipped
                                                          ? 1
                                                          : 0),
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        image: DecorationImage(
                                                            image: AssetImage(
                                                                'assets/animal/d2.png')),
                                                        color: controller
                                                                .gameImage
                                                                .cardsImage[
                                                                    index]
                                                                .isMatched
                                                            ? Colors.grey
                                                            : Colors.blue,
                                                      ),
                                                      key: ValueKey<int>(
                                                          controller
                                                              .gameImage
                                                              .cardsImage[index]
                                                              .id),
                                                      alignment:
                                                          Alignment.center,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(2.0),
                                                        child: Image.asset(
                                                            controller
                                                                .gameImage
                                                                .cardsImage[
                                                                    index]
                                                                .imageName),
                                                      )
                                                      // Text(controller
                                                      //     .gameImage.cardsImage[index].id
                                                      //     .toString()),
                                                      ),
                                                )
                                              : Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    image: DecorationImage(
                                                        image: AssetImage(
                                                            'assets/animal/d1.png')),
                                                    color: Colors.red,
                                                  ),
                                                  key: ValueKey<int>(-controller
                                                      .gameImage
                                                      .cardsImage[index]
                                                      .id),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    '',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                  ),
                                  itemCount:
                                      controller.gameImage.cardsImage.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          _onCardTap(controller, index);
                                        },
                                        child: AnimatedSwitcher(
                                          duration: Duration(milliseconds: 500),
                                          transitionBuilder: (Widget child,
                                              Animation<double> animation) {
                                            return RotationTransition(
                                              turns: animation,
                                              child: child,
                                            );
                                          },
                                          child: controller
                                                      .gameImage
                                                      .cardsImage[index]
                                                      .isFlipped ||
                                                  controller
                                                      .gameImage
                                                      .cardsImage[index]
                                                      .isMatched
                                              ? RotationTransition(
                                                  turns: AlwaysStoppedAnimation(
                                                      controller
                                                              .gameImage
                                                              .cardsImage[index]
                                                              .isFlipped
                                                          ? 1
                                                          : 0),
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        image: DecorationImage(
                                                            image: AssetImage(
                                                                'assets/animal/d2.png')),
                                                        color: controller
                                                                .gameImage
                                                                .cardsImage[
                                                                    index]
                                                                .isMatched
                                                            ? Colors.grey
                                                            : Colors.blue,
                                                      ),
                                                      key: ValueKey<int>(
                                                          controller
                                                              .gameImage
                                                              .cardsImage[index]
                                                              .id),
                                                      alignment:
                                                          Alignment.center,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Image.asset(
                                                            controller
                                                                .gameImage
                                                                .cardsImage[
                                                                    index]
                                                                .imageName),
                                                      )
                                                      // Text(controller
                                                      //     .gameImage.cardsImage[index].id
                                                      //     .toString()),
                                                      ),
                                                )
                                              : Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    image: DecorationImage(
                                                        image: AssetImage(
                                                            'assets/animal/d1.png')),
                                                    color: Colors.red,
                                                  ),
                                                  key: ValueKey<int>(-controller
                                                      .gameImage
                                                      .cardsImage[index]
                                                      .id),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    '',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ),
                                        ),
                                      ),
                                    );
                                  },
                                )),
            ),
            Expanded(
              flex: 3,
              child: CustomSimpleTextField(
                hintText: 'Moves: ${controller.score.toString() ?? ""}',
                textSize: 25,
                hintColor: appColor,
                fontfamily: 'Montstreat',
              ),
            )
          ],
        ),
      ),
      controller.start == 1
          ? Lottie.asset(
              fit: BoxFit.fitHeight,
//repeat: true,
              'assets/s.json',
              // animate: true,
              controller: controller.animationControllerBlast,
              // Use animationController here
              onLoaded: (composition) {
                controller.animationControllerBlast!.duration =
                    composition.duration;
              },
            )
          : Text('')
    ],
  );
}

void _onCardTap(MemoryGameSolveController controller, int index) {
  if (controller.getRoleId == '1') {
    if (!controller.game.cards[index].isMatched) {
      controller.flipCardNumber(index);
      controller.update();
      Future.delayed(Duration(milliseconds: 1), () {
        if (!controller.game.isMatched) {
          controller.flipCardNumber(index);
          controller.update();
        }
      });
    }
  } else if (controller.getRoleId == '2' || controller.getRoleId == '3') {
    if (!controller.gameImage.cardsImage[index].isMatched) {
      controller.flipCard(index);
      controller.update();
      Future.delayed(Duration(milliseconds: 100), () {
        if (!controller.gameImage.isMatched) {
          controller.flipCard(index);
          controller.update();
        }
      });
    }
  }
}

showDialogBox(MemoryGameSolveController controller) {
  return showDialog<void>(
    context: Get.context!,
    builder: (BuildContext context) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(apphow, height: MediaQuery.of(context).size.width * 0.9),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(Get.context!).size.height * 0.01),
                child: SizedBox(
                  width: MediaQuery.of(Get.context!).size.width * 0.6,
                  // height: MediaQuery.of(Get.context!).size.height * 0.2,
                  child: CustomSimpleTextField(
                    textAlign: TextAlign.center,
                    hintText: "In this matching game where each box has a pair;"
                        " upon matching, move to the next pair, and continue until"
                        " all pairs are matched for the result.",
                    textSize: MediaQuery.of(Get.context!).size.width * 0.04,
                    hintColor: blackColor,
                    fontfamily: 'Monstreat',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    controller.playAudio();
                    Get.back();
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        appbtn,
                        width: MediaQuery.of(context).size.width * 0.5,
                      ),
                      Center(
                        child: CustomSimpleTextField(
                          textSizeValue: true,
                          underLineValue: false,
                          textAlign: TextAlign.center,
                          hintText: 'OKAY!!',
                          textSize:
                              MediaQuery.of(Get.context!).size.width * 0.06,
                          hintColor: Colors.white,
                          fontfamily: 'summary',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      );
    },
  );
}
