import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';

import '../camparat_game.dart';

class Vial extends SpriteComponent with HasGameReference<CamparatGame> {
  final Vector2 gridPosition;
  double xOffset;
  final Vector2 velocity = Vector2.zero();

  Vial({required this.gridPosition, required this.xOffset})
      : super(size: Vector2.all(64), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = Sprite(game.vial);
    position = Vector2(
      (gridPosition.x * size.x) + xOffset,
      game.size.y - (gridPosition.y * size.y),
    );
    add(RectangleHitbox(collisionType: CollisionType.passive));
    add(MoveEffect.by(Vector2(-2 * size.x, 0),
        EffectController(duration: 1.5, alternate: true, infinite: true)));
  }

  @override
  void update(double dt) {
    velocity.x = game.objectSpeed;
    position += velocity * dt;
    if (position.x < -size.x) {
      removeFromParent();
    }

    super.update(dt);
  }
}
