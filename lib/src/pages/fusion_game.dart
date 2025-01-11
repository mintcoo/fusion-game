import 'dart:async';
import 'dart:math' as math; // Add this import

import 'package:flame/components.dart';
import 'package:flame/game.dart';

import '../components/components.dart';
import '../config.dart';

class FusionGame extends FlameGame {
  FusionGame()
      : super(
          camera: CameraComponent.withFixedResolution(
            width: gameWidth,
            height: gameHeight,
          ),
        );

  final rand = math.Random();
  // 게임 화면 너비 (CameraComponent.withFixedResolution()에서 지정한 크기로 초기화됨)
  double get width => size.x;
  // 게임 화면 높이
  double get height => size.y;

  // 게임 인스턴스가 생성될때 실행하는 함수, 대부분 여기에 내용을 배치한다.
  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    // 카메라 기준점을 좌측 상단으로 설정
    camera.viewfinder.anchor = Anchor.topLeft;

    // 플레이 영역 추가
    world.add(PlayArea());

    world.add(
      Ball(
        radius: ballRadius,
        position: Vector2(size.x / 2, size.y * 0.01), // 화면 상단 중앙에 위치하도록 변경
        velocity: Vector2((rand.nextDouble() - 0.5) * width, height * 0.2)
            .normalized()
          ..scale(height / 40),
      ),
    );

    debugMode = true;
  }

  // // 업데이트 되는 매 프레임마다 실행되는 로직
  // @override
  // void update(double dt) async {
  //   super.update(dt);
  //   log("update");
  // }

  // // 인스턴스가 해제될 떄 실행되는 로직
  // @override
  // void onRemove() {
  //   super.onRemove();
  //   log("onRemove");
  // }
}
