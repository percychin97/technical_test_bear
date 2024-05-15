import 'package:flutter/material.dart';
import 'package:technical_test_bear/battle/battle_page.dart';

// TODO: Add a real home page there you can choose a level etc.
class BoardPuzzleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Technical Test',
      theme: ThemeData(),
      home: const BattlePage(),
    );
  }
}