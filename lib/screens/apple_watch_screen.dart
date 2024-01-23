import 'dart:math';

import 'package:flutter/material.dart';

class AppleWatchScreen extends StatefulWidget {
  const AppleWatchScreen({super.key});

  @override
  State<AppleWatchScreen> createState() => _AppleWatchScreenState();
}

class _AppleWatchScreenState extends State<AppleWatchScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..forward();

  late final CurvedAnimation _curve =
      CurvedAnimation(parent: _animationController, curve: Curves.bounceOut);

  List<double> initRandomValues =
      List.generate(3, (index) => Random().nextDouble() * 2.0);

  late List<Animation<double>> progressList = List.generate(
      3,
      (index) =>
          Tween(begin: 0.005, end: initRandomValues[index]).animate(_curve));

  void _animateValues() {
    List<double> newBeginPoints =
        List.generate(3, (index) => progressList[index].value);
    List<double> randomNumbers =
        List.generate(3, (index) => Random().nextDouble() * 2.0);
    List<double> newEndPoints = List.generate(3, (index) => 0.0);
    for (int i = 0; i < progressList.length; i++) {
      newEndPoints[i] = randomNumbers[i];
    }

    for (int i = 0; i < progressList.length; i++) {
      progressList[i] =
          Tween(begin: newBeginPoints[i], end: newEndPoints[i]).animate(_curve);
    }
    setState(() {});

    _animationController.forward(from: 0);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  //코드 챌린지 1 : 처음시작시 end가 모두 다르게 진행률 바가 모두 다르게
  // 코드 챌린지 2 : 진행률 바가 다른 지점으로 가게

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Apple Watch"),
      ),
      body: Center(
          child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return CustomPaint(
            painter: AppleWatchPainter(
              redProgress: progressList[0].value,
              blueProgress: progressList[1].value,
              greenProgress: progressList[2].value,
            ),
            size: const Size(400, 400),
          );
        },
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: _animateValues,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class AppleWatchPainter extends CustomPainter {
  final double redProgress;
  final double blueProgress;
  final double greenProgress;

  AppleWatchPainter({
    required this.redProgress,
    required this.blueProgress,
    required this.greenProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    //draw red
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    const startingAngle = -0.5 * pi;

    final redCirclePaint = Paint()
      ..color = Colors.red.shade400.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25;

    final redCircleRadius = (size.width / 2) * 0.9;
    final greenCircleRadius = (size.width / 2) * 0.76;
    final blueCircleRadius = (size.width / 2) * 0.62;

    canvas.drawCircle(center, redCircleRadius, redCirclePaint);
    //draw green

    final greenCirclePaint = Paint()
      ..color = Colors.green.shade400.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25;

    canvas.drawCircle(center, greenCircleRadius, greenCirclePaint);
    //draw blue
    final blueCirclePaint = Paint()
      ..color = Colors.blue.shade400.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25;

    canvas.drawCircle(center, blueCircleRadius, blueCirclePaint);

    // red arc
    final redArcRect = Rect.fromCircle(center: center, radius: redCircleRadius);
    final redArcPaint = Paint()
      ..color = Colors.red.shade400
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 25;
    canvas.drawArc(
      redArcRect,
      startingAngle,
      redProgress * pi,
      false,
      redArcPaint,
    );

    // green arc
    final greenArcRect =
        Rect.fromCircle(center: center, radius: greenCircleRadius);
    final greenArcPaint = Paint()
      ..color = Colors.green.shade400
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 25;
    canvas.drawArc(
      greenArcRect,
      startingAngle,
      greenProgress * pi,
      false,
      greenArcPaint,
    );

    // blue arc
    final blueArcRect =
        Rect.fromCircle(center: center, radius: blueCircleRadius);
    final blueArcPaint = Paint()
      ..color = Colors.cyan.shade400
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 25;
    canvas.drawArc(
      blueArcRect,
      startingAngle,
      blueProgress * pi,
      false,
      blueArcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant AppleWatchPainter oldDelegate) {
    return (oldDelegate.redProgress != redProgress) ||
        (oldDelegate.blueProgress != blueProgress) ||
        (oldDelegate.greenProgress != greenProgress);
  }
}
