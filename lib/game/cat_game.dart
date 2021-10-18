import 'package:flame/components/parallax_component.dart';
import 'package:flame/components/text_component.dart';
import 'package:flame/game/base_game.dart';
import 'package:flame/game/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/position.dart';
import 'package:flame/text_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flame/components/cat.dart';
import 'package:flutter_flame/components/enemy.dart';
import 'package:flutter_flame/components/enemy_manager.dart';
import 'package:flutter_flame/widgets/game_over_widget.dart';

class CatGame extends BaseGame with TapDetector, HasWidgetsOverlay {
  ParallaxComponent _parallaxComponent;
  Cat _cat;
  EnemyManager _enemyManager;
  int score;
  TextComponent _textComponent;

  CatGame() {
    _parallaxComponent = ParallaxComponent([
      ParallaxImage("parallax/7.png"),
      ParallaxImage("parallax/6.png"),
      ParallaxImage("parallax/5.png"),
      ParallaxImage("parallax/4.png"),
      ParallaxImage("parallax/3.png"),
      ParallaxImage("parallax/2.png"),
      ParallaxImage("parallax/1.png"),
    ], baseSpeed: const Offset(50, 0), layerDelta: const Offset(10, 0));
    add(_parallaxComponent);
    _cat = Cat();
    add(_cat);

    _enemyManager = EnemyManager();
    add(_enemyManager);

    score = 0;
    _textComponent = TextComponent(score.toString(),
        config: TextConfig(fontSize: 30, color: Colors.amber));
    add(_textComponent);

    addWidgetOverlay('PauseGame', _buildPauseButton());
  }

  @override
  void onTapDown(TapDownDetails details) {
    _cat.jump();
    super.onTapDown(details);
  }

  @override
  void update(double t) {
    super.update(t);
    score += (60 * t).toInt();
    _textComponent.text = score.toString();

    components.whereType<Enemy>().forEach(
      (enemy) {
        if (_cat.distance(enemy) < 30) _cat.hit();
      },
    );

    if (_cat.life.value <= 0) {
      pauseEngine();
      addWidgetOverlay(
          'GameOver',
          GameOverMenu(
            onPressedReplay: reset,
            score: score,
          ));
    }
  }

  @override
  void lifecycleStateChange(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
        pauseEngine();
        break;
      case AppLifecycleState.paused:
        pauseEngine();
        break;
      case AppLifecycleState.detached:
        pauseEngine();
        break;
    }
    super.lifecycleStateChange(state);
  }

  @override
  void resize(Size size) {
    super.resize(size);
    _textComponent.setByPosition(Position(
        (size.width / 2) - _textComponent.width / 2,
        _textComponent.height / 2));
  }

  Widget _buildPauseButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              pauseEngine();
              removeWidgetOverlay('PauseGame');
              addWidgetOverlay('UnpauseGame', _buildContinueButton());
            },
            icon: const Icon(
              Icons.pause_circle_outline,
              color: Colors.white,
              size: 35,
            ),
          ),
          ValueListenableBuilder(
            valueListenable: _cat.life,
            builder: (BuildContext context, value, Widget child) {
              final listOfLife = <Widget>[];
              for (int i = 0; i < 3; ++i) {
                listOfLife.add(Icon(
                  (i < value) ? Icons.favorite : Icons.favorite_border,
                  color: Colors.deepPurple,
                  size: 35,
                ));
              }

              return Row(
                children: listOfLife,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton() {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        shadowColor: Colors.black,
        color: Colors.deepPurple.withOpacity(0.5),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 50),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Paused',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  )),
              IconButton(
                onPressed: () {
                  resumeEngine();
                  removeWidgetOverlay('UnpauseGame');
                  addWidgetOverlay('PauseGame', _buildPauseButton());
                },
                icon: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void reset() {
    {
      score = 0;
      _cat.life.value = 3;
      _cat.run();
      components.whereType<Enemy>().forEach(
        (enemy) {
          markToRemove(enemy);
        },
      );
      _enemyManager.reset();

      resumeEngine();
      removeWidgetOverlay('GameOver');
      addWidgetOverlay('PauseGame', _buildPauseButton());
    }
  }
}
