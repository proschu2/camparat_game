import 'camparat_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(GameWidget<CamparatGame>.controlled(
    gameFactory: CamparatGame.new,
  ));
}
