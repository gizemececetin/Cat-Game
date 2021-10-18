import 'dart:ui';

import 'package:flame/anchor.dart';
import 'package:flame/animation.dart';
import 'package:flame/components/animation_component.dart';
import 'package:flame/spritesheet.dart';
import 'package:flame/time.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_flame/constants/constants.dart';

class Cat extends AnimationComponent {
  Animation _runAnimation;
  Animation _hitAnimation;
  double speedY = 0.0;
  double maxY = 0.0;
  Timer _timer;
  bool isHit;
  ValueNotifier<int> life;

  Cat() : super.empty() {
    final catSpriteSheet = SpriteSheet(
        imageName: "cat_spritesheet.png",
        textureWidth: 32,
        textureHeight: 32,
        columns: 8,
        rows: 10);
    _runAnimation =
        catSpriteSheet.createAnimation(4, from: 0, to: 7, stepTime: 0.1);
    _hitAnimation =
        catSpriteSheet.createAnimation(9, from: 0, to: 7, stepTime: 0.1);
    run();
    _timer = Timer(1, callback: () => run());
    isHit = false;
    anchor = Anchor.center;

    life = ValueNotifier(3);
  }

  bool isOnGround() {
    return y >= maxY;
  }

  @override
  void update(double t) {
    // V = Vo + GRAVITY * t
    speedY += gravity * t;
    //Y = Yo + V.T
    y += speedY * t;
    if (isOnGround()) {
      y = maxY;
      speedY = 0;
    }
    _timer.update(t);
    super.update(t);
  }

  @override
  void resize(Size size) {
    width = height = size.width / 8;
    x = width;
    y = size.height - groundHeight - (height / 2);

    maxY = y;

    super.resize(size);
  }

  void run() {
    animation = _runAnimation;
    isHit = false;
  }

  void hit() {
    if (!isHit) {
      isHit = true;
      animation = _hitAnimation;

      life.value -= 1;
      _timer.start();
    }
  }

  void jump() {
    if (isOnGround()) {
      speedY = -500;
    }
  }
}
