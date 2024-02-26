import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:KidsPlan/pages/home/controller/tictoe/select_tictoe_avtar_controller.dart';

import '../../../../color.dart';
import '../../../../custom/simpleText.dart';
import '../../../../image.dart';
import '../../../../sqlite_data/sqlite_data_store.dart';
import '../../../../string.dart';
import '../../../initial/view/select_game_screen.dart';
import '../../view/tictoe/select_tic_toe_avtar_screen.dart';

class PlayTicToeController extends GetxController
    with SingleGetTickerProviderMixin {
  @override
  String? getRoleId;
  int? giveResult;
  final AudioPlayer audioPlayer = AudioPlayer();
bool isbBlast = false;
final blastController = ConfettiController();
  final DBStudentManager dbStudentManager = new DBStudentManager();
  final _nameController = TextEditingController();
  final _courseController = TextEditingController();
  final _formkey = new GlobalKey<FormState>();
  UserData? userData;
  int? updateindex;
  String? winnerName;
  List<UserData>? userDatalist;

  String audioPath = 'audio/click.mp3';
  String? player1;
  String? player2;
  int? numSeries;
  DropdownItem? selectedItem;
  DropdownItem? selectedItem1;
  List<List<String>> board = List.generate(3, (row) => List.filled(3, ''));
  bool playerX = true; // 'X' plays first
  int player1Wins = 0;
  int player2Wins = 0;
  int totalMatch = 0;
  int totalDraws = 0;
  int winMatch = 0;
  int matchDraw = 0;
  int userMatchWin = 0;
  bool congratulationsPopupShown = false;
  int nextMatchName = 0;
  AnimationController? animationControllerBlast;
  int start = 0;
  void playAnimation() {

    animationControllerBlast!.forward(from: 0.0);

  }
  @override
  void onInit() {
    super.onInit();
    getData();
    startGame();
    animationControllerBlast = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10), // Adjust the duration as needed
    );
  }


  void playAudio() async {
    try {
      await audioPlayer.play(AssetSource(audioPath));
      print('Audio playing');
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  getData() {
    if (Get.arguments != null) {
      if (Get.arguments["numSeries"] != null &&
          Get.arguments["selectedItem"] != null &&
          Get.arguments["selectedItem1"] != null) {
        numSeries = (Get.arguments["numSeries"]);
        selectedItem = (Get.arguments["selectedItem"]);
        selectedItem1 = (Get.arguments["selectedItem1"]);
        print('kamal');
        debugPrint('$numSeries , $selectedItem , $selectedItem1');
      }
    }
  }

  int currentSetIndex = 0;
  int correctAnswers = 0;
  Timer? timer;
  int secondsElapsed = 0;
  String message = '';
  late List<Color> starColors;
  late List<AnimationController> controllers;
  bool isTimerPaused = false;

  void startGame() {
    secondsElapsed = 0;

    startTimer();
    update();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    timer!.cancel();
    // cancel the timer to avoid memory leaks
    blastController.dispose();
    super.dispose();
  }

  void stopTimer() {
    if (timer != null) {
      timer!.cancel();
    }
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!isTimerPaused) {
        secondsElapsed++;
        update();
      }
    });
  }

  String formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;

    String hoursStr = hours.toString().padLeft(2, '0');
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = remainingSeconds.toString().padLeft(2, '0');

    return '$hoursStr:$minutesStr:$secondsStr';
  }

  void togglePlayPause() {
    isTimerPaused = !isTimerPaused;
    update();

    if (isTimerPaused) {
      timer!.cancel();
      _showResumePopup();
    } else {
      startTimer();
    }
  }

  void _showResumePopup() {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(appPause),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: CustomSimpleTextField(
                      textAlign: TextAlign.center,
                      hintText: txtGameDonotResume,
                      textSize: 28,
                      hintColor: blackColor,
                      fontfamily: 'summary',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                        onTap: () {
                          playAudio();
                          Get.back();
                          togglePlayPause();
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(appbtn),
                            Center(
                              child: CustomSimpleTextField(
                                textAlign: TextAlign.center,
                                hintText: txtResume,
                                textSize: 32,
                                hintColor: Colors.white,
                                fontfamily: 'summary',
                              ),
                            ),
                          ],
                        )),
                  ),
                  GestureDetector(
                    onTap: () {
                      playAudio();
                      Get.offAll(TicToeSelectAvtarScreen());
                    },
                    child: CustomSimpleTextField(
                      hintText: txtExit,
                      textSize: 35,
                      hintColor: appRedColor,
                      fontfamily: 'summary',
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  List startList = [
    appStarLeft1,
    appStarLeft2,
    appStar1,
    appStarRight1,
    appStarRight2,
  ];

  Widget addDraw(bool draw) {
    if (draw) {
      totalDraws++;
    }
    return Text('');
  }

  checkLogic() {
    if (totalMatch == numSeries && totalDraws == numSeries) {
      if (!congratulationsPopupShown) {
        giveResult = 1;
        submitUser();
        Future.delayed(Duration(milliseconds: 1), () {
          update();
          showDrawMatchPopup();
          // Set the flag to true once the congratulations popup is shown
          congratulationsPopupShown = true;
          update();
        });
      }

      return SizedBox();
    } else if (totalMatch == numSeries) {
      if (player1Wins == (numSeries == 5 ? 2 : 1) &&
          player2Wins == (numSeries == 5 ? 2 : 1) &&
          totalDraws == 1) {
        if (!congratulationsPopupShown) {
          giveResult = 1;
          submitUser();
          Future.delayed(Duration(milliseconds: 1), () {
            update();
            showDrawMatchPopup();
            // Set the flag to true once the congratulations popup is shown
            congratulationsPopupShown = true;
            update();
          });
        }

        return SizedBox();
      } else if (player1Wins == numSeries || player2Wins == numSeries) {
        if (!congratulationsPopupShown) {
          giveResult = 0;
          submitUser();
          Future.delayed(Duration(milliseconds: 1), () {
            if (player1Wins == numSeries) {
              winnerName = selectedItem?.text;
            } else {
              winnerName = selectedItem1?.text;
            }
            update();
            showCongratulationsPopup();
            // Set the flag to true once the congratulations popup is shown
            congratulationsPopupShown = true;
            update();
          });
        }

        return SizedBox();
      } else if (player1Wins == 4 || player2Wins == 4) {
        if (!congratulationsPopupShown) {
          giveResult = 0;
          submitUser();
          Future.delayed(Duration(milliseconds: 1), () {
            if (player1Wins == 4) {
              winnerName = selectedItem?.text;
            } else {
              winnerName = selectedItem1?.text;
            }
            update();
            showCongratulationsPopup();
            // Set the flag to true once the congratulations popup is shown
            congratulationsPopupShown = true;
            update();
          });
        }

        return SizedBox();
      } else if (player1Wins == (numSeries == 5 ? 3 : 2) ||
          player2Wins == (numSeries == 5 ? 3 : 2)) {
        // Check if the congratulations popup has not been shown
        if (!congratulationsPopupShown) {
          giveResult = 0;
          submitUser();
          Future.delayed(Duration(milliseconds: 1), () {
            if (player1Wins == (numSeries == 5 ? 3 : 2)) {
              winnerName = selectedItem?.text;
            } else {
              winnerName = selectedItem1?.text;
            }
            update();
            showCongratulationsPopup();
            // Set the flag to true once the congratulations popup is shown
            congratulationsPopupShown = true;
            update();
          });
        }

        return SizedBox();
      } else if (player1Wins == (numSeries == 5 ? 2 : 1) ||
          player2Wins == (numSeries == 5 ? 2 : 1) &&
              totalDraws == (numSeries == 5 ? 3 : 2)) {
        if (!congratulationsPopupShown) {
          giveResult = 0;
          submitUser();
          Future.delayed(Duration(milliseconds: 1), () {
            if (player1Wins == (numSeries == 5 ? 2 : 1) &&
                totalDraws == (numSeries == 5 ? 3 : 2)) {
              winnerName = selectedItem?.text;
            } else {
              winnerName = selectedItem1?.text;
            }
            update();
            showCongratulationsPopup();
            // Set the flag to true once the congratulations popup is shown
            congratulationsPopupShown = true;
            update();
          });
        }

        return SizedBox();
      } else if (player1Wins == 1 && player2Wins == 1 && totalDraws == 3 ||
          player1Wins == 1 ||
          player2Wins == 1 && totalDraws == 4) {
        if (!congratulationsPopupShown) {
          giveResult = 1;
          submitUser();
          Future.delayed(Duration(milliseconds: 1), () {
            update();
            showDrawMatchPopup();
            // Set the flag to true once the congratulations popup is shown
            congratulationsPopupShown = true;
            update();
          });
        }

        return SizedBox();
      }
    } else if ((player1Wins + player2Wins) < numSeries!.toInt()) {
      return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  resetGame();
                  nextMatchName =1;
                  update();
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(appGnext, height: 50),
                    CustomSimpleTextField(
                      textSizeValue: true,
                      hintText: txtNext,
                      textSize: 30,
                      hintColor: Colors.white,
                      fontfamily: 'summary',
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.offAll(SelectGameScreen());
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(appGnext, height: 50),
                    CustomSimpleTextField(
                      textSizeValue: true,
                      hintText: txtExit,
                      textSize: 30,
                      hintColor: Colors.white,
                      fontfamily: 'summary',
                    ),
                  ],
                ),
              ),
            ],
          ));
    }
  }

  buildEndGameUI() {
    return Column(
      children: [
        CustomSimpleTextField(
          hintText: winner == 'draw'
              ? 'It\'s a draw!'
              : 'Player ${winner == 'X' ? selectedItem?.text ?? "" : selectedItem1?.text ?? ""} wins!',
          textSize: 35,
          hintColor: appColor,
          fontfamily: 'summary',
        ),

        buildResult(),
        // addDraw(winner == 'draw'),
        checkLogic()
      ],
    );
  }

  String? playerTurnName;
  String? winner;
  bool drawIncremented = false;

  Widget buildResult() {
    if (winner == 'draw' && !drawIncremented) {
      totalDraws++;
      drawIncremented = true;
      print('totalDraws');
      print(totalDraws);
      print('totalDraws');

      return Text('');
    } else {
      return Text('');
    }
  }

  void checkForWinner() {
    // Check rows
    for (int i = 0; i < 3; i++) {
      if (board[i][0] == board[i][1] &&
          board[i][1] == board[i][2] &&
          board[i][0] != '') {
        winner = board[i][0];
      }
    }

    // Check columns
    for (int i = 0; i < 3; i++) {
      if (board[0][i] == board[1][i] &&
          board[1][i] == board[2][i] &&
          board[0][i] != '') {
        winner = board[0][i];
      }
    }

    // Check diagonals
    if (board[0][0] == board[1][1] &&
        board[1][1] == board[2][2] &&
        board[0][0] != '') {
      winner = board[0][0];
    }
    if (board[0][2] == board[1][1] &&
        board[1][1] == board[2][0] &&
        board[0][2] != '') {
      winner = board[0][2];
    }

    // Check for a draw
    if (!board.any((row) => row.contains('')) && winner == null) {
      winner = 'draw';
    }

    if (winner != null) {
      if (winner == 'X') {
        totalMatch++;
        print(totalMatch);
        player1Wins++;
        update();
      } else if (winner == 'O') {
        totalMatch++;
        print(totalMatch);
        player2Wins++;
        update();
      } else {
        totalMatch++;
        print(totalMatch);
      }
    }
  }

  void resetGame() {
    drawIncremented = false;

    board = List.generate(3, (row) => List.filled(3, ''));
    winner = null;
    playerX = true;
    if (player1Wins == 1 || player2Wins == 1) {
      playerX = player1Wins ==
          1; // Set the next player based on the previous match winner
    }
    update();
  }

  showCongratulationsPopup() {
    // blastController.play();
    start=1;
    playAnimation();

    update();

    showDialog(
      barrierDismissible: false,
      context: Get.context!,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(appCongrats),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: CustomSimpleTextField(
                      textAlign: TextAlign.center,
                      hintText:
                          // 'Player ${winner == '0' ? selectedItem?.text ?? "" : selectedItem1?.text ?? ""} wins the game!',
                          'Player ${winnerName ?? ""} wins the game!',
                      textSize: 28,
                      hintColor: blackColor,
                      fontfamily: 'summary',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                        onTap: () {
                          totalMatch = 0;
                          player1Wins = 0;
                          player2Wins = 0;
                          totalDraws = 0;
                          secondsElapsed = 0;
                          nextMatchName =1;
                       start =0;
                          blastController.stop();
                          update();
                          Get.back();
                          resetGame(); // Reset the game after closing the popup
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(appbtn),
                            Center(
                              child: CustomSimpleTextField(
                                hintText: txtRestartGame,
                                textSize: 32,
                                hintColor: Colors.white,
                                fontfamily: 'summary',
                              ),
                            ),
                          ],
                        )),
                  ),
                  GestureDetector(
                    onTap: () {
                      playAudio();
                      blastController.stop();
                      Get.offAll(TicToeSelectAvtarScreen());
                    },
                    child: CustomSimpleTextField(
                      hintText: txtExit,
                      textSize: 35,
                      hintColor: appRedColor,
                      fontfamily: 'summary',
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  showDrawMatchPopup() {
    showDialog(
      barrierDismissible: false,
      context: Get.context!,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(appDraw),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: CustomSimpleTextField(
                        textAlign: TextAlign.center,
                        hintText: 'The series is drawn.',
                        textSize: 28,
                        hintColor: blackColor,
                        fontfamily: 'summary',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: GestureDetector(
                        onTap: () {
                          playAudio();
                          totalMatch = 0;
                          player1Wins = 0;
                          player2Wins = 0;
                          totalDraws = 0;
                          secondsElapsed = 0;
                          update();
                          Get.back(); // Close the popup
                          resetGame(); // Reset the game after closing the popup
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(appbtn,
                                width: MediaQuery.of(context).size.width * 0.6),
                            Center(
                              child: CustomSimpleTextField(
                                hintText: txtRestartGame,
                                textSize: 32,
                                hintColor: Colors.white,
                                fontfamily: 'summary',
                              ),
                            ),
                          ],
                        )),
                  ),
                  GestureDetector(
                    onTap: () {
                      playAudio();
                      Get.offAll(TicToeSelectAvtarScreen());
                    },
                    child: CustomSimpleTextField(
                      hintText: txtExit,
                      textSize: 35,
                      hintColor: appRedColor,
                      fontfamily: 'summary',
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  @override
  void onReady() {
    super.onReady();
  }

  void submitUser() {
    if (userData == null) {
      UserData st = new UserData(
          userNames: '${selectedItem?.text} vs ${selectedItem1?.text}',
          result: winner == 'draw'
              ? 'Draw'
              : '${winner == 'X' ? selectedItem?.text ?? "" : selectedItem1?.text ?? ""}'
          // giveResult == 0 ? 'Winner' : 'Loser'
          );
      dbStudentManager.insertStudent(st).then((value) => {
            _nameController.clear(),
            _courseController.clear(),
            print("User Data Add to database $value"),
          });
    } else {
      userData!.userNames = _nameController.text;
      userData!.result = _courseController.text;
    }
  }
}
