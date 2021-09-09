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
    //start the update loop (timer.periodec with 30fps)
    timer = Timer.periodic(Duration(milliseconds: 30), (timer) {
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
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
            flex: 8,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(flex: 8,child:Grid(wallColor: Colors.white,)),
                Expanded(
                    flex: 3,
                    child: Container(
                        color: Color(0x0ff173f5f),
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 5),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    child: Text(
                                      "Level :   ",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "EightBitDragon"),
                                    )),
                                Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    child: Text(
                                      Game.getInstance()?.level.toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "EightBitDragon"),
                                    )),
                                Container(height: 20),
                                Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    child: Text(
                                      "Score :   ",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "EightBitDragon"),
                                    )),
                                Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    child: Text(
                                        Game.getInstance()?.score.toString(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: "EightBitDragon"))),
                              ],
                            )))),
              ],
            )),
        Expanded(
          flex: 2,
          child: Container(
              child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                  flex: 4,
                  child: Container(
                      alignment: Alignment.center,
                      child: AspectRatio(
                          aspectRatio: 2,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                          height: constraints.maxHeight / 2,
                                          width: constraints.maxWidth,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                  flex: 1,
                                                  child: FittedBox(
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            Game.getInstance()
                                                                .moveLeft();
                                                          },
                                                          child: Container(
                                                              decoration: BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: Colors
                                                                      .yellow),
                                                              child: Icon(
                                                                Icons
                                                                    .arrow_left_sharp,
                                                                color: Colors
                                                                    .black,
                                                              ))))),
                                              Expanded(
                                                  flex: 1, child: Container()),
                                              Expanded(
                                                  flex: 1,
                                                  child: FittedBox(
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            Game.getInstance()
                                                                .moveRight();
                                                          },
                                                          child: Container(
                                                              decoration: BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: Colors
                                                                      .yellow),
                                                              child: Icon(
                                                                Icons
                                                                    .arrow_right_sharp,
                                                                color: Colors
                                                                    .black,
                                                              ))))),
                                            ],
                                          )),
                                      Container(
                                          height: constraints.maxHeight / 2,
                                          width: constraints.maxWidth,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                  flex: 1, child: Container()),
                                              Expanded(
                                                  flex: 1,
                                                  child: FittedBox(
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            Game.getInstance()
                                                                .moveDown();
                                                          },
                                                          child: Container(
                                                              decoration: BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: Colors
                                                                      .yellow),
                                                              child: Icon(
                                                                Icons
                                                                    .arrow_drop_down_sharp,
                                                                color: Colors
                                                                    .black,
                                                              ))))),
                                              Expanded(
                                                  flex: 1, child: Container()),
                                            ],
                                          ))
                                    ]);
                              },
                            ),
                          )))),
              Expanded(
                  flex: 2,
                  child: Container(
                    child: AspectRatio(
                        aspectRatio: 1,
                        child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Container(
                                color: Colors.yellow,
                                child: InkWell(
                                    onTap: () {
                                      Game.getInstance().pauseGame();
                                    },
                                    child: Icon(
                                      Icons.pause,
                                      color: Colors.black,
                                    ))))),
                  )),
              Expanded(
                  flex: 4,
                  child: Container(
                    alignment: Alignment.center,
                    child: Padding(
                        padding: EdgeInsets.all(20),
                        child: GestureDetector(
                            onTap: () {
                              Game.getInstance().rotateCurrentShape();
                            },
                            child: Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.yellow),
                                child: Icon(Icons.rotate_left_sharp)))),
                  )),
            ],
          )),
        )
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
