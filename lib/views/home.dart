import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mario/assets/constants.dart';
import 'package:mario/my_theme_data.dart';
import 'package:mario/view_model/home.dart';
import 'package:mario/widgets.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    Orientation screenOrientation = MediaQuery.of(context).orientation;

    return ChangeNotifierProvider(
      create: (context) => HomeProvider(),
      builder: (context, child) {
        HomeProvider provider = Provider.of(context);

        PreferredSizeWidget appBar() {
          return AppBar(
            backgroundColor: Colors.white,
            title: Row(
              children: [
                //score
                Expanded(
                  child: Text('score : ${provider.score.toInt()}',
                      textAlign: TextAlign.center,
                      style: MyThemeData.scoreTextStyle(
                          screenOrientation, screenWidth)),
                ),
                //high score
                Expanded(
                  child: Text('High score : ${provider.higheScore.toInt()}',
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
                        size: MyThemeData.heartSize(
                            screenOrientation, screenWidth)),
                    Text(provider.chances.toString(),
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

        Image runImg(double screenHeight) {
          provider.isJumping = false;

          return Image.asset(
            Constants.runImg,
            height: screenHeight * .15,
          );
        }

        return Scaffold(
          backgroundColor: MyThemeData.blue,
          appBar: appBar(),
          body: GestureDetector(
            onTap: () {
              provider.jump();
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
                        alignment: Alignment(provider.marioX, provider.marioY),
                        color: MyThemeData.blue,
                        child: provider.isJumping
                            ? Widgets.jumpImg(screenHeight)
                            : provider.iscrashed
                                ? Widgets.standImg(screenHeight)
                                : runImg(screenHeight)),
                    //monster img
                    Container(
                        alignment: Alignment(provider.monsterPosition, 1),
                        child:
                            Widgets.monsterSizedBox(screenWidth, screenHeight)),
                    //try again
                    provider.iscrashed
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
                                      color: const Color.fromARGB(
                                          255, 43, 186, 48),
                                      onPressed: () {
                                        provider.tryAgain();
                                      },
                                      child: Widgets.tryAgain(
                                          screenOrientation, screenWidth))
                                ],
                              ),
                            ),
                          )
                        : Container(),
                    provider.chanceLost
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
      },
    );
  }
}
