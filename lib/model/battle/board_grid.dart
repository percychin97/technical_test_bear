import 'dart:math';
import 'package:flutter/material.dart';
import 'package:technical_test_bear/model/battle/circle_item.dart';

class BoardGrid {
  final int height;
  final int width;
  List<List<CircleItem>> grid;

  BoardGrid.random(this.height, this.width, {this.grid = const []})
      : super() {
    grid = _randomGrid();
  }

  List<List<CircleItem>> _randomGrid() {
    final List<List<CircleItem>> grid = List.generate(
        height,
            (_) => List.generate(width, (_) => CircleItem(CircleVariant.red), growable: false),
        growable: false
    );
    final Random i = Random();

    for (int h = 0; h < height; h++) {
      List<CircleItem> row = [];
      for (int w = 0; w < width; w++) {
        CircleVariant newVariant;
        bool isValid = false;
        do {
          isValid = true;
          newVariant = CircleVariant.values[i.nextInt(5)];

          // Check the last two in the row if w >= 2
          if (w >= 2 && grid[h][w-1].variant == newVariant && grid[h][w-2].variant == newVariant) {
            isValid = false;
          }

          // Check the last two in the column if h >= 2
          if (isValid && h >= 2 && grid[h-1][w].variant == newVariant && grid[h-2][w].variant == newVariant) {
            isValid = false;
          }
        } while (!isValid); // Keep looping until a valid variant is found

        grid[h][w] = CircleItem(newVariant);
      }
    }

    return grid;
  }

  bool isRowSolvable(int row){
    bool isSolvable = false;

    for (int w = 0; w < width; w++) {
      CircleVariant circleVariant = grid[row][w].variant;
      if (w >= 2 && grid[row][w-1].variant == circleVariant && grid[row][w-2].variant == circleVariant) {
        isSolvable = true;
        break;
      }
    }
    return isSolvable;
  }

  bool isColumnSolvable(int column){
    bool isSolvable = false;

    for (int h = 0; h < height; h++) {
      CircleVariant circleVariant = grid[h][column].variant;
      if (h >= 2 && grid[h-1][column].variant == circleVariant && grid[h-2][column].variant == circleVariant) {
        isSolvable = true;
        break;
      }
    }
    return isSolvable;
  }

  void swapCircles(int firstCircleX, int firstCircleY, int secondCircleX, int secondCircleY) {
    if(firstCircleX>width||secondCircleX>width||firstCircleY>height||secondCircleY>height)return;

    performSwap(){
      final firstCircleVariant = grid[firstCircleX][firstCircleY];
      final secondCircleVariant = grid[secondCircleX][secondCircleY];
      grid[secondCircleX][secondCircleY] = firstCircleVariant;
      grid[firstCircleX][firstCircleY] = secondCircleVariant;
    }

    /// CHECK IF IS NEIGHBOUR ROW
    if(firstCircleX == secondCircleX){
      if(firstCircleY == secondCircleY - 1 || firstCircleY == secondCircleY + 1){
        performSwap();
        return;
      }
    }

    /// CHECK IF IS NEIGHBOUR COLUMN
    if(firstCircleY == secondCircleY){
      if(firstCircleX == secondCircleX - 1 || firstCircleX == secondCircleX + 1){
        performSwap();
        return;
      }
    }

    debugPrint('You can only swap with your adjacent grid!');
  }

  void clearRow(int row){
    List<int> clearingList = [];
    for (int w = 0; w < width; w++) {
      CircleVariant circleVariant = grid[row][w].variant;
      if (w >= 2 && grid[row][w-1].variant == circleVariant && grid[row][w-2].variant == circleVariant) {
        if(!clearingList.contains(w))clearingList.add(w);
        if(!clearingList.contains(w-1))clearingList.add(w-1);
        if(!clearingList.contains(w-2))clearingList.add(w-2);
      }
    }
    for(final clearIndex in clearingList){
      grid[row][clearIndex] = CircleItem(CircleVariant.solved);
    }
  }

  void clearColumn(int column){
    List<int> clearingList = [];
    for (int h = 0; h < height; h++) {
      CircleVariant circleVariant = grid[h][column].variant;
      if (h >= 2 && grid[h-1][column].variant == circleVariant && grid[h-2][column].variant == circleVariant) {
        if(!clearingList.contains(h))clearingList.add(h);
        if(!clearingList.contains(h-1))clearingList.add(h-1);
        if(!clearingList.contains(h-2))clearingList.add(h-2);
      }
    }
    for(final clearIndex in clearingList){
      grid[clearIndex][column] = CircleItem(CircleVariant.solved);
    }
  }


  void refill() {
    final i = Random();
    for (var x = height - 1; x >= 0; x--) {
      for (var y = width -1; y >= 0; y--) {
        if (grid[x][y].variant == CircleVariant.solved && x > 0) {
          grid[x][y] = CircleItem(grid[x-1][y].variant);
          grid[x-1][y] = CircleItem(CircleVariant.solved);
        }
      }
    }

    /// AFTER RUN THROUGH WHOLE FALL DOWN THING, RANDOMLY FILL REMAINING GRIDS
    for (int h = 0; h < height; h++) {
      for (int w = 0; w < width; w++) {
        CircleVariant newVariant = CircleVariant.values[i.nextInt(5)];
        if(grid[h][w].variant == CircleVariant.solved)grid[h][w] = CircleItem(newVariant);
      }
    }
  }


  void autoClearMatch(Function refreshUI) async{
    while(true){
      int matchingRow = -1;
      int matchingColumn = -1;

      for (int h = 0; h < height; h++) {
        for (int w = 0; w < width; w++) {
          if(isRowSolvable(w)){
            matchingRow = w;
            break;
          }else if(isColumnSolvable(h)){
            matchingColumn = h;
            break;
          }
        }
      }

      if(matchingRow == -1 && matchingColumn == -1){
        break;
      }

      if(matchingRow != -1){
        clearRow(matchingRow);
        refreshUI();
      }
      if(matchingColumn != -1){
        clearColumn(matchingColumn);
        refreshUI();
      }
      await Future.delayed(const Duration(seconds: 1));

      refill();
      refreshUI();

      await Future.delayed(const Duration(seconds: 1));
    }

  }
}
