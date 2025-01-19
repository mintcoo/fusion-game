import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:fusion_game/src/components/top_area.dart';

import '../pages/fusion_game.dart';

class PlayArea extends RectangleComponent with HasGameReference<FusionGame> {
  PlayArea()
      : super(
          paint: Paint()..color = const Color(0xfff2e8cf),
          children: [RectangleHitbox()],
        );

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    size = Vector2(game.width, game.height);

    // 상단 영역 추가
    add(TopArea());
  }
}
