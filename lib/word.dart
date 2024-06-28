// import 'package:flutter/material.dart';
// import 'package:word_search_safety/word_search_safety.dart';
//
//
// class CrosswordWidget extends StatefulWidget {
//   CrosswordWidget({Key? key}) : super(key: key);
//
//   @override
//   _CrosswordWidgetState createState() => _CrosswordWidgetState();
// }
//
// class _CrosswordWidgetState extends State<CrosswordWidget> {
//   int numBoxPerRow = 6;
//   double padding = 5;
//   Size sizeBox = Size.zero;
//
//   late ValueNotifier<List<List<String>>> listChars;
//   late ValueNotifier<List<CrosswordAnswer>> answerList;
//   late ValueNotifier<CurrentDragObj> currentDragObj;
//   late ValueNotifier<List<int>> charsDone;
//
//   @override
//   void initState() {
//     super.initState();
//     listChars = ValueNotifier<List<List<String>>>([]);
//     answerList = ValueNotifier<List<CrosswordAnswer>>([]);
//     currentDragObj = ValueNotifier<CurrentDragObj>(CurrentDragObj());
//     charsDone = ValueNotifier<List<int>>([]);
//     generateRandomWord();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//
//     return Scaffold(
//       body: Container(
//         child: Column(
//           children: [
//             Container(
//               color: Colors.blue,
//               alignment: Alignment.center,
//               width: double.maxFinite,
//               height: size.width - padding * 2,
//               padding: EdgeInsets.all(padding),
//               margin: EdgeInsets.all(padding),
//               child: drawCrosswordBox(),
//             ),
//             Container(
//               alignment: Alignment.center,
//               child: drawAnswerList(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void onDragEnd(PointerUpEvent? event) {
//     if (currentDragObj.value.currentDragLine.isEmpty) return;
//     currentDragObj.value.currentDragLine.clear();
//     currentDragObj.notifyListeners();
//   }
//
//   void onDragUpdate(PointerMoveEvent event) {
//     generateLineOnDrag(event);
//
//     int indexFound = answerList.value.indexWhere((answer) {
//       return answer.answerLines.join("-") ==
//           currentDragObj.value.currentDragLine.join("-");
//     });
//
//     if (indexFound >= 0) {
//       answerList.value[indexFound].done = true;
//       charsDone.value.addAll(answerList.value[indexFound].answerLines);
//       charsDone.notifyListeners();
//       answerList.notifyListeners();
//       onDragEnd(null);
//     }
//   }
//
//   int calculateIndexBasePosLocal(Offset localPosition) {
//     double maxSizeBox = ((sizeBox.width - (numBoxPerRow - 1) * padding) / numBoxPerRow);
//
//     if (localPosition.dy > sizeBox.width || localPosition.dx > sizeBox.width) return -1;
//
//     int x = 0, y = 0;
//     double yAxis = 0, xAxis = 0;
//
//     for (var i = 0; i < numBoxPerRow; i++) {
//       xAxis += maxSizeBox + (i == 0 || i == (numBoxPerRow - 1) ? padding / 2 : padding);
//       if (localPosition.dx < xAxis) {
//         x = i;
//         break;
//       }
//     }
//
//     for (var i = 0; i < numBoxPerRow; i++) {
//       yAxis += maxSizeBox + (i == 0 || i == (numBoxPerRow - 1) ? padding / 2 : padding);
//       if (localPosition.dy < yAxis) {
//         y = i;
//         break;
//       }
//     }
//
//     return y * numBoxPerRow + x;
//   }
//
//   void generateLineOnDrag(PointerMoveEvent event) {
//     if (currentDragObj.value.currentDragLine.isEmpty) {
//       currentDragObj.value.currentDragLine = [];
//     }
//
//     int indexBase = calculateIndexBasePosLocal(event.localPosition);
//
//     if (indexBase >= 0) {
//       if (currentDragObj.value.currentDragLine.length >= 2) {
//         WSOrientation? wsOrientation;
//
//         if (currentDragObj.value.currentDragLine[0] % numBoxPerRow ==
//             currentDragObj.value.currentDragLine[1] % numBoxPerRow)
//           wsOrientation = WSOrientation.vertical;
//         else if (currentDragObj.value.currentDragLine[0] ~/ numBoxPerRow ==
//             currentDragObj.value.currentDragLine[1] ~/ numBoxPerRow)
//           wsOrientation = WSOrientation.horizontal;
//
//         if (wsOrientation == WSOrientation.horizontal &&
//             indexBase ~/ numBoxPerRow != currentDragObj.value.currentDragLine[1] ~/ numBoxPerRow) {
//           onDragEnd(null);
//         } else if (wsOrientation == WSOrientation.vertical &&
//             indexBase % numBoxPerRow != currentDragObj.value.currentDragLine[1] % numBoxPerRow) {
//           onDragEnd(null);
//         } else if (wsOrientation == null) {
//           onDragEnd(null);
//         }
//       }
//
//       if (!currentDragObj.value.currentDragLine.contains(indexBase))
//         currentDragObj.value.currentDragLine.add(indexBase);
//       else if (currentDragObj.value.currentDragLine.length >= 2 &&
//           currentDragObj.value.currentDragLine[currentDragObj.value.currentDragLine.length - 2] == indexBase)
//         onDragEnd(null);
//     }
//     currentDragObj.notifyListeners();
//   }
//
//   void onDragStart(int indexArray) {
//     List<CrosswordAnswer> indexSelecteds = answerList.value
//         .where((answer) => answer.indexArray == indexArray)
//         .toList();
//
//     if (indexSelecteds.isEmpty) return;
//
//     currentDragObj.value.indexArrayOnTouch = indexArray;
//     currentDragObj.notifyListeners();
//   }
//
//   Widget drawCrosswordBox() {
//     return Listener(
//         onPointerUp: (event) => onDragEnd(event),
//         onPointerMove: (event) => onDragUpdate(event),
//         child: LayoutBuilder(
//         builder: (context, constraints) {
//       sizeBox = Size(constraints.maxWidth, constraints.maxWidth);
//       return GridView.builder(
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           childAspectRatio: 1,
//           crossAxisCount: numBoxPerRow,
//           crossAxisSpacing: padding,
//           mainAxisSpacing: padding,
//       ),
//     itemCount: numBoxPerRow * numBoxPerRow,
//     physics: NeverScrollableScrollPhysics(),
//     itemBuilder: (context, index) {
//     String char = listChars.value.expand((e) => e).toList()[index];
//
//     return Listener(
//     onPointerDown: (event) => onDragStart(index),
//     child: ValueListenableBuilder(
//     valueListenable: currentDragObj,
//     builder: (context, CurrentDragObj value, child) {
//     Color color = Colors.yellow;
//
//     if (value.currentDragLine.contains(index))
//     color = Colors.blue;
//     else if (charsDone.value.contains(index))
//     color = Colors.red;
//
//     return Container(
//     decoration: BoxDecoration(
//     color: color,
//     ),
//     alignment: Alignment.center,
//       child: Text(
//         char.toUpperCase(),
//         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//       ),
//     );
//     },
//     ),
//     );
//     },
//       );
//         },
//         ),
//     );
//   }
//   void generateRandomWord() {
//     print('Word Search Library!');
//
//     // Create a list of words to be jumbled into a puzzle
//     final List<String> wl = ['hello', 'world', 'foo', 'bar', 'baz', 'dart'];
//
//     // Create the puzzle setting object
//     final WSSettings ws = WSSettings(
//       width: numBoxPerRow,
//       height: numBoxPerRow,
//       orientations: [
//         WSOrientation.horizontal,
//         WSOrientation.vertical,
//         WSOrientation.diagonal,
//       ],
//     );
//
//     // Create new instance of the WordSearch class
//     final WordSearchSafety wordSearch = WordSearchSafety();
//
//     // Create a new puzzle
//     final WSNewPuzzle? newPuzzle = wordSearch.newPuzzle(wl, ws);
//
//     /// Check if there are errors generated while creating the puzzle
//     if (newPuzzle != null && newPuzzle.errors!.isEmpty) {
//       final puzzle = newPuzzle.puzzle!;
//
//       // The puzzle output
//       print('Puzzle 2D List');
//       print(puzzle.toString());
//
//       // Solve puzzle for given word list
//       final WSSolved solved =
//       wordSearch.solvePuzzle(puzzle, ['dart', 'word']);
//       // All found words by solving the puzzle
//       print('Found Words!');
//       solved.found!.forEach((element) {
//         print('word: ${element.word}, orientation: ${element.orientation}');
//         print('x:${element.x}, y:${element.y}');
//       });
//
//       // All words that could not be found
//       print('Not found Words!');
//       solved.notFound!.forEach((element) {
//         print('word: ${element}');
//       });
//     } else {
//       // Notify the user of the errors or if the puzzle couldn't be generated
//       if (newPuzzle == null) {
//         print("Error: Puzzle couldn't be generated.");
//       } else {
//         // Notify the user of the errors
//         newPuzzle.errors!.forEach((error) {
//           print(error);
//         });
//       }
//     }
//   }
//
//   // void generateRandomWord() {
//   //   print('Word Search Library!');
//   //
//   //   // Create a list of words to be jumbled into a puzzle
//   //   final List<String> wl = ['hello', 'world', 'foo', 'bar', 'baz', 'dart'];
//   //
//   //   // Create the puzzle sessting object
//   //   final WSSettings ws = WSSettings(
//   //     width: 10,
//   //     height: 10,
//   //     orientations: List.from([
//   //       WSOrientation.horizontal,
//   //       WSOrientation.vertical,
//   //       WSOrientation.diagonal,
//   //     ]),
//   //   );
//   //
//   //   // Create new instance of the WordSearch class
//   //   final WordSearchSafety wordSearch = WordSearchSafety();
//   //
//   //   // Create a new puzzle
//   //   final WSNewPuzzle newPuzzle = wordSearch.newPuzzle(wl, ws);
//   //
//   //   /// Check if there are errors generated while creating the puzzle
//   //   if (newPuzzle.errors!.isEmpty) {
//   //     // The puzzle output
//   //     print('Puzzle 2D List');
//   //     print(newPuzzle.toString());
//   //
//   //     // Solve puzzle for given word list
//   //     final WSSolved solved =
//   //     wordSearch.solvePuzzle(newPuzzle.puzzle, ['dart', 'word']);
//   //     // All found words by solving the puzzle
//   //     print('Found Words!');
//   //     solved.found!.forEach((element) {
//   //       print('word: ${element.word}, orientation: ${element.orientation}');
//   //       print('x:${element.x}, y:${element.y}');
//   //     });
//   //
//   //     // All words that could not be found
//   //     print('Not found Words!');
//   //     solved.notFound!.forEach((element) {
//   //       print('word: ${element}');
//   //     });
//   //   } else {
//   //     // Notify the user of the errors
//   //     newPuzzle.errors!.forEach((error) {
//   //       print(error);
//   //     });
//   //   }
//   // }
//
//   Widget drawAnswerList() {
//     return ValueListenableBuilder(
//       valueListenable: answerList,
//       builder: (context, List<CrosswordAnswer> value, child) {
//         int perColTotal = 3;
//         List<Widget> list = List.generate(
//             (value.length ~/ perColTotal) + ((value.length % perColTotal) > 0 ? 1 : 0), (int index) {
//           int maxColumn = (index + 1) * perColTotal;
//
//           return Container(
//             margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: List.generate(
//                   maxColumn > value.length ? maxColumn - value.length : perColTotal, (indexChild) {
//                 int indexArray = (index) * perColTotal + indexChild;
//
//                 return Text(
//                   "${value[indexArray].wsLocation.word}",
//                   style: TextStyle(
//                     fontSize: 18,
//                     color: value[indexArray].done ? Colors.green : Colors.black,
//                     decoration: value[indexArray].done
//                         ? TextDecoration.lineThrough
//                         : TextDecoration.none,
//                   ),
//                 );
//               }).toList(),
//             ),
//           );
//         }).toList();
//
//         return Column(
//           children: list,
//         );
//       },
//     );
//   }
// }
//
// class CurrentDragObj {
//   late Offset currentDragPos = Offset.zero; // Initializing as late and assigning Offset.zero
//   late Offset currentTouch;
//   late int indexArrayOnTouch;
//   List<int> currentDragLine = [];
//
//   CurrentDragObj({
//     this.indexArrayOnTouch = 0,
//     this.currentTouch = Offset.zero,
//   });
// }
//
// class CrosswordAnswer {
//   bool done = false;
//   late int indexArray; // Initializing as late and assigning in the constructor
//
//   WSLocation wsLocation;
//   late List<int> answerLines;
//
//   CrosswordAnswer(this.wsLocation, {required int numPerRow}) {
//     indexArray = this.wsLocation.y * numPerRow + this.wsLocation.x;
//     generateAnswerLine(numPerRow);
//   }
//
//   void generateAnswerLine(int numPerRow) {
//     answerLines = [];
//
//     answerLines.addAll(List<int>.generate(
//         this.wsLocation.overlap,
//             (index) =>
//             generateIndexBaseOnAxis(this.wsLocation, index, numPerRow)));
//   }
//
//   int generateIndexBaseOnAxis(WSLocation wsLocation, int i, int numPerRow) {
//     int x = wsLocation.x, y = wsLocation.y;
//
//     if (wsLocation.orientation == WSOrientation.horizontal ||
//         wsLocation.orientation == WSOrientation.horizontalBack)
//       x = (wsLocation.orientation == WSOrientation.horizontal) ? x + i : x - i;
//     else
//       y = (wsLocation.orientation == WSOrientation.vertical) ? y + i : y - i;
//
//     return x + y * numPerRow;
//   }
// }
//
//
//
