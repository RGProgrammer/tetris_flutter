import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tetris_game/logic/Game.dart';
import 'package:tetris_game/ui/StartScreen.dart';

import 'Grid.dart';

class PlayScreen extends StatefulWidget {
  @override
  _PlayScreenState createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> with WidgetsBindingObserver {
  Timer timer;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    //generate the matrix the in the logique side( singleton)
    //start the update loop (timer.periodec with 30fps)
    timer = Timer.periodic(Duration(milliseconds: 30), (timer) {
      Game.getInstance().update();
      setState(() {
        Game.getInstance().update();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        color: const Color(0xff1f1f1f),
        child: SafeArea(
            child: (!Game.getInstance().issGameOver())
                ? (!Game.getInstance().isGamePaused())
                    ? _constructPlayPanel()
                    : Stack(
                        alignment: Alignment.center,
                        children: [
                          _constructPlayPanel(),
                          _constructPausePanel()
                        ],
                      )
                : Stack(
                    alignment: Alignment.center,
                    children: [
                      _constructPlayPanel(),
                      _constructGameOverPanel()
                    ],
                  )));
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused && Game.getInstance().isGameRunning())
      Game.getInstance().pauseGame();
  }

  Widget _constructPlayPanel() {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(
              color: Colors.black,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Level :   ",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "EightBitDragon"),
                          ),
                          Text(
                            Game.getInstance()?.level.toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "EightBitDragon"),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Score :   ",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "EightBitDragon"),
                          ),
                          Text(
                            Game.getInstance()?.score.toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "EightBitDragon"),
                          )
                        ],
                      ),
                    ],
                  ),
                  Container(
                      child: InkWell(
                         onTap: (){ Game.getInstance().pauseGame();},
                          child: Icon(
                    Icons.pause,
                    color: Colors.white,
                    size: 50,
                  )))
                ],
              )),
        ),
        Expanded(flex: 8, child: Grid()),
        Expanded(
          flex: 1,
          child: Container(
              color: const Color(0xff1f1f1f),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                      onTap: () {
                        Game.getInstance().moveLeft();
                      },
                      child: Container(
                        color: Colors.grey,
                        height: 50,
                        width: 50,
                        margin: EdgeInsets.symmetric(horizontal: 20),
                         child: Icon(Icons.arrow_back,color: Colors.white,)
                      )),
                  GestureDetector(
                      onTap: () {
                        Game.getInstance().moveDown();
                      },
                      child: Container(
                        color: Colors.grey,
                        height: 50,
                        width: 50,
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Icon(Icons.arrow_downward,color: Colors.white,),
                      )),
                  GestureDetector(
                      onTap: () {
                        Game.getInstance().rotateCurrentShape();
                      },
                      child: Container(
                        color: Colors.grey,
                        height: 50,
                        width: 50,
                        margin: EdgeInsets.symmetric(horizontal: 20),
                         child: Icon(Icons.rotate_right,color: Colors.white,)
                      )),
                  GestureDetector(
                      onTap: () {
                        Game.getInstance().moveRight();
                      },
                      child: Container(
                        color: Colors.grey,
                        height: 50,
                        width: 50,
                        margin: EdgeInsets.symmetric(horizontal: 20),
                         child: Icon(Icons.arrow_forward,color: Colors.white,)
                      )),
                ],
              )),
        ),
      ],
    );
  }

  Widget _constructGameOverPanel() {
    return LayoutBuilder(builder: (context, constraints) {
      return GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => StartScreen()));
          },
          child: Container(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            color: Color(0xaa000000),
            alignment: Alignment.center,
            child: Container(
              alignment: Alignment.center,
              width: constraints.maxWidth - 100,
              height: constraints.maxWidth / 2,
              decoration: BoxDecoration(
                  border: Border.all(width: 2.0, color: Colors.red),
                  color: Colors.black),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Game Over !",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "EightBitDragon",
                        fontSize: 20),
                  ),
                  Text(
                    "Score : ${Game.getInstance().score}",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "EightBitDragon",
                        fontSize: 14),
                  ),
                  Text(
                    "Tap to return to start screen",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "EightBitDragon",
                        fontSize: 10),
                  ),
                ],
              ),
            ),
          ));
    });
  }

  Widget _constructPausePanel() {
    return LayoutBuilder(builder: (context, constraints) {
      return GestureDetector(
          onTap: () {
            Game.getInstance().startGame();
          },
          child: Container(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            color: Color(0xaa000000),
            alignment: Alignment.center,
            child: Container(
              alignment: Alignment.center,
              width: constraints.maxWidth - 100,
              height: constraints.maxWidth / 2,
              decoration: BoxDecoration(
                  border: Border.all(width: 2.0, color: Colors.red),
                  color: Colors.black),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "PAUSED",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "EightBitDragon",
                        fontSize: 20),
                  ),
                  Text(
                    "Tap to resume game",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "EightBitDragon",
                        fontSize: 10),
                  ),
                ],
              ),
            ),
          ));
    });
  }
}
