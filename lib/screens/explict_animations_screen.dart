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
  )..addListener(() {
      _value.value = _animationController.value;
    });

  late final Animation<Decoration> _decoration = DecorationTween(
      begin: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(20),
      ),
      end: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(120),
      )).animate(_curved);

  late final Animation<double> _rotation =
      Tween(begin: 0.0, end: 0.5).animate(_curved);

  late final Animation<double> _scale =
      Tween(begin: 1.0, end: 1.3).animate(_curved);

  late final Animation<Offset> _offset =
      Tween(begin: Offset.zero, end: const Offset(0, -0.2)).animate(_curved);

  late final CurvedAnimation _curved = CurvedAnimation(
    parent: _animationController,
    curve: Curves.elasticOut,
    reverseCurve: Curves.bounceIn,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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

  final ValueNotifier<double> _value = ValueNotifier(0.0);

  void _onChaange(double value) {
    _value.value = 0;
    _animationController.value = value;
  }

  bool _looping = false;
  void _toggleLopping() {
    if (_looping) {
      _animationController.stop();
    } else {
      _animationController.repeat(reverse: true);
    }

    setState(() {
      _looping = !_looping;
    });
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
          SlideTransition(
            position: _offset,
            child: RotationTransition(
              turns: _rotation,
              child: DecoratedBoxTransition(
                  decoration: _decoration,
                  child: const SizedBox(
                    height: 400,
                    width: 400,
                  )),
            ),
          ),
          const SizedBox(
            height: 50,
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
              ElevatedButton(
                onPressed: _toggleLopping,
                child: Text(_looping ? "Stop lopping" : "Start lopping"),
              ),
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          ValueListenableBuilder(
              valueListenable: _value,
              builder: (context, value, child) {
                return Slider(value: _value.value, onChanged: _onChaange);
              }),
        ],
      )),
    );
  }
}
