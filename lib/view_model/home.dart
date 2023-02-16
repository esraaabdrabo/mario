import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:mario/assets/cache_helper.dart';
import 'package:mario/assets/constants.dart';

class HomeProvider extends ChangeNotifier {
//  String marioImgPath = Constants.jump;

  double higheScore = 0;

  HomeProvider() {
    getHighScore();
    moveMonster();
  }

  getHighScore() {
    var highScoreInSharedPref =
        CacheHelper.getData(key: Constants.highScoreKey);
    if (highScoreInSharedPref == null) {
      CacheHelper.setData(key: Constants.highScoreKey, data: 0);
    } else if (highScoreInSharedPref is double) {
      //has high score
      higheScore = highScoreInSharedPref;
    }
  }

  void changeHighScore() {
    if (higheScore < score) {
      //passed high score
      higheScore = score;
      CacheHelper.setData(key: Constants.highScoreKey, data: score);
    }
  }

  // mario
  double marioX = -.7;
  double marioY = 1;
  bool isJumping = false;
  bool iscrashed = false;

  Future<void> backToGround() async {
    await Future.delayed(const Duration(milliseconds: 500), () async {
      marioY = 1; //0 .2 .4 .6 .8 1
      await Future.delayed(const Duration(milliseconds: 500), () {
        isJumping = false;
      });
    });
    notifyListeners();
  }

  void jump() async {
    if (iscrashed) {
    } else {
      isJumping = true;
      marioY = 0;
      notifyListeners();

      await backToGround();
    }
  }

  //monster
  double monsterPosition = 1.5;
  bool checkCrashing() {
    return monsterPosition.toStringAsExponential(1) ==
            marioX.toStringAsExponential(1) &&
        !isJumping;
  }

  int chances = 5;
  bool chanceLost = false;
  double score = 0;

  moveMonster() {
    //-2 -1.5 -1 -.5 0 .5 1 1.5 2
    Timer.periodic(const Duration(milliseconds: 10), (timer) async {
      if (chanceLost) {}
      if (checkCrashing()) {
        changeHighScore();
        chances--;
        score = 0;
        monsterPosition = 1.5;
        chanceLost = true;

        if (chances == 0) {
          iscrashed = true;
          timer.cancel();
        }
        await Future.delayed(const Duration(milliseconds: 1000), () {});
        chanceLost = false;
      }
      if (monsterPosition < -2.5) {
        //start from right again
        monsterPosition = 1.5;
        notifyListeners();
      } else {
        //did not achieve end
        monsterPosition = monsterPosition - .01; //1.5 1 .5 0 -.5 -1.0 -1.5
        score += .02;
        if (score > higheScore) {
          higheScore += .02;
        }
        notifyListeners();
      }
    });
  }

  void tryAgain() {
    marioX = -.7;
    marioY = 1;
    isJumping = false;
    iscrashed = false;
    monsterPosition = 1.5;
    chances = 5;
    chanceLost = false;
    score = 0;
    notifyListeners();
    moveMonster();
  }
}
