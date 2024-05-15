import 'package:flutter/material.dart';
import 'package:technical_test_bear/model/battle/circle_item.dart';

class BoardItem extends StatelessWidget {
  const BoardItem({Key? key, required this.item, this.alpha = 255}) : super(key: key);

  final CircleItem item;
  final int alpha;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return item.getIcon(constraint.biggest.height, alpha: alpha);
    },);
  }
}