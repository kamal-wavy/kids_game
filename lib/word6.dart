import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_search_safety/word_search_safety.dart';

class CrosswordWidget6 extends StatefulWidget {
  CrosswordWidget6({Key? key}) : super(key: key);

  @override
  _CrosswordWidgetState createState() => _CrosswordWidgetState();
}

class _CrosswordWidgetState extends State<CrosswordWidget6> {
  int numBoxPerRow = 6;
  double padding = 5;
  Size sizeBox = Size.zero;
  int? getNumBoxGrid;

  late ValueNotifier<List<List<String>>> listChars;
  late ValueNotifier<List<CrosswordAnswer>> answerList;
  late ValueNotifier<CurrentDragObj> currentDragObj;
  late ValueNotifier<List<int>> charsDone;

  @override
  void initState() {
    super.initState();
    getData();
    listChars = ValueNotifier<List<List<String>>>([]);
    answerList = ValueNotifier<List<CrosswordAnswer>>([]);
    currentDragObj = ValueNotifier<CurrentDragObj>(CurrentDragObj());
    charsDone = ValueNotifier<List<int>>([]);
    generateRandomWord();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text('Crossword Puzzle'),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              alignment: Alignment.center,
              width: double.maxFinite,
              height: size.width - padding * 2,
              padding: EdgeInsets.all(padding),
              margin: EdgeInsets.all(padding),
              child: drawCrosswordBox(),
            ),
            Container(
              alignment: Alignment.center,
              child: drawAnswerList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget drawCrosswordBox() {
    return Listener(
      onPointerUp: (event) {
        onDragEnd(event);
      },
      onPointerMove: (event) {
        onDragUpdate(event);
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          sizeBox = Size(constraints.maxWidth, constraints.maxWidth);
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 1,
              crossAxisCount: numBoxPerRow,
              crossAxisSpacing: padding,
              mainAxisSpacing: padding,
            ),
            itemCount: numBoxPerRow * numBoxPerRow,
            itemBuilder: (context, index) {
              String char = listChars.value.expand((e) => e).toList()[index];
              return Listener(
                onPointerDown: (event) {
                  onDragStart(index);
                },
                child: ValueListenableBuilder(
                  valueListenable: currentDragObj,
                  builder: (context, CurrentDragObj value, child) {
                    Color color = Colors.blue;
                    if (value.currentDragLine.contains(index))
                      color = Colors.yellow;
                    else if (charsDone.value.contains(index))
                      color = Colors.red;
                    return Container(
                      decoration: BoxDecoration(
                        color: color,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        char.toUpperCase(),
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  List<String> generateRandomWords() {
    final allWords = nouns.take(100).toList();
    allWords.shuffle();
    return allWords.where((word) => word.length <= 5).take(6).toList();
  }

  void generateRandomWord() {
    final List<String> wl = generateRandomWords();

    // Set the grid size to 6x6
    numBoxPerRow = getNumBoxGrid!;
    // numBoxPerRow = 8;

    final WSSettings ws = WSSettings(
      width: numBoxPerRow,
      height: numBoxPerRow,
      orientations: [
        WSOrientation.horizontal,
        WSOrientation.vertical,
      ],
    );

    final WordSearchSafety wordSearch = WordSearchSafety();
    final WSNewPuzzle? newPuzzle = wordSearch.newPuzzle(wl, ws);

    if (newPuzzle != null && newPuzzle.errors!.isEmpty) {
      final puzzle = newPuzzle.puzzle!;
      listChars.value = puzzle;
      final WSSolved solved = wordSearch.solvePuzzle(puzzle, wl);
      answerList.value = solved.found!
          .map((solve) => new CrosswordAnswer(solve, numPerRow: numBoxPerRow))
          .toList();
    } else {
      if (newPuzzle == null) {
        print("Error: Puzzle couldn't be generated.");
      } else {
        newPuzzle.errors!.forEach((error) {
          print(error);
        });
      }
    }
  }

  Widget drawAnswerList() {
    return ValueListenableBuilder(
      valueListenable: answerList,
      builder: (context, List<CrosswordAnswer> value, child) {
        int perColTotal = 3;
        List<Widget> list = List.generate(
          (value.length ~/ perColTotal) +
              ((value.length % perColTotal) > 0 ? 1 : 0),
          (int index) {
            int maxColumn = (index + 1) * perColTotal;

            return Container(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  maxColumn > value.length
                      ? maxColumn - value.length
                      : perColTotal,
                  (indexChild) {
                    int indexArray = (index) * perColTotal + indexChild;

                    return Text(
                      "${value[indexArray].wsLocation.word}",
                      style: TextStyle(
                        fontSize: 18,
                        color: value[indexArray].done
                            ? Colors.green
                            : Colors.black,
                        decoration: value[indexArray].done
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    );
                  },
                ).toList(),
              ),
            );
          },
        ).toList();

        return Column(
          children: list,
        );
      },
    );
  }

  void onDragEnd(PointerUpEvent? event) {
    if (currentDragObj.value.currentDragLine.isEmpty) return;
    currentDragObj.value.currentDragLine.clear();
    currentDragObj.notifyListeners();

    // Check if all words are found
    if (answerList.value.every((answer) => answer.done)) {
      resetGame();
    }
  }

  void resetGame() {
    setState(() {
      charsDone.value.clear();
      charsDone.notifyListeners();
      currentDragObj.value = CurrentDragObj();
      currentDragObj.notifyListeners();
      generateRandomWord();
    });
  }

  void onDragUpdate(PointerMoveEvent event) {
    generateLineOnDrag(event);

    int indexFound = answerList.value.indexWhere((answer) {
      // return answer
      return answer.answerLines.join("-") ==
          currentDragObj.value.currentDragLine.join("-");
    });

    if (indexFound >= 0) {
      answerList.value[indexFound].done = true;
      charsDone.value.addAll(answerList.value[indexFound].answerLines);
      charsDone.notifyListeners();
      answerList.notifyListeners();
      onDragEnd(null);
    }
  }

  int calculateIndexBasePosLocal(Offset localPosition) {
    double maxSizeBox =
        ((sizeBox.width - (numBoxPerRow - 1) * padding) / numBoxPerRow);

    if (localPosition.dy > sizeBox.width || localPosition.dx > sizeBox.width)
      return -1;

    int x = 0, y = 0;
    double yAxis = 0, xAxis = 0;
    double yAxisStart = 0, xAxisStart = 0;

    for (var i = 0; i < numBoxPerRow; i++) {
      xAxisStart = xAxis;
      xAxis += maxSizeBox +
          (i == 0 || i == (numBoxPerRow - 1) ? padding / 2 : padding);
      if (xAxisStart < localPosition.dx && xAxis > localPosition.dx) {
        x = i;
        break;
      }
    }

    for (var i = 0; i < numBoxPerRow; i++) {
      yAxisStart = yAxis;
      yAxis += maxSizeBox +
          (i == 0 || i == (numBoxPerRow - 1) ? padding / 2 : padding);
      if (yAxisStart < localPosition.dy && yAxis > localPosition.dy) {
        y = i;
        break;
      }
    }

    return y * numBoxPerRow + x;
  }

  void generateLineOnDrag(PointerMoveEvent event) {
    if (currentDragObj.value.currentDragLine.isEmpty) {
      currentDragObj.value.currentDragLine = [];
    }

    int indexBase = calculateIndexBasePosLocal(event.localPosition);

    if (indexBase >= 0) {
      if (currentDragObj.value.currentDragLine.length >= 2) {
        WSOrientation? wsOrientation;

        if (currentDragObj.value.currentDragLine[0] % numBoxPerRow ==
            currentDragObj.value.currentDragLine[1] % numBoxPerRow)
          wsOrientation = WSOrientation.vertical;
        else if (currentDragObj.value.currentDragLine[0] ~/ numBoxPerRow ==
            currentDragObj.value.currentDragLine[1] ~/ numBoxPerRow)
          wsOrientation = WSOrientation.horizontal;

        if (wsOrientation == WSOrientation.horizontal &&
            indexBase ~/ numBoxPerRow !=
                currentDragObj.value.currentDragLine[1] ~/ numBoxPerRow) {
          onDragEnd(null);
        } else if (wsOrientation == WSOrientation.vertical &&
            indexBase % numBoxPerRow !=
                currentDragObj.value.currentDragLine[1] % numBoxPerRow) {
          onDragEnd(null);
        } else if (wsOrientation == null) {
          onDragEnd(null);
        }
      }

      if (!currentDragObj.value.currentDragLine.contains(indexBase))
        currentDragObj.value.currentDragLine.add(indexBase);
      else if (currentDragObj.value.currentDragLine.length >= 2 &&
          currentDragObj.value.currentDragLine[
                  currentDragObj.value.currentDragLine.length - 2] ==
              indexBase) onDragEnd(null);
    }
    currentDragObj.notifyListeners();
  }

  void onDragStart(int indexArray) {
    List<CrosswordAnswer> indexSelecteds = answerList.value
        .where((answer) => answer.indexArray == indexArray)
        .toList();

    if (indexSelecteds.isEmpty) return;

    currentDragObj.value.indexArrayOnTouch = indexArray;
    currentDragObj.notifyListeners();
  }

  void getData() {
    if (Get.arguments != null) {
      if (Get.arguments["option_game"] != null) {
        getNumBoxGrid = (Get.arguments["option_game"]);

        print(getNumBoxGrid);
      }
    }
  }
}

class CurrentDragObj {
  late Offset currentDragPos = Offset.zero;
  late Offset currentTouch;
  late int indexArrayOnTouch;
  List<int> currentDragLine = [];

  CurrentDragObj({
    this.indexArrayOnTouch = 0,
    this.currentTouch = Offset.zero,
  });
}

class CrosswordAnswer {
  bool done = false;
  late int indexArray;
  WSLocation wsLocation;
  late List<int> answerLines;

  CrosswordAnswer(this.wsLocation, {required int numPerRow}) {
    this.indexArray = this.wsLocation.y * numPerRow + this.wsLocation.x;
    generateAnswerLine(numPerRow);
  }

  void generateAnswerLine(int numperRow) {
    this.answerLines = <int>[];
    this.answerLines.addAll(List<int>.generate(this.wsLocation.overlap,
        (index) => generateIndexBaseOnAxis(this.wsLocation, index, numperRow)));
  }

  int generateIndexBaseOnAxis(WSLocation wsLocation, int i, int numPerRow) {
    int x = wsLocation.x, y = wsLocation.y;

    if (wsLocation.orientation == WSOrientation.horizontal ||
        wsLocation.orientation == WSOrientation.horizontalBack)
      x = (wsLocation.orientation == WSOrientation.horizontal) ? x + i : x - i;
    else
      y = (wsLocation.orientation == WSOrientation.vertical) ? y + i : y - i;

    return x + y * numPerRow;
  }
}
