import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flame/game/cat_game.dart';

class GameController extends StatefulWidget {
  const GameController({Key key}) : super(key: key);

  @override
  State<GameController> createState() => _GameControllerState();
}

class _GameControllerState extends State<GameController> {
  final CatGame game = CatGame();
  @override
  void initState() {
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: game.widget,
    );
  }

  Future<void> initialize() async {
    await Flame.util.setLandscape();
  }
}
