import 'dart:async';
import 'package:flutter/material.dart';
import 'package:game_of_life/model/cell.dart';

class Board extends StatefulWidget {
  const Board({super.key, required int column, required int row})
      : _column = column,
        _row = row,
        _initialCells = null;

  final int _column;
  final int _row;
  final List<List<Cell>>? _initialCells;

  Board.fromPredefinedCells({super.key, List<List<Cell>>? cells})
      : assert(cells!.isNotEmpty && cells.every((row) => row.isNotEmpty)),
        _column = cells!.length,
        _row = cells[0].length,
        _initialCells = cells;

  @override
  State<Board> createState() => BoardState();
}

class BoardState extends State<Board> {
  late List<List<Cell>> _cells;
  late Timer _timer;
  late bool _isPlaying = false;
  late IconData _iconPlayPause = Icons.play_arrow;

  List<List<Cell>> get cells => _cells;
  bool get isPlaying => _isPlaying;
  IconData get iconPlayPause => _iconPlayPause;

  @override
  void initState() {
    resetCells();
    // startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  togglePlayPause() {
    if (_isPlaying) {
      setState(() {
        _isPlaying = false;
        _iconPlayPause = Icons.play_arrow;
      });
      startTimer();
    } else {
      setState(() {
        _isPlaying = true;
        _iconPlayPause = Icons.pause;
      });
      stopTimer();
    }
  }

  stopTimer() {
    _timer.cancel();
  }

  startTimer() {
    setState(() {
      _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
        updateCells();
      });
    });
  }

  resetCells() {
    setState(() {
      _cells = widget._initialCells ??
          List.generate(
              widget._row,
              (row) => List.generate(
                  widget._column, (cell) => Cell.fromRandomLifeStatus()));
    });
  }

  clearCells() {
    setState(() {
      _cells = widget._initialCells ??
          List.generate(widget._row,
              (row) => List.generate(widget._column, (cell) => Cell(false)));
    });
  }

  updateCells() {
    List<List<Cell>> updateCells = List.generate(
        _cells.length,
        (row) => List.generate(_cells[row].length, (col) {
              bool top = row > 0;
              bool bot = row < _cells.length - 1;
              bool left = col > 0;
              bool right = col < _cells[row].length - 1;

              List<Cell> list = [];
              if (top) {
                list.add(_cells[row - 1][col]);
                if (left) {
                  list.add(_cells[row - 1][col - 1]);
                }
                if (right) {
                  list.add(_cells[row - 1][col + 1]);
                }
              }
              if (left) {
                list.add(_cells[row][col - 1]);
              }
              if (right) {
                list.add(_cells[row][col + 1]);
              }
              if (bot) {
                list.add(_cells[row + 1][col]);
                if (left) {
                  list.add(_cells[row + 1][col - 1]);
                }
                if (right) {
                  list.add(_cells[row + 1][col + 1]);
                }
              }
              int count = 0;
              bool isAlive = _cells[row][col].isAlive;
              for (var cell in list) {
                cell.isAlive ? ++count : count;
              }
              if (isAlive) {
                if (count < 2 || count > 3) {
                  return Cell(false);
                }
              } else {
                if (count == 3) {
                  return Cell(true);
                }
              }
              return Cell(_cells[row][col].isAlive);
            }));

    for (var row = 0; row < _cells.length; row++) {
      bool top = row > 0;
      bool bot = row < _cells.length - 1;
      for (var col = 0; col < _cells[row].length; col++) {
        bool left = col > 0;
        bool right = col < _cells[row].length - 1;
        List<Cell> list = [];
        if (top) {
          list.add(_cells[row - 1][col]);
          if (left) {
            list.add(_cells[row - 1][col - 1]);
          }
          if (right) {
            list.add(_cells[row - 1][col + 1]);
          }
        }
        if (left) {
          list.add(_cells[row][col - 1]);
        }
        if (right) {
          list.add(_cells[row][col + 1]);
        }
        if (bot) {
          list.add(_cells[row + 1][col]);
          if (left) {
            list.add(_cells[row + 1][col - 1]);
          }
          if (right) {
            list.add(_cells[row + 1][col + 1]);
          }
        }
        int count = 0;
        for (var cell in list) {
          cell.isAlive ? ++count : count;
        }
        if (_cells[row][col].isAlive) {
          if (count < 2 || count > 3) {
            updateCells[row][col].die();
          }
        } else {
          if (count == 3) {
            updateCells[row][col].revive();
          }
        }
      }
    }
    setState(() {
      _cells = updateCells;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var row in _cells)
          Row(children: [
            for (var cell in row)
              GestureDetector(
                  onTap: () => {
                        setState(() {
                          cell.invert();
                        })
                      },
                  child: Container(
                      width: 10.0,
                      height: 10.0,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 0.5),
                        color: cell.isAlive ? Colors.blue : Colors.white,
                      )))
          ])
      ],
    );
  }
}
