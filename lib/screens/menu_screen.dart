import 'package:flutter/material.dart';
import 'package:flutter_animations_masterclass/screens/apple_watch_screen.dart';
import 'package:flutter_animations_masterclass/screens/explict_animations_screen.dart';
import 'package:flutter_animations_masterclass/screens/implicit_anmiations_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  void _goToPage(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Animiations"),
      ),
      body: Center(
          child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              _goToPage(context, const ImplicitAnimationsScreen());
            },
            child: const Text('Implicit Animations'),
          ),
          ElevatedButton(
            onPressed: () {
              _goToPage(context, const ExplictAnimationScreen());
            },
            child: const Text('Explicit Animations'),
          ),
          ElevatedButton(
            onPressed: () {
              _goToPage(context, const AppleWatchScreen());
            },
            child: const Text('Apple Watch Face'),
          ),
        ],
      )),
    );
  }
}
