import 'dart:math';
import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/time.dart';
import 'package:flutter_flame/components/enemy.dart';
import 'package:flutter_flame/game/cat_game.dart';

class EnemyManager extends Component with HasGameRef<CatGame> {
  Random random;
  Timer _timer;
  int createLevel;
  EnemyManager() {
    random = Random();
    createLevel = 0;
    _timer = Timer(4, repeat: true, callback: () {
      createEnemy();
    });
  }
  @override
  void onMount() {
    super.onMount();
    _timer.start();
  }

  @override
  void render(Canvas c) {}

  @override
  void update(double t) {
    _timer.update(t);
    int newCreateLevel = (gameRef.score ~/ 500);
    if (createLevel < newCreateLevel) {
      createLevel = newCreateLevel;
      double newTime = (4 / (1 + (0.1 * createLevel)));
      _timer.stop();
      _timer = Timer(newTime, repeat: true, callback: () {
        createEnemy();
      });
      _timer.start();
    }
  }

  void createEnemy() {
    int randomInt = random.nextInt(EnemyType.values.length);
    EnemyType randomEnemyType = EnemyType.values.elementAt(randomInt);
    Enemy newEnemy = Enemy(randomEnemyType);
    gameRef.addLater(newEnemy);
  }

  void reset() {
    createLevel = 0;
    _timer.stop();
    _timer = Timer(4, repeat: true, callback: () {
      createEnemy();
    });
    _timer.start();
  }
}
