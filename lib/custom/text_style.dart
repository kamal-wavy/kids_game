import 'package:flutter/material.dart';

class AppTextStyles {
  static TextStyle heading1(
      {Color? textColor,
      double? size,
      TextDecoration? decoration,
      bool? letterpsacingValue,
      var customFamily,
      bool? borderText}) {
    return TextStyle(
        letterSpacing: letterpsacingValue == true ? 2 : 0,
        fontSize: size?.toDouble() ?? 30.0,
        fontWeight: FontWeight.bold,
        color: textColor ?? Colors.white,
        decoration: decoration,
        fontFamily: customFamily,
        shadows: borderText == true
            ? [
                Shadow(
                    // bottomLeft
                    offset: Offset(-1.5, -1.5),
                    color: Colors.white),
                Shadow(
                    // bottomRight
                    offset: Offset(1.5, -1.5),
                    color: Colors.white),
                Shadow(
                    // topRight
                    offset: Offset(1.5, 1.5),
                    color: Colors.white),
                Shadow(
                    // topLeft
                    offset: Offset(-1.5, 1.5),
                    color: Colors.white),
              ]
            : null);
  }

  static TextStyle headingNormal({Color? textColor, int? size}) {
    return TextStyle(
      fontSize: size?.toDouble() ?? 30.0,
      color: textColor ?? Colors.white,
    );
  }

  static const TextStyle heading2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle bodyText = TextStyle(
    fontSize: 16,
    color: Colors.grey,
  );

// Add more styles as needed
}
