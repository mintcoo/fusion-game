import 'dart:async';
import 'dart:developer';

import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:fusion_game/src/components/components.dart';
import '../pages/fusion_game.dart';

class TopArea extends RectangleComponent
    with HasGameReference<FusionGame>, TapCallbacks, DragCallbacks {
  TopArea()
      : super(
          paint: Paint()
            ..color = const Color.fromARGB(255, 241, 247, 255), // 약간 다른 색상으로 구분
          children: [RectangleHitbox()],
        );

  Fruit? _currentFruit;

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    size = Vector2(game.width, game.height * 0.15); // 전체 높이의 15%
    position = Vector2(0, 0); // 최상단에 위치
  }

  // @override
  // void onTapDown(TapDownEvent event) {
  //   super.onTapDown(event);
  //   if (!event.handled) {
  //     final touchPoint = event.localPosition;
  //     // 메인 FusionGame에서 Flamegame을 상속받아서 쓰고 나머지는 HasGameReference를 상속받아서 쓰기에 game.world로 접근 가능

  //     game.world.add(
  //       Fruit(
  //         position: touchPoint, // 터치한 위치에 생성
  //       ),
  //     );
  //     // if (touchPoint.x > size.x / 2) {
  //     //   player.position = Vector2(size.x * 0.75, size.y - 20);
  //     // } else {
  //     //   player.position = Vector2(size.x * 0.25, size.y - 20);
  //     // }
  //   }
  // }
  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    if (!event.handled) {
      _currentFruit = Fruit(
        position: event.localPosition,
      );
      //메인 FusionGame에서 Flamegame을 상속받아서 쓰고 나머지는 HasGameReference를 상속받아서 쓰기에 game.world로 접근 가능
      game.world.add(_currentFruit!);
    }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (_currentFruit != null) {
      // 과일의 새로운 위치
      Vector2 newPosition = event.localStartPosition;

      // x 좌표 제한 clamp(min, max), size는 위에서 설정한 topArea의 size임
      newPosition.x = newPosition.x
          .clamp(_currentFruit!.size.x / 2, size.x - _currentFruit!.size.x / 2);

      // y 좌표 제한
      newPosition.y = newPosition.y
          .clamp(_currentFruit!.size.y / 2, size.y - _currentFruit!.size.y / 2);
      // 과일의 위치 업데이트
      _currentFruit!.position = newPosition;
    }
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    _currentFruit!.state = FruitState.falling;
    _currentFruit = null;
  }

  // 드래그와 따로 바로 클릭후 떨어지는 경우 처리
  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);
    _currentFruit!.state = FruitState.falling;
    _currentFruit = null;
  }
}
