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
      home: Scaffold(
        body: SafeArea(child: Flip()),
      ),
    );
  }
}

class Flip extends StatefulWidget {
  const Flip({Key? key}) : super(key: key);

  @override
  State<Flip> createState() => _FlipState();
}

class _FlipState extends State<Flip> with SingleTickerProviderStateMixin {
  double value = 0.0;
  late final AnimationController _animationController;
  late Animation rotation;
  String card = 'assets/card_front.png';

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    rotation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutQuart,
      ),
    );

    _animationController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        children: [
          const SizedBox(height: 50),
          if (rotation.value < 0.5) ...[
            Transform(
              transform: Matrix4.rotationY(pi * rotation.value),
              alignment: FractionalOffset.center,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/card_back.png'),
                  ),
                ),
                width: 300,
                height: 466,
                alignment: Alignment.topCenter,
              ),
            ),
          ] else ...[
            Transform(
              transform: Matrix4.rotationY(pi * (1 - rotation.value)),
              alignment: FractionalOffset.center,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(card),
                  ),
                ),
                width: 300,
                height: 466,
                alignment: Alignment.topCenter,
              ),
            ),
          ],
          Text(rotation.value.toString()),
          ElevatedButton(
            onPressed: () {
              // if (_animationController.status == AnimationStatus.dismissed) {
              //   if (Random().nextBool()) {
              //     setState(() {
              //       card = 'assets/card_front.png';
              //     });
              //   } else {
              //     setState(() {
              //       card = 'assets/card_front2.png';
              //     });
              //   }
              // }
              if (_animationController.isCompleted ||
                  _animationController.status == AnimationStatus.forward) {
                _animationController.reverse();
              } else {
                _animationController.forward();
              }
            },
            child: const Text('Flip'),
          ),
        ],
      ),
    );
  }
}
