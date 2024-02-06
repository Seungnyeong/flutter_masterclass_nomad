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
    _stateMachineController =
        StateMachineController.fromArtboard(artboard, "state")!;

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
      appBar: AppBar(
        title: const Text('Rive'),
      ),
      body: Center(
          child: Column(
        children: [
          SizedBox(
            height: 400,
            width: double.infinity,
            child: RiveAnimation.asset(
              "assets/animations/old-man-animation.riv",
              artboard: "main",
              stateMachines: const ["state"],
              fit: BoxFit.cover,
              onInit: _onInit,
            ),
          ),
          ElevatedButton(onPressed: _togglePannel, child: const Text('Go!'))
        ],
      )),
    );
  }
}
