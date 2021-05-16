import 'dart:ui';

import 'package:flutter/material.dart';

enum GameState {
  notStarted,
  running,
  paused,
  gameOver,
}

class Cell {
  bool isFilled = false;
  Color color = Colors.black;
}

class Shape {
  Color color = Colors.red;
  List<bool> _data;
  int _lines;
  int _columns;
  int _shapeCode;

  static Shape createSquare() {
    Shape ret = new Shape._(2, 2);
    ret._shapeCode = 1;
    ret.initShapeData();
    ret.color = Colors.yellow;
    return ret;
  }

  static Shape createLigne() {
    Shape ret = new Shape._(1, 4);
    ret._shapeCode = 2;
    ret.initShapeData();
    ret.color = Colors.cyan;
    return ret;
  }

  static Shape createInvertedTShape() {
    Shape ret = new Shape._(2, 3);
    ret._shapeCode = 3;
    ret.initShapeData();
    ret.color = Colors.pink;
    return ret;
  }

  static Shape createSShape() {
    Shape ret = new Shape._(2, 3);
    ret._shapeCode = 4;
    ret.initShapeData();
    ret.color = Colors.red;
    return ret;
  }

  static Shape createMirroredSShape() {
    Shape ret = new Shape._(2, 3);
    ret._shapeCode = 5;
    ret.initShapeData();
    ret.color = Colors.lightGreenAccent[400];
    return ret;
  }

  static Shape createLShape() {
    Shape ret = new Shape._(2, 3);
    ret._shapeCode = 6;
    ret.initShapeData();
    ret.color = Colors.blue[900];
    return ret;
  }

  static Shape createMirroredLShape() {
    Shape ret = new Shape._(2, 3);
    ret._shapeCode = 7;
    ret.initShapeData();
    ret.color = Colors.orange;
    return ret;
  }

  Shape._(int lines, int columns) {
    _lines = lines;
    _columns = columns;
    _data = new List.filled(_lines * _columns, false);
    _shapeCode = 0; //noShape ;
  }
  void initShapeData() {
    switch (_shapeCode) {
      case 1:
        _data[0] = true;
        _data[1] = true;
        _data[2] = true;
        _data[3] = true;
        break;
      case 2:
        _data[0] = true;
        _data[1] = true;
        _data[2] = true;
        _data[3] = true;
        break;
      case 3:
        _data[0] = false;
        _data[1] = true;
        _data[2] = false;
        _data[3] = true;
        _data[4] = true;
        _data[5] = true;
        break;
      case 4:
        _data[0] = false;
        _data[1] = true;
        _data[2] = true;
        _data[3] = true;
        _data[4] = true;
        _data[5] = false;
        break;
      case 5:
        _data[0] = true;
        _data[1] = true;
        _data[2] = false;
        _data[3] = false;
        _data[4] = true;
        _data[5] = true;
        break;
      case 6:
        _data[0] = true;
        _data[1] = false;
        _data[2] = false;
        _data[3] = true;
        _data[4] = true;
        _data[5] = true;
        break;
      case 7:
        _data[0] = false;
        _data[1] = false;
        _data[2] = true;
        _data[3] = true;
        _data[4] = true;
        _data[5] = true;
        break;
    }
  }

  void rotateClockWise() {
    //TODO transpose _data content
  }
  int getRows(){
    return this._lines ;
  }
  int getColumns(){
    return this._columns ;
  }
  bool getCellValue (int row , column){
    if(row < 0 || row >=_lines)
      return false  ;
    if(column <0 || column>= _columns){
      return false ;
    }
    return _data[row * _lines + column];
  }
}

class Game {
  static const int ROWS = 20;
  static const int COLUMNS = 10;

  double _speed;
  List<Cell> _matrix;
  int level;
  int score;
  GameState _state;
  List<Shape> _shapes = List.filled(7, null);

  Shape _currentShape = null;
  int _posx = 0, _posy = 0;

  static Game _instance;
  static Game getInstance() {
    if (_instance == null) {
      _instance = new Game._();
    }
    return _instance;
  }

  Game._() {
    this._speed = 10;
    this._matrix = new List.filled(ROWS * COLUMNS, null); // 20 row by 10 column
    for (int i = 0; i < ROWS * COLUMNS; ++i) {
      _matrix[i] = new Cell();
    }
    _shapes[0] = Shape.createLigne();
    _shapes[1] = Shape.createInvertedTShape();
    _shapes[2] = Shape.createSquare();
    _shapes[3] = Shape.createSShape();
    _shapes[4] = Shape.createMirroredSShape();
    _shapes[5] = Shape.createLShape();
    _shapes[6] = Shape.createMirroredLShape();
    _state=GameState.notStarted ;
  }
  bool issGameOver() {
    return _state == GameState.gameOver ? true : false;
  }

  void update() {
    switch (_state) {
      case GameState.notStarted:
        break;
      case GameState.paused:
        break;
      case GameState.running:
        if (_currentShape == null) {
          _currentShape = _shapes[0];
          _currentShape.initShapeData();
          _posx = (COLUMNS/2 - _currentShape._columns /2).toInt(); _posy = 0 ;
          print("shape created and initialized ");
          print ("shape pos x:$_posx  y:$_posy");
          print("grid size rows : $ROWS  columns: $COLUMNS ");
        }else{
          //TODO check if shape move another step down
        }
        break;
      case GameState.gameOver:
        break;
    }
  }

  void startGame() {
    if (_state == GameState.notStarted) _state = GameState.running;
  }

  Cell getCell(int row, int column) {
    if (_matrix == null)
      return null;
    else if (row < 0 || row >= ROWS)
      return null;
    else if (column < 0 || column >= COLUMNS) return null;

    return _matrix[row * 10 + column];
  }

  Shape getCurrentShape(){return _currentShape ;}
  int getCurrentShapePosx(){return _posx ;}
  int getCurrentShapePosy(){return _posy ;}
  void rotateCurrentShape() {
     //TODO check if shape can rotate
     
     //if true  rotate
     _currentShape?.rotateClockWise();
  }
  void moveLeft() {

  }
  void moveRight() {

  }
  void dropShape() {

  }

  bool isCoveredByShape(int r, int c) {
    if(r<0 || c < 0)
      return false ;
    if(r>_currentShape.getRows() || c> _currentShape.getColumns())
      return false ;
    return _currentShape.getCellValue(r,c);
  }
}
