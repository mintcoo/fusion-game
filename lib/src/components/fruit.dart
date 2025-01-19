import 'dart:developer';
import 'dart:math' as math; // Add this import

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:fusion_game/src/components/components.dart';
import 'package:fusion_game/src/pages/fusion_game.dart';

enum FruitState {
  hover,
  falling,
  hit,
}

class Fruit extends SpriteComponent
    with HasGameReference<FusionGame>, CollisionCallbacks {
  static const double fruitSize = 180.0;
  // 회전 속도
  static const double rotationSpeed = 1.0;

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
  FruitState _state = FruitState.hover;
  FruitState get state => _state;

  // 상태 변경
  set state(FruitState newState) {
    _state = newState;
  }

  // 중력 추가
  final Vector2 gravity = Vector2(0, 350);

  late Sprite _sprite;
  late ShapeHitbox hitbox;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    log('fruit onLoad ${position.toString()}');
    _sprite = await game.loadSprite("fruits/fruit.png");
    sprite = _sprite;
    // 초기 속도 설정
    speed = Vector2(0, 10).normalized()..scale(height / 40);

    // 빨간 선으로 히트박스 표시
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

    // 상태에 따라 떨어짐 적용
    if (_state == FruitState.falling) {
      // 속도에 중력 적용
      speed += gravity * dt;
      // 위치 업데이트
      position += speed * dt;

      // 수평 속도에 따른 회전 효과 추가
      angle += speed.x * dt * (rotationSpeed / fruitSize);

      // 벽 충돌 검사
      final halfWidth = size.x / 2;
      const restitution = 0.7; // 반발 계수 (0: 완전 비탄성 충돌, 1: 완전 탄성 충돌)
      const friction = 0.98; // 마찰 계수

      if (position.x - halfWidth <= 0) {
        // 왼쪽 벽 충돌
        position.x = halfWidth;
        speed.x = -speed.x * restitution; // 반발력 적용
        speed.y *= friction; // 마찰력 적용
      } else if (position.x + halfWidth >= game.width) {
        // 오른쪽 벽 충돌
        position.x = game.width - halfWidth;
        speed.x = -speed.x * restitution;
        speed.y *= friction;
      }

      if (position.y + halfWidth >= game.height) {
        // 바닥 충돌
        position.y = game.height - halfWidth;
        speed.y = 0; // 수직 방향 반발력
        speed.x *= friction; // 수평 방향 마찰력

        // 속도가 매우 작아지면 멈추도록 처리
        if (speed.length < 3) {
          speed.x = 0;
          speed.y = 0;
          gravity.y = 0;
        }
      }
    }
  }

  @override
  // Flame의 충돌 콜백에는 수명 주기가 있음. 콜백은 onCollisionStart, onCollision, onCollisionEnd.
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    log('플레이 영역@@');
    // if (other is PlayArea) {
    //   log('플레이 영역');
    //   if (intersectionPoints.first.y >= game.height) {
    //     log('아래');
    //     speed.x += 100;
    //   }
    // } else {
    //   debugPrint('collision with $other');
    // }
  }
}
