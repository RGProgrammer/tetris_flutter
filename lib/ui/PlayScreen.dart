import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'Grid.dart';

class PlayScreen extends StatefulWidget {
  @override
  _PlayScreenState createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> this.setState(() {
        
      }),
      child :  Material(
                  color: const Color(0xff1f1f1f),
                  child: SafeArea(
                      child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          color: Colors.black,
                        ),
                      ),
                      Expanded(flex: 8, child: Grid()),
                      /*Expanded(
                        flex: 1,
                        child: Container(
                          color: const Color(0xff1f1f1f),
                        ),
                      ),*/
                    ],
                  ))));
  }
  
}