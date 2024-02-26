import 'package:flutter/material.dart';

class NumberPuzzleGame10 extends StatefulWidget {
  @override
  _NumberPuzzleGameState createState() => _NumberPuzzleGameState();
}

class _NumberPuzzleGameState extends State<NumberPuzzleGame10>
    with TickerProviderStateMixin {
  List<int> puzzleNumbers = List.generate(9, (index) => index + 1);
  late AnimationController _controller;
  bool isHandlingGesture = false;
  double initialX = 0.0;
  double initialY = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double containerHeight = MediaQuery.of(context).size.height * 0.4;

    return Scaffold(
      appBar: AppBar(
        title: Text('Number Puzzle Game'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Container(
          height: containerHeight,
          width: MediaQuery.of(context).size.width,
          color: Colors.brown,
          child: Padding(
            padding: EdgeInsets.all(18),
            child: LayoutBuilder(
              builder: (context, constraints) {
                double pieceSize = constraints.maxWidth / 3;
                return Stack(
                  children: List.generate(
                    puzzleNumbers.length ?? 0,
                        (index) {
                      return AnimatedPositioned(
                        duration: _controller.duration!,
                        top: (index ~/ 3).toDouble() * pieceSize,
                        left: (index % 3).toDouble() * pieceSize,

                        child: GestureDetector(
                          onPanStart: (details) {
                            initialX = details.globalPosition.dx;
                            initialY = details.globalPosition.dy;
                          },
                          onPanUpdate: (details) {
                            if (!isHandlingGesture &&
                                puzzleNumbers[index] != 9) {
                              isHandlingGesture = true;

                              double deltaX =
                                  details.globalPosition.dx - initialX;
                              double deltaY =
                                  details.globalPosition.dy - initialY;

                              if (deltaX.abs() > 50) {
                                // Horizontal swipe
                                moveNumber(
                                  index,
                                  deltaX > 0 ? 'left' : 'right',
                                );
                              } else if (deltaY.abs() > 50) {
                                // Vertical swipe
                                moveNumber(
                                  index,
                                  deltaY > 0 ? 'up' : 'down',
                                );
                              }

                              Future.delayed(Duration(milliseconds: 1), () {
                                isHandlingGesture = false;
                              });
                            }
                          },
                          child: Container(
                            width: pieceSize,
                            height: pieceSize,
                            color: Colors.brown,
                            child: AnimatedContainer(
                              decoration: BoxDecoration(
                                image: puzzleNumbers[index] != 9
                                    ? DecorationImage(
                                  image: AssetImage(
                                      'assets/images/w.jpg'),
                                  fit: BoxFit.fill,
                                )
                                    : null,
                              ),
                              duration: _controller.duration!,
                              child: Center(
                                child: Text(
                                  puzzleNumbers[index] != 9
                                      ? '${puzzleNumbers[index]}'
                                      : '',
                                  style: TextStyle(
                                    fontSize: pieceSize / 2,
                                    color: Colors.brown,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void moveNumber(int index, String direction) {
    if (_controller.isAnimating) {
      return;
    }

    int targetIndex = -1;

    switch (direction) {
      case 'up':
        targetIndex = index + 3;
        break;
      case 'down':
        targetIndex = index - 3;
        break;
      case 'left':
        targetIndex = index + 1;
        break;
      case 'right':
        targetIndex = index - 1;
        break;
    }

    if (targetIndex >= 0 &&
        targetIndex < puzzleNumbers.length &&
        puzzleNumbers[targetIndex] == 9) {
      setState(() {
        int temp = puzzleNumbers[index];
        puzzleNumbers[index] = puzzleNumbers[targetIndex];
        puzzleNumbers[targetIndex] = temp;
      });
      _controller.reset();
      _controller.forward();
    }
  }
}
