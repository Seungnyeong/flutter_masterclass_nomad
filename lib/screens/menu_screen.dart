import 'package:flutter/material.dart';
import 'package:flutter_animations_masterclass/screens/apple_watch_screen.dart';
import 'package:flutter_animations_masterclass/screens/container_transform_screen.dart';
import 'package:flutter_animations_masterclass/screens/explict_animations_screen.dart';
import 'package:flutter_animations_masterclass/screens/fade_through_screen.dart';
import 'package:flutter_animations_masterclass/screens/implicit_anmiations_screen.dart';
import 'package:flutter_animations_masterclass/screens/music_player_screen.dart';
import 'package:flutter_animations_masterclass/screens/rive_screen.dart';
import 'package:flutter_animations_masterclass/screens/shared_axis_screen.dart';
import 'package:flutter_animations_masterclass/screens/swiping_cards_screen.dart';
import 'package:flutter_animations_masterclass/screens/wallet_screen.dart';

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
          ElevatedButton(
            onPressed: () {
              _goToPage(context, const SwipingCardsScreen());
            },
            child: const Text('Swiping Cards Screen'),
          ),
          ElevatedButton(
            onPressed: () {
              _goToPage(context, const MusicPlayerScreen());
            },
            child: const Text('Music Player Screen'),
          ),
          ElevatedButton(
            onPressed: () {
              _goToPage(context, const RvieScreenState());
            },
            child: const Text('Rive'),
          ),
          ElevatedButton(
            onPressed: () {
              _goToPage(context, const ContainerTransformScreenState());
            },
            child: const Text('Container Transform'),
          ),
          ElevatedButton(
            onPressed: () {
              _goToPage(context, const SharedAxisScreen());
            },
            child: const Text('Shared Axis'),
          ),
          ElevatedButton(
            onPressed: () {
              _goToPage(context, const FadeThroughScreen());
            },
            child: const Text('Fade Through'),
          ),
          ElevatedButton(
            onPressed: () {
              _goToPage(context, const WalletScreenState());
            },
            child: const Text('Wallet Screen'),
          ),
        ],
      )),
    );
  }
}
