import '../camparat_game.dart';
import 'package:flame/components.dart';

enum FootState {
  available,
  unavailable,
}

class FootHealthComponent extends SpriteGroupComponent<FootState>
    with HasGameReference<CamparatGame> {
  final int footNumber;

  FootHealthComponent({
    required this.footNumber,
    required super.position,
    required super.size,
    super.scale,
    super.angle,
    super.anchor,
    super.priority,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final availableSprite = await game.loadSprite('footprint.png');
    final unavailableSprite = await game.loadSprite(
      'footprint_unavailable.png',
    );

    sprites = {
      FootState.available: availableSprite,
      FootState.unavailable: unavailableSprite,
    };

    current = FootState.available;
  }

  @override
  void update(double dt) {
    if (game.health < footNumber) {
      current = FootState.unavailable;
    } else {
      current = FootState.available;
    }
    super.update(dt);
  }
}
