import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flame/game/cat_game.dart';
import 'package:flutter_flame/views/main_menu.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.util.fullScreen();
//  await Flame.util.setLandscape();
  // await Flame.util.setOrientation(DeviceOrientation.portraitUp);

  runApp(const FlameGame());
}

class FlameGame extends StatelessWidget {
  const FlameGame({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flame Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainMenu(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CatGame game;

  @override
  void initState() {
    game = CatGame();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: game.widget,
    );
  }
}
