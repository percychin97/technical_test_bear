import 'package:flutter/material.dart';
import 'package:technical_test_bear/battle/board_item.dart';
import 'package:technical_test_bear/variable_state.dart';

import '../model/battle/circle_item.dart';

/// Class to define one puzzle board of the game.
/// Defines the grid (Content of field, number of fileds, size of fields)
class Board extends StatefulWidget {
  const Board({super.key});

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  bool isAnimating = false;

  @override
  Widget build(BuildContext context) {
    final boardWidth = MediaQuery.of(context).size.width;
    final boardHeight = boardWidth;

    return Column(children: <Widget>[
      SizedBox(
        height: boardHeight,
        width: boardWidth,
        child: GridView.count(
          physics: const NeverScrollableScrollPhysics(), // disable scrolling
          crossAxisCount: 8,
          children: boardGridFields(),
        ),
      ),
    ]);
  }

  List<Widget> boardGridFields() {

    Widget wBoardField(int index){
      int x = (index/8).floor();
      int y = (index%8).floor();

      final dark = x % 2 == 0 ? index % 2 == 0 : index % 2 == 1;
      Color? backgroundColor = dark ? Colors.brown[500] : Colors.brown[700];
      if(chosenIndex==index) {
        backgroundColor = Colors.white;
      }

      return Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0.5),
            color: backgroundColor),
        child: LayoutBuilder(builder: (context, constraints) {
          final item = boardGrid.grid[x][y];
          return GestureDetector(
              onTap: ()async{
                if(isAnimating) {
                  debugPrint('Please wait for a while!');
                  return;
                }

                isAnimating = true;
                if(mounted) setState(() {});
                if(chosenIndex == -1){
                  /// CHOOSE FIRST
                  chosenIndex = index;
                  if(mounted) setState(() {});
                }
                else if(chosenIndex == index){
                  /// CANCEL CHOSEN
                  chosenIndex = -1;
                  if(mounted) setState(() {});
                }else{
                  /// PERFORM SWAP
                  int firstCircleX = (chosenIndex/8).floor();
                  int firstCircleY = (chosenIndex%8).floor();
                  chosenIndex = -1;
                  if(mounted) setState(() {});
                  boardGrid.swapCircles(firstCircleX, firstCircleY, x, y);

                  await Future.delayed(const Duration(seconds: 1));

                  /// IF NO MATCH, REVERT SWAPPING
                  if(!boardGrid.isRowSolvable(x) &&
                      !boardGrid.isRowSolvable(firstCircleX) && !boardGrid.isColumnSolvable(y)
                      && !boardGrid.isColumnSolvable(firstCircleY)){
                    debugPrint('No match found! Revert swap.');
                    boardGrid.swapCircles(x, y, firstCircleX, firstCircleY);
                    if(mounted) setState(() {});
                  }else{
                    /// SOLVE MATCH
                    if(boardGrid.isRowSolvable(x) || boardGrid.isRowSolvable(firstCircleX)){
                      debugPrint('match found in row');
                      /// CLEAR THE ROW AND FILL UP THE SPACE
                      boardGrid.clearRow(x);
                      boardGrid.clearRow(firstCircleX);
                      if(mounted) setState(() {});
                    }else if(boardGrid.isColumnSolvable(y) || boardGrid.isColumnSolvable(firstCircleY)){
                      debugPrint('match found in column');
                      /// CLEAR THE COLUMN AND FILL UP THE SPACE
                      boardGrid.clearColumn(y);
                      boardGrid.clearColumn(firstCircleY);
                      if(mounted) setState(() {});

                    }
                    await Future.delayed(const Duration(seconds: 1));
                    boardGrid.refill();
                    if(mounted) setState(() {});

                    await Future.delayed(const Duration(seconds: 1));
                    boardGrid.autoClearMatch((){setState(() {});});
                  }
                }

                isAnimating = false;
                if(mounted) setState(() {});
              },
              child: item.getIcon(constraints.maxHeight, alpha: 255));
        }),
      );
    }

    return List.generate(64, (index) {

      return Center(child: wBoardField(index),);
    });
  }
}
