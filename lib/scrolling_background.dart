import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

import 'camparat_game.dart';

class ScrollingBackground extends Component with HasGameRef<CamparatGame> {
  late Sprite sprite;
  late SpriteComponent spriteComponent1;
  late SpriteComponent spriteComponent2;

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('wall.jpg');
    spriteComponent1 = SpriteComponent(sprite: sprite);
    spriteComponent2 = SpriteComponent(sprite: sprite);

    spriteComponent1.size = Vector2(1024, gameRef.size.y);
    spriteComponent2.size = Vector2(1024, gameRef.size.y);

    spriteComponent2.position = Vector2(1024, 0);

    add(spriteComponent1);
    add(spriteComponent2);
  }

  void updatePosition(double playerX) {
    spriteComponent1.position.x = -playerX % 1024;
    spriteComponent2.position.x = spriteComponent1.position.x + 1024;

    if (spriteComponent1.position.x <= -1024) {
      spriteComponent1.position.x = spriteComponent2.position.x + 1024;
    }

    if (spriteComponent2.position.x <= -1024) {
      spriteComponent2.position.x = spriteComponent1.position.x + 1024;
    }
  }
}