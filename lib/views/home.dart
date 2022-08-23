import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mario/my_theme_data.dart';
import 'package:mario/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ///////////get the high score ////////////////
  Future<SharedPreferences> prefrence = SharedPreferences.getInstance();

  late double higheScore;
  String highScoreKey = 'highScore';
  void getHighScore() async {
    await prefrence.then((SharedPreferences pref) {
      if (pref.containsKey(highScoreKey)) {
        higheScore = pref.getDouble(highScoreKey)!;
      } else {
        pref.setDouble(highScoreKey, 0);
      }
      return 0;
    });
  }

  void changeHighScore() {
    if (higheScore < score) {
      higheScore = score;
      prefrence.then((pref) => pref.setDouble(highScoreKey, score));
    }
  }

/////////////// mario  //////////////
  double marioX = -.7;
  double marioY = 1;
  bool isJumping = false;
  Future<void> backToGround() async {
    await Future.delayed(const Duration(milliseconds: 500), () {
      marioY += 1; //0 .2 .4 .6 .8 1
      setState(() {});
    });
  }

  void jump() async {
    if (iscrashed) {
    } else {
      isJumping = true;
      marioY = 0;
      setState(() {});

      backToGround().then((value) async {
        await Future.delayed(const Duration(milliseconds: 500), () {
          isJumping = false;
          setState(() {});
        });
      });
    }
  }

  Image runImg(double screenHeight) {
    isJumping = false;
    setState(() {});
    return Image.asset(
      'assets/images/run.gif',
      height: screenHeight * .15,
    );
  }

  ///////////// monster ////////////
  double monsterPosition = 1.5;
  bool iscrashed = false;
  bool checkCrashing() {
    return monsterPosition.toStringAsExponential(1) ==
            marioX.toStringAsExponential(1) &&
        !isJumping;
  }

  int chances = 5;
  bool chanceLost = false;
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
        setState(() {});
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
      } else {
        //did not achieve end
        monsterPosition = monsterPosition - .01; //1.5 1 .5 0 -.5 -1.0 -1.5
        score += .02;
        if (score > higheScore) {
          higheScore += .02;
        }

        setState(() {});
      }
    });
  }

  ////////////  player //////////////
  double score = 0;
  @override
  void initState() {
    super.initState();
    moveMonster();
    getHighScore();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    Orientation screenOrientation = MediaQuery.of(context).orientation;

    PreferredSizeWidget appBar() {
      return AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            //score
            Expanded(
              child: Text('score : ${score.toInt()}',
                  textAlign: TextAlign.center,
                  style: MyThemeData.scoreTextStyle(
                      screenOrientation, screenWidth)),
            ),
            //high score
            Expanded(
              child: Text('High score : ${higheScore.toInt()}',
                  textAlign: TextAlign.center,
                  style: MyThemeData.scoreTextStyle(
                      screenOrientation, screenWidth)),
            ),
            //heart
            Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Icon(Icons.favorite,
                    color: Colors.red,
                    size:
                        MyThemeData.heartSize(screenOrientation, screenWidth)),
                Text(chances.toString(),
                    textAlign: TextAlign.center,
                    style: MyThemeData.insideHeartTextStyle())
              ],
            ),
            SizedBox(
              width: screenWidth * .05,
            )
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: MyThemeData.blue,
      appBar: appBar(),
      body: GestureDetector(
        onTap: () {
          jump();
        },
        child: Column(children: [
          //blue
          Expanded(
            flex: 3,
            //mario and monster
            child: Stack(
              children: [
                //mario img
                AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    alignment: Alignment(marioX, marioY),
                    color: MyThemeData.blue,
                    child: isJumping
                        ? Widgets.jumpImg(screenHeight)
                        : iscrashed
                            ? Widgets.standImg(screenHeight)
                            : runImg(screenHeight)),
                //monster img
                Container(
                    alignment: Alignment(monsterPosition, 1),
                    child: Widgets.monsterSizedBox(screenWidth, screenHeight)),
                //try again
                iscrashed
                    ? Center(
                        child: Container(
                          alignment: const Alignment(0, 0),
                          height: screenHeight * .2,
                          width: screenWidth * .8,
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Widgets.gameOverText(
                                  screenOrientation, screenWidth),
                              MaterialButton(
                                  color: const Color.fromARGB(255, 43, 186, 48),
                                  onPressed: () {
                                    iscrashed = false;
                                    chances = 5;
                                    moveMonster();
                                  },
                                  child: Widgets.TryAgainBTNtext(
                                      screenOrientation, screenWidth))
                            ],
                          ),
                        ),
                      )
                    : Container(),
                chanceLost
                    ? Center(
                        child: Container(
                            alignment: const Alignment(0, 0),
                            height: screenHeight * .2,
                            width: screenWidth * .8,
                            color: Colors.white,
                            child: Text('OOPS')),
                      )
                    : Container()
              ],
            ),
          ),
          //green
          Widgets.greenSeperator(screenHeight),
          //brown
          Widgets.brownArea
        ]),
      ),
    );
  }
}
