import 'dart:math';
import 'Shape.dart';

enum GameState {
  notStarted,
  running,
  paused,
  gameOver,
}
enum KEY { ROTATE, LEFT, RIGHT, DOWN }

class Game {
  static const int ROWS = 20;
  static const int COLUMNS = 10;

  List<Cell> _matrix;
  int _level = 1;
  int _score = 0;
  int get score {
    return _score;
  }

  int get level {
    return _level;
  }

  int _numClearedLines = 0;
  int _requiredLinesforNextLevel = 0;
  GameState _state;
  List<Shape> _shapes = List.filled(7, null);
  List<bool> _keyState = List.filled(4, false /*pressed*/);
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

  bool isGameRunning() {
    return _state == GameState.running ? true : false;
  }

  bool isGamePaused() {
    return _state == GameState.paused ? true : false;
  }

  void update() {
    switch (_state) {
      case GameState.notStarted:
      case GameState.paused:
      case GameState.gameOver:
        break;
      case GameState.running:
        _ticks++;
        _updateShapePosition();
        if (_ticks >= _waitTimeBetweenFrames) {
          _ticks = 0;
          if (_currentShape == null) {
            _currentShape = _shapes[_rng.nextInt(_shapes.length - 1)];
            _currentShape.initShapeData();
            _posx = (COLUMNS / 2 - _currentShape.columns / 2).toInt();
            _posy = -(_currentShape.getRows() ~/ 2);
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
    }
  }

  void startGame() {
    if (_state == GameState.notStarted || _state == GameState.paused)
      _state = GameState.running;
    else if (_state == GameState.gameOver) {
      for (int i = 0; i < ROWS * COLUMNS; ++i) {
        _matrix[i].isFilled = false;
      }
      _state = GameState.running;
    }
  }

  void pauseGame() {
    if (_state == GameState.running) _state = GameState.paused;
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
    if (_canRotateCurrentShape()) {
      _posy += (_currentShape.getRows() - _currentShape.getColumns()) ~/ 2;
      _posx += (_currentShape.getColumns() - _currentShape.getRows()) ~/ 2;
      if (_posx < 0) _posx = 0;
      if (_posx + _currentShape.getRows() > COLUMNS)
        _posx = COLUMNS - _currentShape.getRows();

      _currentShape?.rotateClockWise();
    }
  }

  void keyPressed(KEY key) {
    switch (key) {
      case KEY.ROTATE:
        _keyState[0] = true;
        break;
      case KEY.LEFT:
        _keyState[1] = true;
        break;
      case KEY.RIGHT:
        _keyState[2] = true;
        break;
      case KEY.DOWN:
        _keyState[3] = true;
        break;
    }
  }

  void keyReleased(KEY key) {
    switch (key) {
      case KEY.ROTATE:
        _keyState[0] = false;
        break;
      case KEY.LEFT:
        _keyState[1] = false;
        break;
      case KEY.RIGHT:
        _keyState[2] = false;
        break;
      case KEY.DOWN:
        _keyState[3] = false;
        break;
    }
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

  bool _checkForObstacle(int direction) {
    switch (direction) {
      case -1:
        if (_posx == 0) // the left wall is consideraed as an obstacle
          return true;
        //else check if encountered a filled cell
        for (int row = _currentShape.getRows() - 1; row >= 0; row--) {
          for (int col = 0; col < _currentShape.getColumns(); col++)
            if (_currentShape.getCellValue(row, col) &&
                getCell(_posy + row, _posx - 1 + col) != null &&
                getCell(_posy + row, _posx - 1 + col).isFilled) return true;
        }
        break;
      case 0:
        if (_posy + _currentShape.getRows() ==
            ROWS) // the right wall is consideraed as an obstacle
          return true;

        for (int col = _currentShape.getColumns() - 1; col >= 0; col--) {
          for (int row = _currentShape.getRows() - 1; row >= 0; row--)
            if (_currentShape.getCellValue(row, col) &&
                getCell(_posy + row + 1, _posx + col) != null &&
                getCell(_posy + row + 1, _posx + col).isFilled) return true;
        }
        break;
      case 1:
        if (_posx + _currentShape.getColumns() ==
            COLUMNS) // the right wall is consideraed as an obstacle
          return true;

        for (int i = _currentShape.getRows() - 1; i >= 0; i--) {
          for (int j = 0 - 1; j < _currentShape.getColumns(); ++j)
            if (_currentShape.getCellValue(i, j) &&
                getCell(_posy + i, _posx + _currentShape.getColumns() - j) !=
                    null &&
                getCell(_posy + i, _posx + _currentShape.getColumns() - j)
                    .isFilled) return true;
        }
        break;
    }
    //any other case considered a no obstacle encountered
    return false;
  }

  bool _canRotateCurrentShape() {
    if (_currentShape != null) {
      int newPosy =
          _posy + (_currentShape.getRows() - _currentShape.getColumns()) ~/ 2;
      int newPosx =
          _posx + (_currentShape.getColumns() - _currentShape.getRows()) ~/ 2;

      if (newPosx < 0) newPosx = 0;
      if (newPosx + _currentShape.getRows() > COLUMNS)
        newPosx = COLUMNS - _currentShape.getRows();

      if (newPosy + _currentShape.getColumns() > ROWS) return false;

      for (int col = 0; col < _currentShape.getRows(); col++) {
        for (int row = 0; row < _currentShape.getColumns(); row++) {
          if (_currentShape.getCellValue(
                  _currentShape.getRows() - row - 1, col) &&
              getCell(newPosy + row, newPosx + col) != null &&
              getCell(newPosy + row, newPosx + col).isFilled) return false;
        }
      }
    }
    return true;
  }

  void _updateLevelAndScore() {
    int linesToCheck = ROWS;
    bool clear;
    int numLines = 0;
    for (int index = 0; index < linesToCheck;) {
      clear = true;
      for (int c = 0; c < COLUMNS; c++) {
        if (!getCell(ROWS - index - 1, c).isFilled) {
          clear = false;
          break;
        }
      }
      if (clear) {
        numLines++;
        //clear line
        for (int r = 1; r < linesToCheck; r++) {
          for (int c = 0; c < COLUMNS; c++) {
            _matrix[(ROWS - index - r) * COLUMNS + c].isFilled =
                _matrix[(ROWS - index - r - 1) * COLUMNS + c].isFilled;
            _matrix[(ROWS - index - r) * COLUMNS + c].color =
                _matrix[(ROWS - index - r - 1) * COLUMNS + c].color;
          }
        }
        linesToCheck--;
      } else {
        index++;
      }
      switch (numLines) {
        case 1:
          _score += 40 * _level;
          break;
        case 2:
          _score += 100 * _level ;
          break;
        case 3:
          _score += 300 * _level ;
          break;
        case 4:
          _score += 1200 * _level ;
          break;
      }
      _numClearedLines += numLines;
      if (_numClearedLines >= _requiredLinesforNextLevel) {
        _level++;
        _numClearedLines -= _requiredLinesforNextLevel;
        _requiredLinesforNextLevel = _level * 5;
      }
    }
  }

  void _updateShapePosition() {
    if (_currentShape != null) {
      if (_keyState[0] == true) rotateCurrentShape();
      if (_keyState[1] == true && !_checkForObstacle(-1)) _posx--;
      if (_keyState[2] == true && !_checkForObstacle(1)) _posx++;
      if (_keyState[3] == true && !_checkForObstacle(0)) _posy++;
    }
  }
}
