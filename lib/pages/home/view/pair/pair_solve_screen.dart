import 'package:KidsPlan/color.dart';
import 'package:KidsPlan/custom/simpleText.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../../image.dart';
import '../../controller/pair/pair_solve_controller.dart';

class PairSolveScreen extends GetView<PairSolveController> {
  @override
  Widget build(BuildContext context) {
    Get.put(PairSolveController());
    return WillPopScope(
      onWillPop: () async {
        controller.togglePlayPause();
        return true;
        // return false;
      },
      child: GetBuilder<PairSolveController>(
          init: PairSolveController(),
          builder: (context) {
            GestureDetector gestureDetector = GestureDetector(
              onPanStart: (details) {
                controller.start = details.localPosition;
                controller.end = null;
                controller.update();
              },
              onPanUpdate: (details) {
                controller.end = details.localPosition;
                controller.update();
              },
              child: CustomPaint(
                size: Size.infinite,
                painter: controller.start != null && controller.end != null
                    ? LinePainter(controller.start!, controller.end!)
                    : null,
              ),
            );
            return Scaffold(body: _bodyWidget(controller, gestureDetector));
          }),
    );
  }
}

_bodyWidget(PairSolveController controller, GestureDetector gestureDetector) {
  return Stack(
    // alignment: Alignment.topLeft,
    children: [
      Image.asset(
        appselectbg,
        fit: BoxFit.cover,
      ),
      SafeArea(
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
                            child: Text(
                              controller.formatTime(controller.secondsElapsed),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
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
      controller.startBlast == 1
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
          : Text(''),
      // ConfettiWidget(
      //   confettiController: controller.blastController,
      //   shouldLoop: true,
      //   blastDirectionality: BlastDirectionality.explosive,
      //   maxBlastForce: 100,
      //   numberOfParticles: 50,
      // ),
      Padding(
        padding: const EdgeInsets.only(top: 100.0, left: 5, right: 5),
        child: controller.getRoleId == '1'
            ? Builder(
                builder: (context) {
                  controller.appBarSize = Scaffold.of(context).appBarMaxHeight;
                  return Center(
                    child: Stack(
                      children: [
                        IgnorePointer(
                          child: gestureDetector,
                        ),
                        Row(
                          children: [
                            Column(
                              children: controller.itemList!
                                  .map(
                                    (e) => Listener(
                                      onPointerMove: (event) {
                                        gestureDetector.onPanUpdate
                                            ?.call(DragUpdateDetails(
                                          delta: Offset.zero,
                                          globalPosition: event.position,
                                          localPosition: Offset(
                                            event.position.dx,
                                            event.position.dy -
                                                //controller.appBarSize
                                                controller
                                                    .getAppBarOffset(context),
                                          ),
                                        ));
                                      },
                                      child: Draggable<ItemModel>(
                                        onDragEnd: (e) {
                                          controller.start = Offset.zero;
                                          controller.end = Offset.zero;
                                          controller.update();
                                        },
                                        onDragStarted: () {
                                          RenderBox render = e
                                              .key.currentContext!
                                              .findRenderObject() as RenderBox;
                                          Offset centerWidget = Offset(
                                            render.size.width / 2,
                                            render.size.height / 2 -
                                                //controller.appBarSize
                                                controller
                                                    .getAppBarOffset(context),
                                            // 200
                                            // (appBarSize ?? 0.0),
                                          );
                                          gestureDetector.onPanStart!(
                                            DragStartDetails(
                                              localPosition:
                                                  render.localToGlobal(
                                                centerWidget,
                                              ),
                                            ),
                                          );
                                        },
                                        data: e,
                                        child: Padding(
                                          key: e.key,
                                          padding: const EdgeInsets.all(20.0),
                                          child: CustomSimpleTextField(
                                            hintText: e.name,
                                            textSize: 35,
                                            hintColor: appPinkColor,
                                            fontfamily: 'summary',
                                          ),
                                        ),
                                        feedback: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: CustomSimpleTextField(
                                            hintText: e.name,
                                            textSize: 20,
                                            hintColor: appPinkColor,
                                            fontfamily: 'summary',
                                          ),
                                          // Text(
                                          //   e.name,
                                          //   style: TextStyle(fontSize: 24),
                                          // ),
                                        ),
                                        childWhenDragging: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: CustomSimpleTextField(
                                            hintText: e.name,
                                            textSize: 35,
                                            hintColor: appPinkColor,
                                            fontfamily: 'summary',
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                            Spacer(),
                            Column(
                              children: controller.itemList2!
                                  .map(
                                    (e) => DragTarget<ItemModel>(
                                      onWillAccept: (data) => true,
                                      onAccept: (data) {
                                        if (data.name == e.name &&
                                            !controller.matchedPairs
                                                .containsKey(data)) {
                                          controller.matchedPairs[data] = e;
                                          controller.drawnLines.add(
                                              LinePainterWidget(
                                                  controller.start!,
                                                  controller.end!));
                                          controller.score++;
                                          print(controller.score);
                                          if (controller.score == 10) {
                                            controller.checkResult();
                                            // controller.showCongratulationsPopup();
                                          }

                                          if (controller.matchedPairs.length ==
                                              controller.itemList!.length) {
                                            // All items matched, change the names and clear lines
                                            controller.loadNextSetOfItems();

                                            // Reset the score if needed
                                            // score = 0;

                                            // Optionally show a message to indicate the change
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                backgroundColor: appColor,
                                                content: CustomSimpleTextField(
                                                  textSizeValue: true,
                                                  hintText:
                                                      'Next set of items loaded!',
                                                  textSize: 18,
                                                  hintColor: Colors.white,
                                                  fontfamily: 'Monstreat',
                                                ),
                                              ),
                                            );
                                          }
                                          controller.update();
                                        }
                                      },
                                      builder:
                                          (context, onAccepted, onRejected) {
                                        return Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Container(
                                            width: 100,
                                            height: 59,
                                            color: e.color,
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        ),
                        ...controller.drawnLines,
                      ],
                    ),
                  );
                },
              )
            : controller.getRoleId == '3'
                ? Builder(
                    builder: (context) {
                      controller.appBarSize =
                          Scaffold.of(context).appBarMaxHeight;
                      return Stack(
                        children: [
                          IgnorePointer(
                            child: gestureDetector,
                          ),
                          Row(
                            children: [
                              Column(
                                children: controller.itemListSymbol!
                                    .map(
                                      (e) => Listener(
                                        onPointerMove: (event) {
                                          gestureDetector.onPanUpdate
                                              ?.call(DragUpdateDetails(
                                            delta: Offset.zero,
                                            globalPosition: event.position,
                                            localPosition: Offset(
                                              event.position.dx,
                                              event.position.dy -
                                                  //controller.appBarSize
                                                  controller
                                                      .getAppBarOffset(context),
                                            ),
                                          ));
                                        },
                                        child: Draggable<ItemModel1>(
                                          onDragEnd: (e) {
                                            controller.start = Offset.zero;
                                            controller.end = Offset.zero;
                                            controller.update();
                                          },
                                          onDragStarted: () {
                                            RenderBox render = e
                                                    .key.currentContext!
                                                    .findRenderObject()
                                                as RenderBox;
                                            Offset centerWidget = Offset(
                                              render.size.width / 2,
                                              render.size.height / 2 -
                                                  //controller.appBarSize
                                                  controller
                                                      .getAppBarOffset(context),
                                              // 200
                                              // (appBarSize ?? 0.0),
                                            );
                                            gestureDetector.onPanStart!(
                                              DragStartDetails(
                                                localPosition:
                                                    render.localToGlobal(
                                                  centerWidget,
                                                ),
                                              ),
                                            );
                                          },
                                          data: e,
                                          feedback: Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: CustomSimpleTextField(
                                              hintText: e.name,
                                              textSize: 20,
                                              hintColor: appPinkColor,
                                              fontfamily: 'summary',
                                            ),
                                          ),
                                          childWhenDragging: Padding(
                                            padding: const EdgeInsets.all(22.0),
                                            child: CustomSimpleTextField(
                                              hintText: e.name,
                                              textSize: 32,
                                              hintColor: appPinkColor,
                                              fontfamily: 'summary',
                                            ),
                                          ),
                                          child: Padding(
                                            key: e.key,
                                            padding: const EdgeInsets.all(22.0),
                                            child: CustomSimpleTextField(
                                              hintText: e.name,
                                              textSize: 32,
                                              hintColor: appPinkColor,
                                              fontfamily: 'summary',
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                              Spacer(),
                              Column(
                                children: controller.itemListSymbol2!
                                    .map(
                                      (e) => DragTarget<ItemModel1>(
                                        onWillAccept: (data) => true,
                                        onAccept: (data) {
                                          if (data.name == e.name &&
                                              !controller.matchedPairsSymbol
                                                  .containsKey(data)) {
                                            controller
                                                .matchedPairsSymbol[data] = e;
                                            controller.drawnLines.add(
                                                LinePainterWidget(
                                                    controller.start!,
                                                    controller.end!));
                                            controller.score++;
                                            print(controller.score);
                                            if (controller.score == 10) {
                                              controller.checkResult();
                                              // controller.showCongratulationsPopup();
                                            }

                                            if (controller.matchedPairsSymbol
                                                    .length ==
                                                controller
                                                    .itemListSymbol!.length) {
                                              // All items matched, change the names and clear lines
                                              controller
                                                  .loadNextSetOfItemsSymbol();

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  backgroundColor: appColor,
                                                  content:
                                                      CustomSimpleTextField(
                                                    textSizeValue: true,
                                                    hintText:
                                                        'Next set of items loaded!',
                                                    textSize: 18,
                                                    hintColor: Colors.white,
                                                    fontfamily: 'Monstreat',
                                                  ),
                                                ),
                                              );
                                            }
                                            controller.update();
                                          }
                                        },
                                        builder:
                                            (context, onAccepted, onRejected) {
                                          return Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Container(
                                              width: 50,
                                              height: 60,
                                              child: Image.asset(e.matchImage),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],
                          ),
                          ...controller.drawnLines,
                        ],
                      );
                    },
                  )
                : Builder(
                    builder: (context) {
                      controller.appBarSize =
                          Scaffold.of(context).appBarMaxHeight;
                      return Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15.0),
                        child: Center(
                          child: Stack(
                            children: [
                              IgnorePointer(
                                child: gestureDetector,
                              ),
                              Row(
                                children: [
                                  Column(
                                    children: controller.itemListAlpahbet!
                                        .map(
                                          (e) => Listener(
                                            onPointerMove: (event) {
                                              gestureDetector.onPanUpdate
                                                  ?.call(DragUpdateDetails(
                                                delta: Offset.zero,
                                                globalPosition: event.position,
                                                localPosition: Offset(
                                                  event.position.dx,
                                                  event.position.dy -
                                                      //controller.appBarSize
                                                      controller
                                                          .getAppBarOffset(
                                                              context),
                                                ),
                                              ));
                                            },
                                            child: Draggable<ItemModel1>(
                                              onDragEnd: (e) {
                                                controller.start = Offset.zero;
                                                controller.end = Offset.zero;
                                                controller.update();
                                              },
                                              onDragStarted: () {
                                                RenderBox render = e
                                                        .key.currentContext!
                                                        .findRenderObject()
                                                    as RenderBox;
                                                Offset centerWidget = Offset(
                                                  render.size.width / 2,
                                                  render.size.height / 2 -
                                                      //controller.appBarSize
                                                      controller
                                                          .getAppBarOffset(
                                                              context),
                                                  // 200
                                                  // (appBarSize ?? 0.0),
                                                );
                                                gestureDetector.onPanStart!(
                                                  DragStartDetails(
                                                    localPosition:
                                                        render.localToGlobal(
                                                      centerWidget,
                                                    ),
                                                  ),
                                                );
                                              },
                                              data: e,
                                              feedback: Padding(
                                                padding:
                                                    const EdgeInsets.all(20.0),
                                                child: CustomSimpleTextField(
                                                  hintText: e.name,
                                                  textSize: 30,
                                                  hintColor: appPinkColor,
                                                  fontfamily: 'summary',
                                                ),
                                              ),
                                              childWhenDragging: Padding(
                                                  padding: const EdgeInsets.all(
                                                      20.0),
                                                  child: e.name == 'O'
                                                      ? Image.asset(
                                                          appo,
                                                          height: 50,
                                                        )
                                                      : e.name == 'P'
                                                          ? Image.asset(
                                                              appp,
                                                              height: 50,
                                                            )
                                                          : e.name == 'D'
                                                              ? Image.asset(
                                                                  appd,
                                                                  height: 50,
                                                                )
                                                              : e.name == 'E'
                                                                  ? Image.asset(
                                                                      appe,
                                                                      height:
                                                                          50,
                                                                    )
                                                                  : e.name ==
                                                                          'V'
                                                                      ? Image
                                                                          .asset(
                                                                          appv,
                                                                          height:
                                                                              50,
                                                                        )
                                                                      : e.name ==
                                                                              'H'
                                                                          ? Image
                                                                              .asset(
                                                                              apph,
                                                                              height: 50,
                                                                            )
                                                                          : e.name == 'A'
                                                                              ? Image.asset(
                                                                                  appa,
                                                                                  height: 50,
                                                                                )
                                                                              : e.name == 'M'
                                                                                  ? Image.asset(
                                                                                      appm,
                                                                                      height: 50,
                                                                                    )
                                                                                  : e.name == 'L'
                                                                                      ? Image.asset(
                                                                                          appl,
                                                                                          height: 50,
                                                                                        )
                                                                                      : Image.asset(
                                                                                          appb,
                                                                                          height: 50,
                                                                                        )),
                                              child: Padding(
                                                  key: e.key,
                                                  padding: const EdgeInsets.all(
                                                      20.0),
                                                  child: e.name == 'O'
                                                      ? Image.asset(
                                                          appo,
                                                          height: 50,
                                                        )
                                                      : e.name == 'P'
                                                          ? Image.asset(
                                                              appp,
                                                              height: 50,
                                                            )
                                                          : e.name == 'D'
                                                              ? Image.asset(
                                                                  appd,
                                                                  height: 50,
                                                                )
                                                              : e.name == 'E'
                                                                  ? Image.asset(
                                                                      appe,
                                                                      height:
                                                                          50,
                                                                    )
                                                                  : e.name ==
                                                                          'V'
                                                                      ? Image
                                                                          .asset(
                                                                          appv,
                                                                          height:
                                                                              50,
                                                                        )
                                                                      : e.name ==
                                                                              'H'
                                                                          ? Image
                                                                              .asset(
                                                                              apph,
                                                                              height: 50,
                                                                            )
                                                                          : e.name == 'A'
                                                                              ? Image.asset(
                                                                                  appa,
                                                                                  height: 50,
                                                                                )
                                                                              : e.name == 'M'
                                                                                  ? Image.asset(
                                                                                      appm,
                                                                                      height: 50,
                                                                                    )
                                                                                  : e.name == 'L'
                                                                                      ? Image.asset(
                                                                                          appl,
                                                                                          height: 50,
                                                                                        )
                                                                                      : Image.asset(
                                                                                          appb,
                                                                                          height: 50,
                                                                                        )),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                  Spacer(),
                                  Column(
                                    children: controller.itemListAlpahbet2!
                                        .map(
                                          (e) => DragTarget<ItemModel1>(
                                            onWillAccept: (data) => true,
                                            onAccept: (data) {
                                              if (data.name == e.name &&
                                                  !controller
                                                      .matchedPairsAlpahbet
                                                      .containsKey(data)) {
                                                controller.matchedPairsAlpahbet[
                                                    data] = e;
                                                controller.drawnLines.add(
                                                    LinePainterWidget(
                                                        controller.start!,
                                                        controller.end!));
                                                controller.score++;
                                                print(controller.score);
                                                if (controller.score == 10) {
                                                  controller.checkResult();
                                                  // controller.showCongratulationsPopup();
                                                }

                                                if (controller
                                                        .matchedPairsAlpahbet
                                                        .length ==
                                                    controller.itemListAlpahbet!
                                                        .length) {
                                                  // All items matched, change the names and clear lines
                                                  controller
                                                      .loadNextSetOfItemsAlphabet();
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      backgroundColor: appColor,
                                                      content:
                                                          CustomSimpleTextField(
                                                        textSizeValue: true,
                                                        hintText:
                                                            'Next set of items loaded!',
                                                        textSize: 18,
                                                        hintColor: Colors.white,
                                                        fontfamily: 'Monstreat',
                                                      ),
                                                    ),
                                                  );
                                                }
                                                controller.update();
                                              }
                                            },
                                            builder: (context, onAccepted,
                                                onRejected) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  width: 100,
                                                  height: 73,
                                                  child:
                                                      Image.asset(e.matchImage),
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ],
                              ),
                              ...controller.drawnLines,
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    ],
  );
}

bool hasDecimal(double number) {
  // Check if the number has a decimal part
  return number % 1 != 0;
}

showDialogBox(PairSolveController controller) {
  return showDialog<void>(
    context: Get.context!,
    builder: (BuildContext context) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(apphow),
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
                    hintText: "We need to match the things in one block "
                        "with the things in another block.",
                    hintColor: blackColor,
                    textSize: MediaQuery.of(Get.context!).size.width * 0.04,
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
                        width: MediaQuery.of(context).size.width * 0.6,
                      ),
                      Center(
                        child: CustomSimpleTextField(
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
