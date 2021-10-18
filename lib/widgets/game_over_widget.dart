import 'package:flutter/material.dart';
import 'package:flutter_flame/views/main_menu.dart';

class GameOverMenu extends StatelessWidget {
  final Function onPressedReplay;

  final int score;

  const GameOverMenu(
      {Key key, @required this.onPressedReplay, @required this.score})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        shadowColor: Colors.black,
        color: Colors.deepPurple.withOpacity(0.5),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 50),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'GAME OVER',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                'Your Score is $score',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
              Column(
                children: [
                  IconButton(
                    onPressed: () {
                      onPressedReplay();
                    },
                    icon: const Icon(
                      Icons.replay_circle_filled,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.deepOrange)),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const MainMenu(),
                        ),
                      );
                    },
                    child: const Text("Main Menu"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
