import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tetris_game/logic/Game.dart';

class Grid extends StatefulWidget {
  final Color backgroundColor;
  final Color wallColor;
  final Color emptyCellColor;
  final double cellSpacing;
  final double cellRounded;
  final double ratio; // width / height

  Grid(
      {this.backgroundColor = Colors.black,
      this.wallColor = const Color(0xff1f1f1f),
      this.emptyCellColor = Colors.black,
      this.cellSpacing = .5,
      this.cellRounded = 5,
      this.ratio = 0.5});

  @override
  _GridState createState() => _GridState();
}

class _GridState extends State<Grid> {
  Timer timer;
  @override
  void initState() {
    super.initState();

    //generate the matrix the in the logique side( singleton)
    //start the update loop (timer.periodec with 30fps)
    timer = Timer.periodic(Duration(milliseconds: 30), (timer) {
      Game.getInstance().update();
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          color: widget.wallColor,
          child: Align(
              alignment: Alignment.center,
              child: AspectRatio(
                  aspectRatio: widget.ratio, child: _constractTable())));
    });
  }

  Widget _constractTable() {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      double height =
          constraints.maxHeight / Game.ROWS - widget.cellSpacing * 2;
      double width =
          constraints.maxWidth / Game.COLUMNS - widget.cellSpacing * 2;
      List<Container> cells;
      List<Row> rows = new List.filled(Game.ROWS, null);
      Shape _currentShape = Game.getInstance().getCurrentShape();
      Decoration decoration;
      for (int i = 0; i < Game.ROWS; ++i) {
        cells = new List.filled(Game.COLUMNS, null);
        for (int c = 0; c < Game.COLUMNS; ++c) {
          if (_currentShape != null &&
              Game.getInstance().isCoveredByShape(
                  i - Game.getInstance().getCurrentShapePosy(),
                  c - Game.getInstance().getCurrentShapePosx())) {
            decoration = BoxDecoration(
                color: _currentShape.color,
                borderRadius:
                    BorderRadius.all(Radius.circular(widget.cellRounded)));
          } else {
            decoration = BoxDecoration(
                color: (Game.getInstance().getCell(i, c).isFilled)
                    ? Game.getInstance().getCell(i, c).color
                    : widget.backgroundColor,
                borderRadius: (Game.getInstance().getCell(i, c).isFilled)
                    ? BorderRadius.all(Radius.circular(widget.cellRounded))
                    : null);
          }
          cells[c] = Container(
            decoration: decoration,
            height: height,
            width: width,
            margin: EdgeInsets.all(widget.cellSpacing),
          );
        }
        rows[i] = Row(
          children: cells,
          mainAxisSize: MainAxisSize.max,
        );
      }

      return Container(
          color: widget.backgroundColor,
          child: Column(
            children: rows,
            mainAxisSize: MainAxisSize.max,
          ));
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }
}
