import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:fusion_game/src/pages/fusion_game.dart';

class MyFusionGame extends StatefulWidget {
  const MyFusionGame({super.key});

  @override
  State<MyFusionGame> createState() => _MyFusionGameState();
}

class _MyFusionGameState extends State<MyFusionGame> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fusion Game"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GameWidget(
            game: FusionGame(), // 이부분에 게임 인스턴스를 넣어준다.
          ),
        ),
      ),
    );
  }
}
