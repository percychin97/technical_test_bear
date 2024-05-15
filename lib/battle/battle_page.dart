import 'package:flutter/material.dart';
import 'package:technical_test_bear/battle/board.dart';

class BattlePage extends StatelessWidget {
  const BattlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SafeArea(child: Board()),
        ],
      ),
    );
  }
}
