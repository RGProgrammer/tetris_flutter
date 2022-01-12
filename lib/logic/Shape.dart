import 'package:flutter/material.dart';

class Cell {
  bool isFilled = false;
  Color color = Colors.black;
}

class Shape {
  Color color = Colors.red;
  List<bool> _data;
  int _lines;
  int get lines { return _lines ;}
  int _columns;
  int get columns {return _columns ;}
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

  static List<bool> _useToRotate = List.filled(6, false);
  Shape._(int lines, int columns) {
    _lines = lines;
    _columns = columns;
    _data = new List.filled(_lines * _columns, false);
    _shapeCode = 0; //noShape ;
  }
  void initShapeData() {
    switch (_shapeCode) {
      case 1:
        _lines = 2;
        _columns = 2;
        _data[0] = true;
        _data[1] = true;
        _data[2] = true;
        _data[3] = true;
        break;
      case 2:
        _lines = 1;
        _columns = 4;
        _data[0] = true;
        _data[1] = true;
        _data[2] = true;
        _data[3] = true;
        break;
      case 3:
        _lines = 2;
        _columns = 3;
        _data[0] = false;
        _data[1] = true;
        _data[2] = false;
        _data[3] = true;
        _data[4] = true;
        _data[5] = true;
        break;
      case 4:
        _lines = 2;
        _columns = 3;
        _data[0] = false;
        _data[1] = true;
        _data[2] = true;
        _data[3] = true;
        _data[4] = true;
        _data[5] = false;
        break;
      case 5:
        _lines = 2;
        _columns = 3;
        _data[0] = true;
        _data[1] = true;
        _data[2] = false;
        _data[3] = false;
        _data[4] = true;
        _data[5] = true;
        break;
      case 6:
        _lines = 2;
        _columns = 3;
        _data[0] = true;
        _data[1] = false;
        _data[2] = false;
        _data[3] = true;
        _data[4] = true;
        _data[5] = true;
        break;
      case 7:
        _lines = 2;
        _columns = 3;
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
    if (_lines == _columns) return;

    int t;
    if (_lines == 1 || _columns == 1) {
      t = _lines;
      _lines = _columns;
      _columns = t;
      return;
    }
  print(_data);
    for (int col = 0, index = 0; col < _columns; col++) {
      for (int row = _lines-1 ; row>=0; row--) {
        _useToRotate[index] =
            _data[row* _columns + col];
            index++ ;
      }
    }
    print(_useToRotate);
      t = _lines;
      _lines = _columns;
      _columns = t;
    for (int index = 0; index < _columns * _lines; index++) {
      _data[index] = _useToRotate[index];
    }
   
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