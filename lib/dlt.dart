import 'dart:math';

import 'package:flutter/material.dart';


class CrosswordWidget extends StatefulWidget {
  @override
  _CrosswordWidgetState createState() => _CrosswordWidgetState();
}

class _CrosswordWidgetState extends State<CrosswordWidget> {
  List<List<String>> crosswordGrid = [];
  List<List<bool>> cellIntersections = []; // Tracks cells that intersect

  List<Offset> currentDragPoints = []; // Points for current drag gesture
  Color ribbonColor = Colors.blue; // Color for the ribbon

  int numBoxPerRow = 9; // Grid size
  int numPerRow = 9; // Number of cells per row (assuming square grid)

  @override
  void initState() {
    super.initState();
    generateRandomWord(); // Initialize crossword grid
  }

  void generateRandomWord() {
    // Generate a random crossword grid
    crosswordGrid = List.generate(numBoxPerRow, (index) =>
        List.generate(numPerRow, (index) => String.fromCharCode('A'.codeUnitAt(0) + index + numBoxPerRow * (index ~/ 26))
        ));

    // Initialize cellIntersections (for demo purpose, assume no intersections initially)
    cellIntersections = List.generate(numBoxPerRow * numPerRow, (index) =>
        List.generate(numBoxPerRow * numPerRow, (index) => false)
    );

    setState(() {}); // Update the state to reflect changes
  }

  void onDragStart(int startIndex) {
    currentDragPoints.clear();
    currentDragPoints.add(_getPointFromIndex(startIndex));
    setState(() {});
  }

  void onDragUpdate(int currentIndex) {
    if (currentDragPoints.isNotEmpty) {
      currentDragPoints.add(_getPointFromIndex(currentIndex));
      setState(() {});
    }
  }

  void onDragEnd(int endIndex) {
    currentDragPoints.clear();
    setState(() {});
  }

  Offset _getPointFromIndex(int index) {
    int row = index ~/ numPerRow;
    int col = index % numPerRow;
    double cellSize = 50.0; // Replace with your cell size

    return Offset(col * cellSize + cellSize / 2, row * cellSize + cellSize / 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crossword Puzzle'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: numBoxPerRow,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
        ),
        itemCount: numBoxPerRow * numBoxPerRow,
        itemBuilder: (context, index) {
          String char = crosswordGrid[index ~/ numPerRow][index % numPerRow];

          bool intersects = cellIntersections[index].any((intersected) => intersected);
          bool isDragged = currentDragPoints.isNotEmpty && currentDragPoints.any((point) => _getPointFromIndex(index) == point);

          return GestureDetector(
            onPanStart: (details) => onDragStart(index),
            onPanUpdate: (details) => onDragUpdate(index),
            onPanEnd: (details) => onDragEnd(index),
            child: CustomPaint(
              painter: isDragged ? DynamicRibbonPainter(currentDragPoints, ribbonColor, 6.0) : null,
              child: Container(
                color: intersects ? Colors.grey : Colors.transparent,
                alignment: Alignment.center,
                child: Text(
                  char.toUpperCase(),
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class DynamicRibbonPainter extends CustomPainter {
  final List<Offset> points;
  final Color color;
  final double strokeWidth;

  DynamicRibbonPainter(this.points, this.color, this.strokeWidth);

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Path path = Path();
    path.moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
