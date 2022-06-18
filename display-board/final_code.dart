import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHome(),
    );
  }
}

class MyHome extends StatelessWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            TileRow('flutter'),
            TileRow('with'),
            TileRow('draig'),
          ],
        ),
      ),
    );
  }
}

class TileRow extends StatelessWidget {
  const TileRow(this.text, {Key? key}) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    final tiles = text.characters.map((c) => MyTile(c)).toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: tiles,
    );
  }
}

class MyTile extends StatefulWidget {
  const MyTile(this.targetChar, {Key? key}) : super(key: key);
  final String targetChar;
  @override
  State<MyTile> createState() => _MyTileState();
}

class _MyTileState extends State<MyTile> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;
  bool secondStage = false;
  int targetLetter = 70;
  int currentLetter = 64;

  int get nextLetter => currentLetter >= 90 ? 65 : currentLetter + 1;

  @override
  void initState() {
    super.initState();

    targetLetter = widget.targetChar.toUpperCase().codeUnitAt(0);
    while (currentLetter == targetLetter || currentLetter == 64) {
      currentLetter = randUpperCaseChar();
    }

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
    )
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          secondStage = true;
          _controller.reverse();
        }
        if (status == AnimationStatus.dismissed) {
          currentLetter = nextLetter;
          secondStage = false;
          if (currentLetter != targetLetter) {
            _controller.forward();
          }
        }
      })
      ..addListener(() {
        setState(() {});
      });

    _animation = Tween(begin: 0, end: pi / 2).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 50);

    tileA(int char) => Container(
          alignment: Alignment.center,
          color: Colors.blue,
          width: 55,
          child: Text(
            String.fromCharCode(char),
            style: style,
          ),
        );

    tileB(int char) => Container(
          alignment: Alignment.center,
          color: Colors.blue,
          width: 55,
          child: Text(
            String.fromCharCode(char),
            style: style,
          ),
        );

    topTile(Widget child) => ClipRect(
          child: Align(
            alignment: Alignment.topCenter,
            heightFactor: 0.49,
            child: child,
          ),
        );

    bottomTile(Widget child) => ClipRect(
          child: Align(
            alignment: Alignment.bottomCenter,
            heightFactor: 0.49,
            child: child,
          ),
        );

    return Padding(
      padding: const EdgeInsets.all(1),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              topTile(tileB(nextLetter)),
              Transform(
                  alignment: Alignment.bottomCenter,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.005)
                    ..rotateX(secondStage ? pi / 2 : _animation.value / 1),
                  child: topTile(tileA(currentLetter))),
            ],
          ),
          const SizedBox(height: 2),
          Stack(
            children: [
              bottomTile(tileA(currentLetter)),
              Transform(
                  alignment: Alignment.topCenter,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.005)
                    ..rotateX(secondStage ? -_animation.value / 1 : pi / 2),
                  child: bottomTile(tileB(nextLetter))),
            ],
          ),
        ],
      ),
    );
  }
}

final random = Random();
randBetween(int min, int max) => min + random.nextInt(max - min);
randUpperCaseChar() => randBetween(65, 91);
