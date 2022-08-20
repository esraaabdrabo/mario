import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double marioX = 0;
  double marioY = 1;
  String marioImgPath = 'assets/images/jump.png';

  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    Widget greenSeperator(double screenHeight) {
      return Container(
        height: screenHeight * .02,
        color: Colors.green,
      );
    }

    BoxDecoration btnDec(double screenWidth) {
      return BoxDecoration(
          color: const Color.fromARGB(101, 255, 255, 255),
          borderRadius: BorderRadius.all(Radius.circular(screenWidth * .04)));
    }

    Future<void> backToGround() async {
      await Future.delayed(const Duration(milliseconds: 500), () {
        marioY += 1; //0 .2 .4 .6 .8 1
        setState(() {});
      });
    }

    void jump() async {
      marioImgPath = 'assets/images/jump.png';
      marioY = 0;
      setState(() {});

      backToGround().then((value) async {
        await Future.delayed(const Duration(milliseconds: 1000), () {
          marioImgPath = 'assets/images/run.gif';
          setState(() {});
        });
      });
    }

    InkWell upBTN(double screenHeight, double screenWidth) {
      return InkWell(
          onTap: () {
            jump();
          },
          child: Container(
              height: screenHeight * .1,
              width: screenWidth * .2,
              decoration: btnDec(screenWidth),
              child: Icon(
                Icons.arrow_upward,
                color: Colors.white,
                size: screenWidth * .1,
              )));
    }

    return Column(children: [
      //blue
      Expanded(
        flex: 3,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 1000),
          alignment: Alignment(marioX, marioY),
          color: Colors.blue,
          child: Image.asset(
            marioImgPath,
            height: screenHeight * .1,
          ),
        ),
      ),
      //green
      greenSeperator(screenHeight),
      //brown
      Expanded(
          child: Container(
        color: Colors.brown,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          upBTN(screenHeight, screenWidth),
        ]),
      ))
    ]);
  }
}
