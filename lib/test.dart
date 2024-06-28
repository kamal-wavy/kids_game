import 'package:KidsPlan/word6.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Blast extends StatefulWidget {
  @override
  _MyLottieWidgetState createState() => _MyLottieWidgetState();
}

class _MyLottieWidgetState extends State<Blast> with TickerProviderStateMixin {
  late AnimationController _controller;

  // final List<int> items = [6, 8, 9];
  final List<String> items = ["Easy", "Medium", "Hard"];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Find word'),
      ),
      body: Center(
          child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              print('${items[index]} tapped!');
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${items[index]} tapped!')));
              Get.offAll(CrosswordWidget6(), arguments: {
                'option_game': items[index] == 'Easy'
                    ? 6
                    : items[index] == 'Medium'
                        ? 8
                        : 9
              });
            },
            child: Card(
              margin: EdgeInsets.all(10),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  items[index].toString(),
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          );
        },
      )),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
