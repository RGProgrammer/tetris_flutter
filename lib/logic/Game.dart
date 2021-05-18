import 'dart:math';
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
  int getRows() {
    return this._lines;
  }

  int getColumns() {
    return this._columns;
  }

  bool getCellValue(int row, column) {
    if (row < 0 || row >= _lines) return false;
    if (column < 0 || column >= _columns) {
      return false;
    }
    return _data[row * _columns + column];
  }
}

class Game {
  static const int ROWS = 20;
  static const int COLUMNS = 10;

  List<Cell> _matrix;
  int level = 1;
  int score = 0;
  GameState _state;
  List<Shape> _shapes = List.filled(7, null);

  Shape _currentShape;
  int _posx = 0, _posy = 0;
  int _waitTimeBetweenFrames = 40;
  int _ticks = 0;
  Random _rng;

  static Game _instance;
  static Game getInstance() {
    if (_instance == null) {
      _instance = new Game._();
    }
    return _instance;
  }

  Game._() {
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
    _state = GameState.notStarted;
    _rng = new Random();
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
        _ticks++;
        if (_ticks >= _waitTimeBetweenFrames) {
          _ticks = 0;
          if (_currentShape == null) {
            _currentShape = _shapes[_rng.nextInt(_shapes.length - 1)];
            _currentShape.initShapeData();
            _posx = (COLUMNS / 2 - _currentShape._columns / 2).toInt();
            _posy =0; //-(_currentShape.getRows() / 2).toInt();
            if (_checkForObstacle(0)) {
              _state = GameState.gameOver;
            }
          } else {
            if (_currentShape.getRows() + _posy >= ROWS ||
                _checkForObstacle(0)) {
              _insertCurrentShape();
              _currentShape = null;
              _updateLevelAndScore();
            } else {
              _posy += 1;
            }
          }
        }
        break;
      case GameState.gameOver:
        break;
    }
  }

  void startGame() {
    if (_state == GameState.notStarted)
      _state = GameState.running;
    else if (_state == GameState.gameOver) {
      for (int i = 0; i < ROWS * COLUMNS; ++i) {
        _matrix[i].isFilled = false;
      }
      _state = GameState.running;
    }
  }

  Cell getCell(int row, int column) {
    if (_matrix == null)
      return null;
    else if (row < 0 || row >= ROWS)
      return null;
    else if (column < 0 || column >= COLUMNS) return null;

    return _matrix[row * 10 + column];
  }

  Shape getCurrentShape() {
    return _currentShape;
  }

  int getCurrentShapePosx() {
    return _posx;
  }

  int getCurrentShapePosy() {
    return _posy;
  }

  void rotateCurrentShape() {
    if (_canRotateCurrentShape()) _currentShape?.rotateClockWise();
  }

  void moveLeft() {
    if (_currentShape != null && !_checkForObstacle(-1)) _posx--;
  }

  void moveRight() {
    if (_currentShape != null && !_checkForObstacle(1)) _posx++;
  }

  void moveDown() {
    if (_currentShape != null && !_checkForObstacle(0)) _posy++;
  }

  bool isCoveredByShape(int r, int c) {
    if (r < 0 || c < 0) return false;
    if (r > _currentShape.getRows() || c > _currentShape.getColumns())
      return false;
    return _currentShape.getCellValue(r, c);
  }

  void _insertCurrentShape() {
    for (int row = 0; row < _currentShape.getRows(); row++) {
      for (int col = 0; col < _currentShape.getColumns(); col++) {
        if (_currentShape.getCellValue(row, col)) {
          _matrix[COLUMNS * (_posy + row) + _posx + col].isFilled =
              _currentShape.getCellValue(row, col);
          _matrix[COLUMNS * (_posy + row) + _posx + col].color =
              _currentShape.color;
        }
      }
    }
  }

  //TODO implementations
  bool _checkForObstacle(int direction) {
    switch (direction) {
      case -1:
        if (_posx == 0) // the left wall is consideraed as an obstacle
          return true;
        //else check if encountered a filled cell
        for (int i = _currentShape.getRows() - 1; i >= 0; i--) {
          for (int j = 0; j < _currentShape.getColumns(); j++)
            if (_currentShape.getCellValue(i, j) &&
                getCell(_posy + i, _posx - 1 + j).isFilled) return true;
        }
        break;
      case 0:
        if (_posy + _currentShape.getRows() ==
            ROWS) // the right wall is consideraed as an obstacle
          return true;

        for (int i = _currentShape.getColumns() - 1; i >= 0; i--) {
          if (_currentShape.getCellValue(_currentShape.getRows() - 1, i) &&
              getCell(_posy + _currentShape.getRows(), _posx + i).isFilled)
            return true;
        }
        break;
      case 1:
        if (_posx + _currentShape.getColumns() ==
            COLUMNS) // the right wall is consideraed as an obstacle
          return true;

        for (int i = _currentShape.getRows() - 1; i >= 0; i--) {
          for (int j = 0 - 1; j < _currentShape.getColumns(); ++j)
            if (_currentShape.getCellValue(i, j) &&
                getCell(_posy + i, _posx + _currentShape.getColumns() - j)
                    .isFilled) return true;
        }
        break;
    }
    //any other case considered a no obstacle encountered
    return false;
  }

  bool _canRotateCurrentShape() {}

  void _updateLevelAndScore() {
    //check for lines
  }
}
