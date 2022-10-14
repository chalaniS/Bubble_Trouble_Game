import 'dart:async';

import 'package:bubble_trouble_game/ball.dart';

import 'missile.dart';
import 'player.dart';
import 'package:flutter/services.dart';
import 'botton.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

enum direction { LEFT, RIGHT }

class _HomePageState extends State<HomePage> {
  //player variable
  static double playerX = 0;

  //missle variables
  double missileX = playerX;
  double missileHeight = 10;
  bool midShot = false;

  //ball varieble
  double ballX = 0.5;
  double ballY = 1;
  var ballDirection = direction.LEFT;

  void startGame() {
    double time = 0;
    double height = 0;
    double velocity = 60; // how strong the jumb is

    Timer.periodic(const Duration(milliseconds: 10), (timer) {
      height = -5 * time * time + 100 * time;

      //if the ball reaches the ground, reset the jump
      if (height < 0) {
        time = 0;
      }

      //update the new ball position
      setState(() {
        ballY = heightToPosition(height);
      });

      //if the ball hits the left wall, then chnage direction to right
      if (ballX - 0.005 < -1) {
        ballDirection = direction.RIGHT;
      }

      //if the ball hits the right wall, then chnage direction to right
      else if (ballX + 0.005 > 1) {
        ballDirection = direction.LEFT;
      }

      //mover the ball in the correct direction
      if (ballDirection == direction.LEFT) {
        setState(() {
          ballX -= 0.02;
        });
      } else if (ballDirection == direction.RIGHT) {
        setState(() {
          ballX += 0.02;
        });
      }

      if (playDies()) {
        timer.cancel();
        _showDialog();
      }

      //keep the time going
      time += 0.1;
    });
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
            backgroundColor: Colors.grey,
            title: Text(
              "You are a winner",
              style: TextStyle(color: Colors.white),
            ),
          );
        });
  }

  void moveLeft() {
    setState(() {
      if (playerX - 0.1 < -1) {
        //do nothing
      } else {
        playerX -= 0.1;
      }

      //only make the X coordinate the same when it isn't in the middle of a shot
      if (!midShot) {
        missileX = playerX;
      }
    });
  }

  void moveRight() {
    setState(() {
      if (playerX + 0.1 > 1) {
        //do nothing
      } else {
        playerX += 0.1;
      }
      //only make the X coordinate the same when it isn't in the middle of a shot
      if (!midShot) {
        missileX = playerX;
      }
    });
  }

  void fireMissile() {
    if (midShot == false) {
      Timer.periodic(const Duration(milliseconds: 20), (timer) {
        //shots fired
        midShot = true;

        //missile grows til it hits the top of the screen
        setState(() {
          missileHeight += 10;
        });

        //stop missile when it reaches top of screen
        if (missileHeight > MediaQuery.of(context).size.height * 3 / 4) {
          resetMissile();
          timer.cancel();
        }

        //check if missile has hit the ball
        if (ballY > heightToPosition(missileHeight) &&
            (ballX - missileX).abs() < 0.03) {
          resetMissile();
          ballX = 5;
          timer.cancel();
        }
      });
    }
  }

  //converts height to a coordinate
  double heightToPosition(double height) {
    double totalHeight = MediaQuery.of(context).size.height * 3 / 4;
    double position = 1 - 2 * height / totalHeight;

    return position;
  }

  void resetMissile() {
    missileX = playerX;
    missileHeight = 10;
    midShot = false;
  }

  bool playDies() {
    //if the ball position and the player position are the same, then player dies

    if ((ballX - playerX).abs() < 0.05 && ballY > 0.95) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (RawKeyEvent event) {
        if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
          moveLeft();
        } else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
          moveRight();
        }
        if (event.isKeyPressed(LogicalKeyboardKey.space)) {
          fireMissile();
        }
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
                    MyBall(ballX: ballX, ballY: ballY),
                    MyMissile(
                      height: missileHeight,
                      missileX: missileX,
                    ),
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MyBotton(
                      icon: Icons.play_arrow,
                      function: startGame,
                    ),
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
