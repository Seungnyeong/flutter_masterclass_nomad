import 'dart:async';

import 'package:flutter/material.dart';

class ExplictAnimationScreen extends StatefulWidget {
  const ExplictAnimationScreen({super.key});

  @override
  State<ExplictAnimationScreen> createState() => _ExplictAnimationScreenState();
}

class _ExplictAnimationScreenState extends State<ExplictAnimationScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  );

  late final Animation<Color?> _color = ColorTween(
    begin: Colors.amber,
    end: Colors.red,
  ).animate(_animationController);
  @override
  void initState() {
    super.initState();
  }

  void _play() {
    _animationController.forward();
  }

  void _pause() {
    _animationController.stop();
  }

  void _rewind() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Explicit Animations "),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _color,
            builder: (context, child) {
              return Container(
                child: Container(
                  color: _color.value,
                  width: 400,
                  height: 400,
                ),
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _play,
                child: const Text("play"),
              ),
              ElevatedButton(
                onPressed: _pause,
                child: const Text("pause"),
              ),
              ElevatedButton(
                onPressed: _rewind,
                child: const Text("rewind"),
              ),
            ],
          )
        ],
      )),
    );
  }
}
