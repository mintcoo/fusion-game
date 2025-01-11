import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Ball extends CircleComponent {
  Ball({
    required this.velocity,
    required super.position,
    required double radius,
  }) : super(
            radius: radius,
            anchor: Anchor.center,
            paint: Paint()
              ..color = const Color(0xff1e6091)
              ..style = PaintingStyle.fill);

  Vector2 velocity;

  // 중력 추가
  final Vector2 gravity = Vector2(0, 400);

  @override
  void update(double dt) {
    super.update(dt);
    // 속도에 중력 적용
    velocity += gravity * dt;
    // 위치 업데이트
    position += velocity * dt;
  }
}
