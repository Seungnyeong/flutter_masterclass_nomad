import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class RvieScreenState extends StatefulWidget {
  const RvieScreenState({super.key});

  @override
  State<RvieScreenState> createState() => _RvieScreenStateState();
}

class _RvieScreenStateState extends State<RvieScreenState> {
  late final StateMachineController _stateMachineController;
  void _onInit(Artboard artboard) {
    _stateMachineController = StateMachineController.fromArtboard(
      artboard,
      "state",
      onStateChange: (stateMachineName, stateName) {},
    )!;

    artboard.addController(_stateMachineController);
  }

  void _togglePannel() {
    final input = _stateMachineController.findInput<bool>("panelActive")!;

    input.change(!input.value);
  }

  @override
  void dispose() {
    _stateMachineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const RiveAnimation.asset(
            "assets/animations/balls-animation.riv",
            fit: BoxFit.cover,
          ),
          Positioned.fill(
              child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 30),
            child: const Center(
              child: Text(
                "Welcome to AI App",
                style: TextStyle(
                  fontSize: 28,
                ),
              ),
            ),
          ))
        ],
      ),
    );
  }
}
