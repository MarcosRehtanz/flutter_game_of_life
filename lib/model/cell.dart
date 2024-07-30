import 'dart:math';

class Cell {
  bool _isAlive;
  
  Cell.fromRandomLifeStatus() : _isAlive = Random().nextInt(10) == 0;

  Cell(this._isAlive);

  bool get isAlive => _isAlive;
  die() => _isAlive = false;
  revive() => _isAlive = true;

  bool operator(otherCell) => otherCell is Cell && otherCell.isAlive == isAlive;
  
}