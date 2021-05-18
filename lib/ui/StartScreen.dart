import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tetris_game/logic/Game.dart';
import 'package:tetris_game/ui/PlayScreen.dart';

import 'Grid.dart';

class StartScreen extends StatefulWidget {
  final Audio startSound = Audio("assets/sound/start.mp3", playSpeed: 1.2);
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return Material (child :GestureDetector(
        onTap: () {
          AssetsAudioPlayer.playAndForget(
            widget.startSound,
          );
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) =>PlayScreen()));
                  Game.getInstance().startGame();
        },
        child: Container(
            color: Colors.black,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Tetris",
                  maxLines: 1,
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 60,
                      fontFamily: "EightBitDragon"),
                ),
                Padding(
                    child: SvgPicture.asset("assets/tetris.svg"),
                    padding: EdgeInsets.symmetric(horizontal: 50)),
                Text(
                  "Tap to Start",
                  maxLines: 1,
                  style: TextStyle(
                      color: Colors.white, fontFamily: "EightBitDragon"),
                ),
              ],
            ))));
  }
}
