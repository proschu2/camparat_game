import 'package:flame/game.dart';
import 'package:flutter/material.dart' hide Image, Gradient;
import 'package:camparat_game/camparat_game.dart';

class CamparatWidget extends StatelessWidget {
  const CamparatWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camparat',
      home: Container(
        color: Colors.black,
        margin: const EdgeInsets.all(45),
        child: ClipRect(
          child: GameWidget(
            game: CamparatGame(),
            loadingBuilder: (_) => const Center(
              child: Text('Loading'),
            ),
          ),
        ),
      ),
    );
  }
}
