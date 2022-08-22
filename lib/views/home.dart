import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:math';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double marioX = -.7;
  double marioY = 1;
  bool isJumping = false;
  double monisterPosition = 1.5;
  bool crashed = false;
  moveMonister() {
    //-2 -1.5 -1 -.5 0 .5 1 1.5 2

    Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if (!crashed) {
        if (monisterPosition.toStringAsExponential(1) ==
            marioX.toStringAsExponential(1)) {
          crashed = true;
          setState(() {});
          timer.cancel();
        }
        if (monisterPosition < -2.5) {
          //start from right again
          monisterPosition = 1.5;
          setState(() {});
        } else {
          //did not achieve end
          //.5 -.5=0
          //-.5 -.5 = -1.0
          monisterPosition = monisterPosition - .01; //1.5 1 .5 0 -.5 -1.0 -1.5
          setState(() {});
        }

        print(monisterPosition);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    moveMonister();
  }

  @override
  Widget build(BuildContext context) {
    print(2.0.toStringAsExponential(1));
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    move() async {
      while (true) {
        await Future.delayed(const Duration(milliseconds: 1000), () {
          if (monisterPosition < -2.5) {
            monisterPosition = 1.5;
            setState(() {});
          } else {
            monisterPosition = monisterPosition - .01;
            setState(() {});
          }
        });

        print(monisterPosition);
      }
      //   return 0;
    }

    String generateMonister() {
      int monisterNum = Random().nextInt(2);
      List<String> monisterImgList = [
        'assets/images/monister1.png',
        'assets/images/monister2.png',
      ];
      // double monisterX = Random().nextDouble();

      return monisterImgList[monisterNum];
    }

    //////////////jump functions///////////
    Future<void> backToGround() async {
      await Future.delayed(const Duration(milliseconds: 500), () {
        marioY += 1; //0 .2 .4 .6 .8 1
        setState(() {});
      });
    }

    void jump() async {
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

///////////////widgets//////////////////
    Image jumpImg() {
      return Image.asset(
        'assets/images/jump.png',
        height: screenHeight * .1,
      );
    }

    Image runImg() {
      isJumping = false;
      setState(() {});
      return Image.asset(
        'assets/images/run.gif',
        height: screenHeight * .15,
      );
    }

    Widget greenSeperator(double screenHeight) {
      return Container(
        height: screenHeight * .02,
        color: Colors.green,
      );
    }

    //  moveMonister();
    return GestureDetector(
      onTap: () {
        jump();
      },
      child: Column(children: [
        //blue
        Expanded(
          flex: 3,
          child: Stack(
            children: [
              AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  alignment: Alignment(marioX, marioY),
                  color: Colors.blue,
                  child: isJumping ? jumpImg() : runImg()),
              Container(
                  //    color: Colors.amber,
                  width: screenWidth,
                  //duration: const Duration(milliseconds: 10),
                  alignment: Alignment(monisterPosition, 1),
                  child: SizedBox(
                    width: screenWidth * .15,
                    height: screenHeight * .1,
                    child: Image.asset(
                        'assets/images/monister1.png' //generateMonister(),
                        ),
                  )),
            ],
          ),
        ),
        //green
        greenSeperator(screenHeight),
        //brown
        Expanded(
          child: Container(
            color: Colors.brown,
          ),
        )
      ]),
    );
  }
}
