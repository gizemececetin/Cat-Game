// ignore_for_file: constant_identifier_names

import 'dart:ui';

import 'package:flame/anchor.dart';
import 'package:flame/components/animation_component.dart';
import 'package:flame/spritesheet.dart';
import 'package:flutter_flame/constants/constants.dart';

enum EnemyType { Snake, Mummy, Hyena }

class EnemyData {
  final String imageName;
  final int textureWidth;
  final int textureHeight;
  final int columnsNumber;
  final int rowsNumber;
  const EnemyData({
    this.imageName,
    this.textureHeight,
    this.textureWidth,
    this.columnsNumber,
    this.rowsNumber,
  });
}

class Enemy extends AnimationComponent {
  double speed = 100;
  Size size;
  int textureWidth;
  int textureHeight;
  static const Map<EnemyType, EnemyData> _enemyDetails = {
    EnemyType.Snake: EnemyData(
        imageName: "Snake_walk.png",
        textureWidth: 48,
        textureHeight: 48,
        columnsNumber: 4,
        rowsNumber: 1),
    EnemyType.Mummy: EnemyData(
        imageName: "Mummy_walk.png",
        textureWidth: 48,
        textureHeight: 48,
        columnsNumber: 6,
        rowsNumber: 1),
    EnemyType.Hyena: EnemyData(
        imageName: "Hyena_walk.png",
        textureWidth: 48,
        textureHeight: 48,
        columnsNumber: 6,
        rowsNumber: 1),
  };

  Enemy(EnemyType enemyType) : super.empty() {
    final enemyData = _enemyDetails[enemyType];

    final enemySpriteSheet = SpriteSheet(
        imageName: enemyData.imageName,
        textureWidth: enemyData.textureWidth,
        textureHeight: enemyData.textureHeight,
        columns: enemyData.columnsNumber,
        rows: enemyData.rowsNumber);
    animation = enemySpriteSheet.createAnimation(0,
        from: 0, to: enemyData.columnsNumber - 1, stepTime: 0.1);

    textureHeight = enemyData.textureHeight;
    textureWidth = enemyData.textureWidth;
    anchor = Anchor.center;
  }
  @override
  void update(double t) {
    super.update(t);
    x -= speed * t;
  }

  @override
  void resize(Size size) {
    super.resize(size);
    double scale = (size.width / 10) / textureWidth;

    width = textureWidth * scale;
    height = textureHeight * scale;
    x = size.width + width;
    y = size.height - groundHeight - (height / 2);
    this.size = size;
  }

  @override
  bool destroy() {
    return x < -width;
  }
}
