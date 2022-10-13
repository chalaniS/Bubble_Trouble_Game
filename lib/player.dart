import 'package:flutter/material.dart';

class MyPlayer extends StatelessWidget {
  final playerX;

  MyPlayer({this.playerX});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(playerX, 1),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          color: Colors.deepPurple,
          height: 50,
          width: 50,
        ),
      ),
    );
  }
}
