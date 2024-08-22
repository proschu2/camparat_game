import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../camparat_game.dart';
import '../managers/segment_manager.dart';

class GroundBlock extends SpriteComponent with HasGameReference<CamparatGame> {
  final Vector2 gridPosition;
  double xOffset;

  final Vector2 velocity = Vector2.zero();
  final UniqueKey _blockKey = UniqueKey();

  GroundBlock({required this.gridPosition, required this.xOffset})
      : super(size: Vector2.all(64), anchor: Anchor.bottomLeft);

  @override
  Future<void> onLoad() async {
    final random = Random();
    final sprites = [game.dirt, game.grass];
    final spriteSize = Vector2(32, 32); // Assuming each sprite is 64x64 pixels
    final srcPosition = Vector2(0, 0); // Top-left corner of the 3x3 grid
    sprite = Sprite(
      sprites[random.nextInt(sprites.length)],
      srcPosition: srcPosition,
      srcSize: spriteSize,
    );
    position = Vector2(
      (gridPosition.x * size.x) + xOffset,
      game.size.y - (gridPosition.y * size.y),
    );
    add(RectangleHitbox(collisionType: CollisionType.passive));
    if (gridPosition.x == 9 && position.x > game.lastBlockXPosition) {
      game.lastBlockKey = _blockKey;
      game.lastBlockXPosition = position.x + size.x;
    }
  }

  @override
  void update(double dt) {
    velocity.x = game.objectSpeed;
    position += velocity * dt;

    if (gridPosition.x == 9) {
      if (game.lastBlockKey == _blockKey) {
        game.lastBlockXPosition = position.x - 10;
      }
    }

    if (position.x < -size.x) {
      removeFromParent();
      game.loadGameSegments(
          Random().nextInt(segments.length), game.lastBlockXPosition);
    }

    super.update(dt);
  }
}
