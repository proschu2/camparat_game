import 'dart:ui' as ui;

import 'package:flame/events.dart';
import 'package:flame/input.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'actors/camparat.dart';
import 'actors/olives.dart';
import 'actors/vial.dart';

import 'objects/cap.dart';
import 'objects/ground_block.dart';
import 'objects/platform_block.dart';

import 'managers/segment_manager.dart';

import 'overlays/hud.dart';

//import 'scrolling_background.dart';
class CamparatGame extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  late JoystickComponent joystick;

  CamparatGame();

  late ui.Image vial, cap, olives, camparat, dirt, grass, bricks;

  late CamparatPlayer _camparat;
  late double lastBlockXPosition = 0.0;
  late UniqueKey lastBlockKey;

  int capsCollected = 0;
  int health = 3;
  double objectSpeed = 0.0;
  double cloudSpeed = 0.0;
  int highestScore = 0;

  @override
  Color backgroundColor() {
    return const Color.fromARGB(255, 173, 223, 247);
  }

  void loadGameSegments(int segmentIndex, double xPositionOffset) {
    for (final block in segments[segmentIndex]) {
      switch (block.blockType) {
        case PlatformBlock:
          world.add(PlatformBlock(
            gridPosition: block.gridPosition,
            xOffset: xPositionOffset,
          ));
        case Cap:
          world.add(Cap(
            gridPosition: block.gridPosition,
            xOffset: xPositionOffset,
          ));
        case Vial:
          world.add(Vial(
            gridPosition: block.gridPosition,
            xOffset: xPositionOffset,
          ));
        case Olives:
          world.add(Olives(
            gridPosition: block.gridPosition,
            xOffset: xPositionOffset,
          ));
        case GroundBlock:
          world.add(GroundBlock(
            gridPosition: block.gridPosition,
            xOffset: xPositionOffset,
          ));
      }
    }
  }

  void initializeGame({required bool loadHud}) {
    // Assume that size.x < 3200
    final segmentsToLoad = (size.x / 640).ceil();
    segmentsToLoad.clamp(0, segments.length);

    for (var i = 0; i <= segmentsToLoad; i++) {
      loadGameSegments(i, (640 * i).toDouble());
    }
    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android) {
      joystick = JoystickComponent(
        knob: CircleComponent(
            radius: 30, paint: Paint()..color = Colors.redAccent),
        background: CircleComponent(
            radius: 60, paint: Paint()..color = Colors.red.withOpacity(0.5)),
        margin: const EdgeInsets.only(right: 40, bottom: 40),
      );
      add(joystick);
    }

    _camparat = CamparatPlayer(
      position: Vector2(128, size.y - 128),
    );
    world.add(_camparat);
    if (loadHud) {
      camera.viewport.add(Hud(game: this));
    }
  }

  @override
  Future<void> onLoad() async {
    //background = await ScrollingBackground();
    //add(background);
    await images.loadAll([
      'vial.png',
      'cap.png',
      'olives.png',
      'camparat.png',
      'dirt.png',
      'grass.png',
      'bricks.png',
      'footprint.png',
      'footprint_unavailable.png'
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
    final prefs = await SharedPreferences.getInstance();
    highestScore = prefs.getInt('highestScore') ?? 0;

    initializeGame(loadHud: true);
  }

  @override
  void update(double dt) {
    if (health <= 0) {
      if (capsCollected > highestScore) {
        highestScore = capsCollected;
        SharedPreferences.getInstance().then((prefs) {
          prefs.setInt('highestScore', highestScore);
        });
      }
      overlays.add('GameOver');
    }
    super.update(dt);
    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android) {
      _camparat.horizontalDirection = joystick.relativeDelta.x.round();
      if (joystick.relativeDelta.y < -0.5) {
        _camparat.jump();
      }
    }
  }

  void reset() {
    capsCollected = 0;
    health = 3;
    objectSpeed = 0.0;
    initializeGame(loadHud: false);
  }
}
