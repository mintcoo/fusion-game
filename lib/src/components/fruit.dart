import 'dart:math' as math; // Add this import

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

enum FruitState {
  hover,
  falling,
  hit,
}

class Fruit extends SpriteComponent with HasGameRef, CollisionCallbacks {
  static const double fruitSize = 180.0;

  Fruit({
    required super.position,
  }) : super(
          anchor: Anchor.center,
          size: Vector2(fruitSize, fruitSize),
          sprite: null,
        );

  final random = math.Random();

  Vector2 speed = Vector2(0, 0);

  // 초기 상태 설정
  final FruitState _state = FruitState.falling;
  FruitState get state => _state;

  // 중력 추가
  final Vector2 gravity = Vector2(0, 200);

  late Sprite _sprite;
  late ShapeHitbox hitbox;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    _sprite = await gameRef.loadSprite("fruits/fruit.png");
    sprite = _sprite;
    // 초기 속도 설정
    speed = Vector2((random.nextDouble() - 0.5) * width, height * 0.2)
        .normalized()
      ..scale(height / 40);

    // 플레이어 비행기랑 똑같이 빨간 선으로 히트박스 표시
    final Paint defaultPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke;
    hitbox = CircleHitbox()
      ..paint = defaultPaint
      ..renderShape = true;
    add(hitbox);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // 속도에 중력 적용
    speed += gravity * dt;
    // 위치 업데이트
    position += speed * dt;
  }
}
