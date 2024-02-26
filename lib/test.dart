// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
//
// class Blast extends StatefulWidget {
//   @override
//   _MyLottieWidgetState createState() => _MyLottieWidgetState();
// }
//
// class _MyLottieWidgetState extends State<Blast> with TickerProviderStateMixin {
//   late AnimationController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Lottie Animation'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Lottie.asset(
//               'assets/s.json',
//               width: 200, // Adjust according to your animation's dimensions
//               height: 200,
//               controller: _controller,
//               onLoaded: (composition) {
//                 _controller.duration = composition.duration;
//               },
//             ),
//             SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 ElevatedButton(
//                   onPressed: () {
//                     _controller.forward();
//                   },
//                   child: Text('Start'),
//                 ),
//                 SizedBox(width: 20),
//                 ElevatedButton(
//                   onPressed: () {
//                     _controller.stop();
//                   },
//                   child: Text('Stop'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }


