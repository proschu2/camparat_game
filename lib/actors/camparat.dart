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
  CamparatPlayer({required super.position})
      : super(size: Vector2.all(64), anchor: Anchor.center);

  final Vector2 velocity = Vector2.zero();
  final Vector2 fromAbove = Vector2(0, -1);
  final double gravity = 15;
  final double jumpSpeed = 600;
  final double moveSpeed = 200;
  final double terminalVelocity = 150;
  int horizontalDirection = 0;

  bool isOnGround = false;
  bool hitByEnemy = false;

  @override
  Future<void> onLoad() async {
    sprite = Sprite(game.camparat);
    add(CircleHitbox());
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalDirection = 0;
    horizontalDirection += (keysPressed.contains(LogicalKeyboardKey.keyA) ||
            keysPressed.contains(LogicalKeyboardKey.arrowLeft))
        ? -1
        : 0;
    horizontalDirection += (keysPressed.contains(LogicalKeyboardKey.keyD) ||
            keysPressed.contains(LogicalKeyboardKey.arrowRight))
        ? 1
        : 0;
    if (keysPressed.contains(LogicalKeyboardKey.space)) {
      jump();
    }
    return true;
  }

  void jump() {
    if (isOnGround) {
      velocity.y = -jumpSpeed;
      isOnGround = false;
    }
  }

  @override
  void update(double dt) {
    velocity.x = horizontalDirection * moveSpeed;
    game.objectSpeed = 0;

    if (position.x - 36 <= 0 && horizontalDirection < 0) {
      velocity.x = 0;
    }

    if (position.x + 64 >= game.size.x / 2 && horizontalDirection > 0) {
      velocity.x = 0;
      game.objectSpeed = -moveSpeed;
    }

    velocity.y += gravity;

    if (horizontalDirection < 0 && scale.x > 0) {
      flipHorizontally();
    } else if (horizontalDirection > 0 && scale.x < 0) {
      flipHorizontally();
    }

    if (position.y - size.y / 2 <= 0) {
      position.y = size.y / 2 + 0.001;
      velocity.y = jumpSpeed;
    }
    velocity.y = velocity.y.clamp(-jumpSpeed, terminalVelocity);

    position += velocity * dt;

    if (position.y > game.size.y + size.y) {
      game.health = 0;
    }
    if (game.health <= 0) {
      removeFromParent();
    }
    super.update(dt);
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
      game.capsCollected++;
    }

    if (!hitByEnemy && (other is Vial || other is Olives)) {
      hit();
    }

    super.onCollision(intersectionPoints, other);
  }

  void hit() {
    if (!hitByEnemy) {
      game.health--;
      hitByEnemy = true;
    }
    add(OpacityEffect.fadeOut(
        EffectController(alternate: true, duration: 0.5, repeatCount: 4))
      ..onComplete = () {
        hitByEnemy = false;
      });
  }
}
