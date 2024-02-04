import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MusicPlayerDetailScreen extends StatefulWidget {
  final int index;

  const MusicPlayerDetailScreen({super.key, required this.index});

  @override
  State<MusicPlayerDetailScreen> createState() =>
      _MusicPlayerDetailScreenState();
}

class _MusicPlayerDetailScreenState extends State<MusicPlayerDetailScreen>
    with TickerProviderStateMixin {
  late final AnimationController _progressController =
      AnimationController(vsync: this, duration: const Duration(minutes: 1))
        ..repeat(
          reverse: true,
        );

  late final AnimationController _playPauseContoller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );

  late final AnimationController _marqueeController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 20),
  )..repeat(reverse: true);

  late final Animation<Offset> _marqueeTween = Tween(
    begin: const Offset(0.1, 0),
    end: const Offset(-0.6, 0),
  ).animate(_marqueeController);

  late final AnimationController _menuController = AnimationController(
    vsync: this,
    duration: const Duration(
      seconds: 1,
    ),
    reverseDuration: const Duration(seconds: 1),
  );

  late final Curve _menuCurve = Curves.easeInOutCubic;

  late final Animation<double> _screenScale = Tween(begin: 1.0, end: 0.7)
      .animate(CurvedAnimation(
          parent: _menuController,
          curve: Interval(0.0, 0.5, curve: _menuCurve)));
  late final Animation<Offset> _screenOffset =
      Tween(begin: Offset.zero, end: const Offset(0.5, 0))
          .animate(CurvedAnimation(
              parent: _menuController,
              curve: Interval(
                0.5,
                1.0,
                curve: _menuCurve,
              )));
  late final Animation<double> _closeButtonOpacity = Tween(
    begin: 0.0,
    end: 1.0,
  ).animate(
    CurvedAnimation(
      parent: _menuController,
      curve: Interval(
        0.3,
        0.5,
        curve: _menuCurve,
      ),
    ),
  );

  late final List<Animation<Offset>> _menuAnimation = [
    for (var i = 0; i < _menus.length; i++)
      Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero)
          .animate(CurvedAnimation(
        parent: _menuController,
        curve: Interval(
          0.4 + (0.1 * i),
          0.7 + (0.1 * i),
          curve: _menuCurve,
        ),
      )),
  ];

  late final Animation<Offset> _logoutSlide =
      Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero)
          .animate(CurvedAnimation(
    parent: _menuController,
    curve: Interval(
      0.8,
      1.0,
      curve: _menuCurve,
    ),
  ));

  @override
  void dispose() {
    _progressController.dispose();
    _marqueeController.dispose();
    _playPauseContoller.dispose();
    _menuController.dispose();
    super.dispose();
  }

  String toTimeString(double value) {
    final duration = Duration(milliseconds: (value * 60000).toInt());
    final timeString =
        '${duration.inMinutes.toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
    return timeString;
  }

  void _onPlayPauseTap() {
    if (_playPauseContoller.isCompleted) {
      _playPauseContoller.reverse();
    } else {
      _playPauseContoller.forward();
    }
  }

  bool _dragging = false;

  void _toggleDragging() {
    setState(() {
      _dragging = !_dragging;
    });
  }

  final ValueNotifier<double> _volume = ValueNotifier(0);
  late final size = MediaQuery.of(context).size;

  void _onVolumeDragUpdate(DragUpdateDetails details) {
    _volume.value += details.delta.dx;
    _volume.value = _volume.value.clamp(
      0.0,
      size.width - 80,
    );
  }

  void _closeMenu() {
    _menuController.reverse();
  }

  void _openMenu() {
    _menuController.forward();
  }

  final List<Map<String, dynamic>> _menus = [
    {
      "icon": Icons.person,
      "text": "Profile",
    },
    {
      "icon": Icons.notifications,
      "text": "Notifications",
    },
    {
      "icon": Icons.settings,
      "text": "Settings",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          leading: FadeTransition(
            opacity: _closeButtonOpacity,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: _closeMenu,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(children: [
            const SizedBox(
              height: 30,
            ),
            for (var i = 0; i < _menus.length; i++) ...[
              SlideTransition(
                position: _menuAnimation[i],
                child: Row(
                  children: [
                    Icon(
                      _menus[i]["icon"],
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      _menus[i]["text"],
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 18,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              )
            ],
            const Spacer(),
            SlideTransition(
              position: _logoutSlide,
              child: Row(
                children: [
                  Icon(
                    Icons.logout,
                    color: Colors.red.shade500,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "logout",
                    style: TextStyle(
                      color: Colors.red.shade500,
                      fontSize: 18,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 100,
            )
          ]),
        ),
      ),
      SlideTransition(
        position: _screenOffset,
        child: ScaleTransition(
          scale: _screenScale,
          child: Scaffold(
            appBar: AppBar(
              title: const Text("Interstellar"),
              actions: [
                IconButton(onPressed: _openMenu, icon: const Icon(Icons.menu))
              ],
            ),
            body: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Hero(
                    tag: "${widget.index}",
                    child: Container(
                      height: 350,
                      width: 350,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 20,
                            spreadRadius: 2,
                            offset: const Offset(0, 8),
                          )
                        ],
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(
                                "assets/covers/${widget.index}.jpeg")),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                AnimatedBuilder(
                  animation: _progressController,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: ProgressBar(
                        progressValue: _progressController.value,
                      ),
                      size: Size(
                        size.width - 80,
                        5,
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                AnimatedBuilder(
                  animation: _progressController,
                  builder: (context, child) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Row(
                        children: [
                          Text(
                            toTimeString(_progressController.value),
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w600),
                          ),
                          const Spacer(),
                          Text(
                            toTimeString(1 - _progressController.value),
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text("Interstellar",
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
                const SizedBox(
                  height: 5,
                ),
                SlideTransition(
                  position: _marqueeTween,
                  child: const Text(
                    "A Film By Christopher Nolan - Original Motion Picture Sound Track",
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.visible,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: _onPlayPauseTap,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedIcon(
                        icon: AnimatedIcons.pause_play,
                        progress: _playPauseContoller,
                        size: 60,
                      ),
                      // 로티를 사용하여 애니메이션을 사서 사용할 수 있다.
                      // LottieBuilder.asset(
                      //   "assets/animations/play-lottie.json",
                      //   controller: _playPauseContoller,
                      //   onLoaded: (composition) {
                      //     _playPauseContoller.duration = composition.duration;
                      //   },
                      //   width: 200,
                      //   height: 200,
                      // ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onHorizontalDragUpdate: _onVolumeDragUpdate,
                  onHorizontalDragStart: (_) => _toggleDragging(),
                  onHorizontalDragEnd: (_) => _toggleDragging(),
                  child: AnimatedScale(
                    scale: _dragging ? 1.1 : 1,
                    duration: const Duration(
                      milliseconds: 500,
                    ),
                    curve: Curves.bounceOut,
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ValueListenableBuilder(
                        valueListenable: _volume,
                        builder: (context, value, child) => CustomPaint(
                          size: Size(size.width - 80, 50),
                          painter: VolumPaint(
                            volume: value,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ]);
  }
}

class ProgressBar extends CustomPainter {
  final double progressValue;
  ProgressBar({required this.progressValue});
  @override
  void paint(Canvas canvas, Size size) {
    final progress = size.width * progressValue;
    // track
    final trackPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.fill;

    final trackRRect = RRect.fromLTRBR(
      0,
      0,
      size.width,
      size.height,
      const Radius.circular(10),
    );

    canvas.drawRRect(trackRRect, trackPaint);

    // progress
    final progressPaint = Paint()
      ..color = Colors.grey.shade500
      ..style = PaintingStyle.fill;

    final progressRRect =
        RRect.fromLTRBR(0, 0, progress, size.height, const Radius.circular(10));

    canvas.drawRRect(progressRRect, progressPaint);

    // thumb
    canvas.drawCircle(Offset(progress, size.height / 2), 10, progressPaint);
  }

  @override
  bool shouldRepaint(covariant ProgressBar oldDelegate) {
    return oldDelegate.progressValue != progressValue;
  }
}

class VolumPaint extends CustomPainter {
  final double volume;
  VolumPaint({
    required this.volume,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = Colors.grey.shade300;
    final bgRect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(bgRect, bgPaint);

    final volumePaint = Paint()..color = Colors.grey.shade500;
    final volumRect = Rect.fromLTRB(0, 0, volume, size.height);
    canvas.drawRect(volumRect, volumePaint);
  }

  @override
  bool shouldRepaint(covariant VolumPaint oldDelegate) {
    return oldDelegate.volume != volume;
  }
}
