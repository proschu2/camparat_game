import 'package:camparat_game/actors/vial.dart';
import 'package:camparat_game/objects/cap.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/services.dart';

import '../camparat_game.dart';
import '../objects/ground_block.dart' show GroundBlock;
import '../objects/platform_block.dart' show PlatformBlock;
import '../objects/cap.dart' show Cap;
import 'olives.dart' show Olives;
import 'vial.dart' show Vial;

class CamparatPlayer extends SpriteComponent
    with KeyboardHandler, CollisionCallbacks, HasGameReference<CamparatGame> {
  int horizontalDirection = 0;
  final Vector2 velocity = Vector2.zero();
  final double speed = 200;
  final Vector2 fromAbove = Vector2(0, -1);
  bool isOnGround = false;
  final double gravity = 15;
  final double jumpSpeed = 600;
  final double terminalVelocity = 150;

  bool hasJumped = false;
  bool hitByEnemy = false;

  CamparatPlayer({required super.position})
      : super(size: Vector2.all(64), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = Sprite(game.camparat);
    add(CircleHitbox());
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalDirection = 0;
    horizontalDirection += keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
            (keysPressed.contains(LogicalKeyboardKey.keyA))
        ? -1
        : 0;
    horizontalDirection +=
        keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
                (keysPressed.contains(LogicalKeyboardKey.keyD))
            ? 1
            : 0;
    hasJumped = keysPressed.contains(LogicalKeyboardKey.space);
    return true;
  }

  @override
  void update(double dt) {
    super.update(dt);
    velocity.x = horizontalDirection * speed;
    velocity.y += gravity;

    if (horizontalDirection < 0 && scale.x > 0) {
      flipHorizontally();
    } else if (horizontalDirection > 0 && scale.x < 0) {
      flipHorizontally();
    }

    if (hasJumped) {
      if (isOnGround) {
        velocity.y = -jumpSpeed;
        isOnGround = false;
      }
      hasJumped = false;
    }
    velocity.y = velocity.y.clamp(-jumpSpeed, terminalVelocity);
    game.objectSpeed = 0;
    if (position.x - 36 <= 0 && horizontalDirection < 0) {
      velocity.x = 0;
    }

    if (position.x + 64 >= game.size.x / 2 && horizontalDirection > 0) {
      velocity.x = 0;
      game.objectSpeed = -speed;
    }

    if (position.y - size.y / 2 <= 0) {
      position.y = size.y / 2;
    }
    position += velocity * dt;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is GroundBlock || other is PlatformBlock) {
      if (intersectionPoints.length == 2) {
        // Calculate the collision normal and separation distance.
        final mid = (intersectionPoints.elementAt(0) +
                intersectionPoints.elementAt(1)) /
            2;

        final collisionNormal = absoluteCenter - mid;
        final separationDistance = (size.x / 2) - collisionNormal.length;
        collisionNormal.normalize();

        // If collision normal is almost upwards,
        // ember must be on ground.
        if (fromAbove.dot(collisionNormal) > 0.9) {
          isOnGround = true;
        }

        // Resolve collision by moving ember along
        // collision normal by separation distance.
        position += collisionNormal.scaled(separationDistance);
      }
    }
    if (other is Cap) {
      other.removeFromParent();
    }

    if (other is Vial || other is Olives) {
      hit();
    }

    super.onCollision(intersectionPoints, other);
  }

  void hit() {
    if (!hitByEnemy) {
      hitByEnemy = true;
    }
    add(OpacityEffect.fadeOut(
        EffectController(alternate: true, duration: 0.1, repeatCount: 4))
      ..onComplete = () {
        hitByEnemy = false;
      });
  }
}
