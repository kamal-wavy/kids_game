import 'dart:math';

import 'package:flutter/material.dart';

class FireworkAnimation extends StatefulWidget {
  @override
  _FireworkAnimationState createState() => _FireworkAnimationState();
}

class _FireworkAnimationState extends State<FireworkAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation<double>? animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    );

    animation = CurvedAnimation(
      parent: controller!,
      curve: Curves.easeInOut,
    );

    controller!.repeat();
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation!,
      builder: (context, child) {
        return CustomPaint(
          size: Size(200, 200),
          painter: FireworkPainter(
            animationValue: animation!.value,
          ),
        );
      },
    );
  }
}

class FireworkPainter extends CustomPainter {
  final double animationValue;

  FireworkPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint shockwavePaint = Paint()
      ..color = Colors.orange.withOpacity(1.0 - animationValue)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final Paint smokePaint = Paint()
      ..color = Colors.grey.withOpacity(0.5 * animationValue)
      ..style = PaintingStyle.fill;

    final double maxRadius = 80.0;

    // Draw shockwave
    double currentRadius = maxRadius * animationValue;
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), currentRadius, shockwavePaint);

    // Draw smoke
    final Random random = Random();
    for (int i = 0; i < 50; i++) {
      final double offsetX = random.nextDouble() * size.width;
      final double offsetY = random.nextDouble() * size.height;
      final double smokeRadius = random.nextDouble() * 20.0 * animationValue;
      canvas.drawCircle(Offset(offsetX, offsetY), smokeRadius, smokePaint);
    }
  }

  @override
  bool shouldRepaint(FireworkPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
