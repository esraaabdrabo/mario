import 'package:flutter/material.dart';
import 'package:mario/assets/constants.dart';

import 'my_Theme_Data.dart';

abstract class Widgets {
  static Expanded brownArea = Expanded(
    child: Container(
      color: MyThemeData.brown,
    ),
  );

  static Image jumpImg(double screenHeight) {
    return Image.asset(
      Constants.jumpImg,
      height: screenHeight * .1,
    );
  }

  static Image standImg(double screenHeight) {
    return Image.asset(
      Constants.stangImg,
      height: screenHeight * .12,
    );
  }

  static Widget greenSeperator(double screenHeight) {
    return Container(
      height: screenHeight * .02,
      color: Colors.green,
    );
  }

  static monsterSizedBox(double screenWidth, double screenHeight) {
    return SizedBox(
      width: screenWidth * .15,
      height: screenHeight * .1,
      child: Image.asset(Constants.monister1Img
          //generateMonister(),
          ),
    );
  }

  static gameOverText(Orientation screenOrientation, double screenWidth) {
    return Text('Game Over',
        style: MyThemeData.scoreTextStyle(screenOrientation, screenWidth));
  }

  static Text tryAgain(
      Orientation screenOrientation, double screenWidth) {
    return Text('Try Again',
        style: MyThemeData.scoreTextStyle(screenOrientation, screenWidth)
            .copyWith(color: Colors.white));
  }
}
