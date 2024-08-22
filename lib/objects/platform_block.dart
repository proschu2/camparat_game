import '../camparat_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class PlatformBlock extends SpriteComponent
    with HasGameReference<CamparatGame> {
  final Vector2 gridPosition;
  final Vector2 velocity = Vector2.zero();

  double xOffset;

  PlatformBlock({
    required this.gridPosition,
    required this.xOffset,
  }) : super(size: Vector2.all(64), anchor: Anchor.bottomLeft);

  @override
  void onLoad() {
    sprite = Sprite(game.bricks);
    position = Vector2(
      (gridPosition.x * size.x) + xOffset,
      game.size.y - (gridPosition.y * size.y),
    );
    add(RectangleHitbox(collisionType: CollisionType.passive));
  }

  @override
  void update(double dt) {
    velocity.x = game.objectSpeed;
    position += velocity * dt;
    if (position.x < -size.x) removeFromParent();

    super.update(dt);
  }
}
