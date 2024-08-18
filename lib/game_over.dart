import 'dart:ui';

import 'package:flame/components.dart';
import 'package:camparat_game/camparat_game.dart';
import 'package:flutter/material.dart';

class GameOverPanel extends Component {
  bool visible = false;

  @override
  Future<void> onLoad() async {
    add(GameOverText());
    add(GameOverRestart());
  }

  @override
  void renderTree(Canvas canvas) {
    if (visible) {
      super.renderTree(canvas);
    }
  }
}

class GameOverText extends Component with HasGameReference<CamparatGame> {
  @override
  Future<void> onLoad() async {
    // Define the text style

    final textPaint = TextPaint(
        style: const TextStyle(
      fontFamily: 'PPGatwick',
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 48,
    ));

    // Create the TextComponent
    final gameOverText = TextComponent(
      text: 'GAME OVER',
      textRenderer: textPaint,
      anchor: Anchor.center,
      position: Vector2(game.size.x / 2, game.size.y * 0.25),
    );

    // Add the TextComponent to the GameOverText component
    add(gameOverText);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
  }
}

class GameOverRestart extends SpriteComponent
    with HasGameReference<CamparatGame> {
  GameOverRestart() : super(size: Vector2(72, 64), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = Sprite(
      game.spriteImage,
      srcPosition: Vector2.all(2.0),
      srcSize: size,
    );
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    x = size.x / 2;
    position = Vector2(size.x / 2, size.y * 0.75);
  }
}
