import 'package:flutter/material.dart';

import '../camparat_game.dart';

class GameOver extends StatelessWidget {
  // Reference to parent game.
  final CamparatGame game;
  const GameOver({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    const blackTextColor = Color.fromRGBO(0, 0, 0, 1.0);
    const whiteTextColor = Color.fromRGBO(255, 255, 255, 1.0);
    final screenSize = MediaQuery.of(context).size;
    final containerHeight = screenSize.height * 0.3;
    final containerWidth = screenSize.width * 0.8;

    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          height: containerHeight,
          width: containerWidth,
          decoration: const BoxDecoration(
            color: blackTextColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Game Over',
                style: TextStyle(
                  fontFamily: 'PPGatwick',
                  color: whiteTextColor,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Highest Score: ${game.highestScore}',
                style: const TextStyle(
                  fontFamily: 'PPGatwick',
                  color: whiteTextColor,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: containerWidth * 0.8,
                height: containerHeight * 0.3,
                child: ElevatedButton(
                  onPressed: () {
                    game.reset();
                    game.overlays.remove('GameOver');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: whiteTextColor,
                  ),
                  child: const Text(
                    'Play Again',
                    style: TextStyle(
                      fontFamily: 'PPGatwick',
                      fontSize: 28.0,
                      color: blackTextColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
