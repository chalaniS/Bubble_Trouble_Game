import 'package:bubble_trouble_game/player.dart';

import 'botton.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //player variable
  double playerX = 0;

  void moveLeft() {
    setState(() {
      playerX -= 0.1;
    });
  }

  void moveRight() {
    setState(() {
      playerX += 0.1;
    });
    void fireMissile() {
      setState(() {
        playerX -= 0.1;
      });
    }

    @override
    Widget build(BuildContext context) {
      return RawKeyboardListener(
        focusNode: FocusNode(),
        autofocus: true,
        onKey: (RawKeyEvent event) {
          //start fro m here
        },
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.pink[200],
                child: Center(
                  child: Stack(
                    children: [
                      MyPlayer(
                        playerX: playerX,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.grey,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyBotton(
                        icon: Icons.arrow_back,
                        function: moveLeft,
                      ),
                      MyBotton(
                        icon: Icons.arrow_upward,
                        function: fireMissile,
                      ),
                      MyBotton(
                        icon: Icons.arrow_forward,
                        function: moveRight,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
