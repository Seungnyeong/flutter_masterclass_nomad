import 'dart:math';

import 'package:flutter/material.dart';

class SwipingCardsScreen extends StatefulWidget {
  const SwipingCardsScreen({super.key});

  @override
  State<SwipingCardsScreen> createState() => _SwipingCardsScreenState();
}

// 버튼 체크 버튼, x 버튼 체크버튼을 누르면 사진 이동, X를 누르면 반대로 넘겨야함
// 아이콘의 버튼 새깔 (백그라운드 컬러 했던걸 기억해서 하면 됨) Tween이 필요해!!!
class _SwipingCardsScreenState extends State<SwipingCardsScreen>
    with SingleTickerProviderStateMixin {
  late final size = MediaQuery.of(context).size;
  late final AnimationController _position = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 300,
      ),
      lowerBound: (size.width + 100) * -1,
      upperBound: (size.width + 100),
      value: 0.0);

  late final Tween<double> _rotation = Tween(
    begin: -15,
    end: 15,
  );

  late final Tween<double> _scale = Tween(
    begin: 0.8,
    end: 1,
  );

  late final Tween<double> _buttonScale = Tween(
    begin: 1.0,
    end: 1.1,
  );

  late final ColorTween _cancelButtonBackgroundColor = ColorTween(
    begin: Colors.white,
    end: Colors.red,
  );

  late final ColorTween _cancelButtonIconColor = ColorTween(
    begin: Colors.red,
    end: Colors.white,
  );

  late final ColorTween _checkButtonBackgroundColor = ColorTween(
    begin: Colors.white,
    end: Colors.green,
  );

  late final ColorTween _checkButtonIconColor = ColorTween(
    begin: Colors.green,
    end: Colors.white,
  );

  void _onHorizontalDragUpate(DragUpdateDetails details) {
    _position.value += details.delta.dx;
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    final bound = size.width - 200;
    final dropZone = size.width + 100;
    if (_position.value.abs() >= bound) {
      final factor = _position.value.isNegative ? -1 : 1;
      _position
          .animateTo(dropZone * factor, curve: Curves.bounceOut)
          .whenComplete(_whenComplete);
    } else {
      _position.animateTo(0, curve: Curves.bounceOut);
    }
  }

  void _onCheckPress(bool isNegative) {
    final dropZone = size.width + 100;
    _position
        .animateTo(dropZone * (isNegative ? -1 : 1),
            curve: Curves.bounceOut,
            duration: const Duration(milliseconds: 1000))
        .whenComplete(_whenComplete);
  }

  void _whenComplete() {
    _position.value = 0;
    setState(() {
      _index = _index == 5 ? 1 : _index + 1;
    });
  }

  @override
  void dispose() {
    _position.dispose();
    super.dispose();
  }

  int _index = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Swiping Cards'),
      ),
      body: AnimatedBuilder(
        animation: _position,
        builder: (context, child) {
          final angle = _rotation
                  .transform((_position.value + size.width / 2) / size.width) *
              pi /
              180;
          final scale = _scale.transform(_position.value.abs() / size.width);
          final buttonScale =
              _buttonScale.transform(_position.value.abs() / size.width);

          final cancelButtonBackgroundColor = _cancelButtonBackgroundColor
              .transform(_position.value.abs() / (size.width + 100));

          final cancelButtonIconColor = _cancelButtonIconColor
              .transform(_position.value.abs() / (size.width + 100));

          final checkButtonBackgroundColor = _checkButtonBackgroundColor
              .transform(_position.value.abs() / (size.width + 100));

          final checkButtonIconColor = _checkButtonIconColor
              .transform(_position.value.abs() / (size.width + 100));
          return Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                top: 100,
                child: Transform.scale(
                    scale: min(scale, 1.0),
                    child: Card(
                      index: _index == 5 ? 1 : _index + 1,
                    )),
              ),
              Positioned(
                top: 100,
                child: GestureDetector(
                  onHorizontalDragUpdate: _onHorizontalDragUpate,
                  onHorizontalDragEnd: _onHorizontalDragEnd,
                  child: Transform.translate(
                    offset: Offset(_position.value, 0),
                    child: Transform.rotate(
                        angle: angle,
                        child: Card(
                          index: _index,
                        )),
                  ),
                ),
              ),
              Positioned(
                bottom: 100,
                child: Row(
                  children: [
                    Transform.scale(
                      scale: _position.value.isNegative ? buttonScale : 1.0,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _position.value.isNegative
                              ? cancelButtonBackgroundColor
                              : Colors.white,
                          boxShadow: const <BoxShadow>[
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10.0,
                              spreadRadius: 0,
                              offset: Offset(0.0, 10.0),
                            ),
                          ],
                          border: Border.all(
                            color: Colors.white,
                            width: 5,
                          ),
                        ),
                        child: IconButton(
                          onPressed: () =>
                              _onCheckPress(_position.value.isNegative),
                          icon: Icon(
                            Icons.close_rounded,
                            size: 60,
                            color: _position.value.isNegative
                                ? cancelButtonIconColor
                                : Colors.red,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 30),
                    Transform.scale(
                      scale: !_position.value.isNegative ? buttonScale : 1.0,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: !_position.value.isNegative
                              ? checkButtonBackgroundColor
                              : Colors.white,
                          boxShadow: const <BoxShadow>[
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10.0,
                              spreadRadius: 0,
                              offset: Offset(0.0, 10.0),
                            ),
                          ],
                          border: Border.all(
                            color: Colors.white,
                            width: 5,
                          ),
                        ),
                        child: IconButton(
                          onPressed: () =>
                              _onCheckPress(_position.value.isNegative),
                          icon: Icon(
                            Icons.check,
                            size: 60,
                            color: !_position.value.isNegative
                                ? checkButtonIconColor
                                : Colors.green,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class Card extends StatelessWidget {
  final int index;
  const Card({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        width: size.width * 0.8,
        height: size.height * 0.5,
        child: Image.asset("assets/covers/$index.jpeg", fit: BoxFit.cover),
      ),
    );
  }
}
