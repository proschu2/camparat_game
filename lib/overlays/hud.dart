import 'package:flutter/material.dart';
import 'package:flame/components.dart';

import '../camparat_game.dart';
import 'footprint.dart';

class Hud extends PositionComponent with HasGameReference<CamparatGame> {
  Hud({required this.game}) : super(priority: 5);

  late TextComponent _scoreText;
  late TextComponent _highestScoreText;
  final CamparatGame game;

  @override
  Future<void> onLoad() async {
    _scoreText = TextComponent(
      text: '${game.capsCollected}',
      textRenderer: TextPaint(
          style: const TextStyle(
              fontSize: 32,
              fontFamily: 'PPGatwick',
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(10, 10, 10, 1))),
      anchor: Anchor.center,
      position: Vector2(game.size.x - 60, 36),
    );
    _highestScoreText = TextComponent(
      text: 'HI: ${game.highestScore}',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 32,
          fontFamily: 'PPGatwick',
          fontWeight: FontWeight.bold,
          color: Color.fromRGBO(10, 10, 10, 1),
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(game.size.x - 240, 36),
    );
    add(_scoreText);
    add(_highestScoreText);

    final capSprite = Sprite(game.cap);
    add(
      SpriteComponent(
        sprite: capSprite,
        position: Vector2(game.size.x - 110, 36),
        size: Vector2.all(32),
        anchor: Anchor.center,
      ),
    );

    for (var i = 1; i <= game.health; i++) {
      final positionX = 40 * i;
      await add(
        FootHealthComponent(
            footNumber: i,
            position: Vector2(positionX.toDouble(), 20),
            size: Vector2.all(32)),
      );
    }
  }

  @override
  void update(double dt) {
    _scoreText.text = '${game.capsCollected}';
    _highestScoreText.text = 'HI ${game.highestScore}';
    super.update(dt);
  }
}
