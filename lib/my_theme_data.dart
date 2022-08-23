import 'package:flutter/material.dart';

abstract class MyThemeData {
  static Color blue = Colors.blue;
  static Color brown = Colors.brown;
  static TextStyle scoreTextStyle(
      Orientation screenOrientation, double screenWidth) {
    return TextStyle(
        fontSize: screenOrientation != Orientation.landscape
            ? screenWidth * .04
            : screenWidth * .025,
        fontWeight: FontWeight.w400,
        color: const Color.fromARGB(143, 0, 0, 0));
  }

  static heartSize(Orientation screenOrientation, double screenWidth) {
    return screenOrientation != Orientation.landscape
        ? screenWidth * .14
        : screenWidth * .07;
  }

  static insideHeartTextStyle() {
    return const TextStyle(
        fontWeight: FontWeight.w400, color: Color.fromARGB(255, 253, 253, 253));
  }
}
