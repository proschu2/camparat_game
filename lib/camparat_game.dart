import 'dart:ui' as ui;

import 'package:flame/events.dart';
import 'package:flutter/widgets.dart';

import 'actors/olives.dart';
import 'actors/vial.dart';

import 'objects/cap.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';

import 'actors/camparat.dart';
import 'managers/segment_manager.dart';
import 'objects/ground_block.dart';
import 'objects/platform_block.dart';

class CamparatGame extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  CamparatGame();

  late final ui.Image vial;
  late final ui.Image cap;
  late final ui.Image olives;
  late final ui.Image camparat;
  late final ui.Image dirt;
  late final ui.Image grass;
  late final ui.Image bricks;

  late CamparatPlayer _camparat;
  double objectSpeed = 0.0;

  late double lastBlockXPosition = 0.0;
  late UniqueKey lastBlockKey;

  Color backgroundColor() {
    return const Color.fromARGB(255, 173, 223, 247);
  }

  void loadGameSegments(int segmentIndex, double xPositionOffset) {
    for (final block in segments[segmentIndex]) {
      switch (block.blockType) {
        case PlatformBlock:
          add(PlatformBlock(
            gridPosition: block.gridPosition,
            xOffset: xPositionOffset,
          ));
        case Cap:
          add(Cap(
            gridPosition: block.gridPosition,
            xOffset: xPositionOffset,
          ));
        case Vial:
          add(Vial(
            gridPosition: block.gridPosition,
            xOffset: xPositionOffset,
          ));
        case Olives:
          add(Olives(
            gridPosition: block.gridPosition,
            xOffset: xPositionOffset,
          ));
        case GroundBlock:
          add(GroundBlock(
            gridPosition: block.gridPosition,
            xOffset: xPositionOffset,
          ));
      }
    }
  }

  void initializeGame() {
    // Assume that size.x < 3200
    final segmentsToLoad = (size.x / 640).ceil();
    segmentsToLoad.clamp(0, segments.length);

    for (var i = 0; i <= segmentsToLoad; i++) {
      loadGameSegments(i, (640 * i).toDouble());
    }
    _camparat = CamparatPlayer(
      position: Vector2(128, size.y - 128),
    );
    world.add(_camparat);
  }

  @override
  Future<void> onLoad() async {
    await images.loadAll([
      'vial.png',
      'cap.png',
      'olives.png',
      'camparat.png',
      'dirt.png',
      'grass.png',
      'bricks.png',
    ]);

    // Use cached images
    vial = Flame.images.fromCache('vial.png');
    cap = Flame.images.fromCache('cap.png');
    olives = Flame.images.fromCache('olives.png');
    camparat = Flame.images.fromCache('camparat.png');
    dirt = Flame.images.fromCache('dirt.png');
    grass = Flame.images.fromCache('grass.png');
    bricks = Flame.images.fromCache('bricks.png');

    camera.viewfinder.anchor = Anchor.topLeft;

    initializeGame();
  }
}
