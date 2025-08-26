import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

/// A rich, animated "TreeScreen" showing:
/// - blue sky with drifting clouds
/// - an ice ground with a slightly melted center revealing a tree
/// - sun (day) or moon (night) depending on device time
/// - animated birds that fly across the screen every ~10 seconds
/// - small playful critters (simple animated circles) near the tree
///
/// Drop this file into your `lib/screens/` folder and add to your routes.
class TreeScreen extends StatefulWidget {
  const TreeScreen({super.key});

  @override
  State<TreeScreen> createState() => _TreeScreenState();
}

class _TreeScreenState extends State<TreeScreen> with TickerProviderStateMixin {
  late final AnimationController _cloudController;
  late final AnimationController _crittersController;

  // We'll use a list of controllers for birds so each can be staggered.
  final List<AnimationController> _birdControllers = [];
  final int _numBirds = 3;

  // Timer to occasionally spawn a new flight pattern (optional)
  Timer? _flightTimer;

  @override
  void initState() {
    super.initState();

    _cloudController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat(); // clouds drift forever

    _crittersController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    // create bird controllers with staggered starts
    for (var i = 0; i < _numBirds; i++) {
      final controller = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 10),
      );
      _birdControllers.add(controller);
      // staggered start
      Future.delayed(Duration(milliseconds: 1500 * i), () {
        if (mounted) controller.repeat();
      });
    }

    // optional: force birds to restart every 10s (keeps them in sync)
    _flightTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      for (final c in _birdControllers) {
        if (mounted) {
          c.forward(from: 0);
        }
      }
    });
  }

  @override
  void dispose() {
    _cloudController.dispose();
    _crittersController.dispose();
    for (final c in _birdControllers) c.dispose();
    _flightTimer?.cancel();
    super.dispose();
  }

  bool get _isDay {
    final h = DateTime.now().hour;
    return h >= 6 && h < 18; // simple day/night split
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade200,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final h = constraints.maxHeight;

            return Stack(
              children: [
                // Sky gradient and sun/moon
                Positioned.fill(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 600),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: _isDay
                            ? [Colors.blue.shade300, Colors.lightBlue.shade100]
                            : [
                                Colors.indigo.shade900,
                                Colors.blueGrey.shade900,
                              ],
                      ),
                    ),
                  ),
                ),

                // Sun or moon
                Positioned(
                  top: 40,
                  right: 30,
                  child: _isDay ? _SunWidget() : _MoonWidget(),
                ),

                // clouds (animated)
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _cloudController,
                    builder: (context, child) {
                      // progress 0..1
                      final t = _cloudController.value;
                      return CustomPaint(painter: _CloudPainter(t));
                    },
                  ),
                ),

                // Birds flying across
                ...List.generate(_numBirds, (i) {
                  final controller = _birdControllers[i];
                  // vertical band for this bird
                  final topOffset = 80.0 + i * 40;
                  return AnimatedBuilder(
                    animation: controller,
                    builder: (context, _) {
                      final progress = controller.value; // 0..1
                      // x goes from -0.2w to 1.2w (offscreen both sides)
                      final x = lerpDouble(-0.2 * w, 1.2 * w, progress)!;
                      // small sine for y
                      final y = topOffset + sin(progress * 2 * pi) * 12;
                      final scale = 0.9 + 0.2 * sin(progress * 2 * pi);
                      return Positioned(
                        left: x,
                        top: y,
                        child: Transform.scale(
                          scale: scale,
                          child: Opacity(
                            opacity: 0.9,
                            child: const Icon(
                              Icons
                                  .airline_seat_recline_normal, // bird-like silhouette
                              size: 28,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),

                // Ice ground with melted center and tree
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: h * 0.45,
                  child: _IceGround(
                    width: w,
                    height: h * 0.45,
                    critterAnimation: _crittersController,
                  ),
                ),

                // small info / back button
                Positioned(
                  left: 12,
                  top: 12,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// -------------------- Sun / Moon widgets --------------------
class _SunWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [Colors.yellow.shade600, Colors.orange.shade400],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.yellow.shade200.withValues(alpha: 0.6),
            blurRadius: 20,
          ),
        ],
      ),
      child: const Center(
        child: Icon(Icons.wb_sunny, color: Colors.white70, size: 36),
      ),
    );
  }
}

class _MoonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.shade200.withValues(alpha: 0.12),
        boxShadow: [BoxShadow(color: Colors.white24, blurRadius: 8)],
      ),
      child: const Center(
        child: Icon(Icons.nightlight_round, color: Colors.white70),
      ),
    );
  }
}

// -------------------- Cloud painter --------------------
class _CloudPainter extends CustomPainter {
  final double progress; // 0..1
  _CloudPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.85);

    // Helper to draw cloud at relative positions that drift with progress
    void drawCloud(double relX, double relY, double scale) {
      final dx = (relX + progress * 0.7) % 1.2 - 0.1; // loop around
      final x = dx * size.width;
      final y = relY * size.height;
      final r = 30.0 * scale;
      canvas.drawCircle(Offset(x, y), r, paint);
      canvas.drawCircle(Offset(x + r * 0.8, y - r * 0.2), r * 0.9, paint);
      canvas.drawCircle(Offset(x + r * 1.6, y + r * 0.1), r * 0.85, paint);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x - r * 0.6, y, r * 2.2, r * 0.9),
          Radius.circular(r * 0.6),
        ),
        paint,
      );
    }

    // multiple clouds, different rows
    drawCloud(0.05, 0.12, 1.0);
    drawCloud(0.35, 0.18, 0.8);
    drawCloud(0.6, 0.08, 1.1);
    drawCloud(0.85, 0.2, 0.7);
  }

  @override
  bool shouldRepaint(covariant _CloudPainter old) => old.progress != progress;
}

// -------------------- Ice ground & tree --------------------
class _IceGround extends StatelessWidget {
  final double width;
  final double height;
  final Animation<double> critterAnimation;

  const _IceGround({
    required this.width,
    required this.height,
    required this.critterAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ice background using custom painter
        Positioned.fill(child: CustomPaint(painter: _IcePainter())),

        // tree in center
        Positioned(
          left: width * 0.5 - 80,
          top: height * 0.12,
          width: 160,
          height: height * 0.7,
          child: const _TreeWidget(),
        ),

        // critters near the tree animated with simple bobbing motion
        AnimatedBuilder(
          animation: critterAnimation,
          builder: (context, _) {
            final t = critterAnimation.value;
            return Positioned(
              left: width * 0.5 - 120,
              bottom: 30 + sin(t * 2 * pi) * 6,
              child: Row(
                children: [
                  _CritterDot(
                    color: Colors.brown.shade300,
                    size: 14 + 3 * sin(t * 2 * pi),
                  ),
                  const SizedBox(width: 8),
                  _CritterDot(
                    color: Colors.orange.shade300,
                    size: 12 + 2 * cos(t * 2 * pi),
                  ),
                  const SizedBox(width: 8),
                  _CritterDot(
                    color: Colors.grey.shade400,
                    size: 10 + 2 * sin((t + 0.5) * 2 * pi),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _CritterDot extends StatelessWidget {
  final Color color;
  final double size;
  const _CritterDot({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 6),
        ],
      ),
    );
  }
}

class _IcePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final icePaint = Paint();
    // ice gradient
    icePaint.shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.white, Colors.blue.shade50, Colors.blue.shade100],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    // draw rounded ice ground
    final groundRect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(
      groundRect,
      const Radius.circular(24),
    );
    canvas.drawRRect(rrect, icePaint);

    // draw subtle cracks / texture
    final crackPaint = Paint()
      ..color = Colors.blueGrey.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final center = Offset(size.width / 2, size.height * 0.35);
    for (var i = 0; i < 8; i++) {
      final angle = (i / 8) * pi * 2;
      final end = Offset(
        center.dx + cos(angle) * 60,
        center.dy + sin(angle) * 40,
      );
      canvas.drawLine(center, end, crackPaint);
    }

    // melted pool (ellipse at center) with slight ripple gradient
    final poolRect = Rect.fromCenter(
      center: center,
      width: size.width * 0.4,
      height: size.height * 0.28,
    );
    final poolPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.lightBlue.shade100.withValues(alpha: 0.9),
          Colors.lightBlue.shade50.withValues(alpha: 0.6),
        ],
      ).createShader(poolRect);
    canvas.drawOval(poolRect, poolPaint);

    // highlight inner rim
    final rimPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..color = Colors.white.withValues(alpha: 0.4);
    canvas.drawOval(poolRect.deflate(6), rimPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// -------------------- Simple stylized tree --------------------
class _TreeWidget extends StatelessWidget {
  const _TreeWidget();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // trunk
        Positioned(
          left: 70,
          bottom: 0,
          child: Container(
            width: 20,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.brown.shade700,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),

        // leaves layers
        Positioned(
          left: 12,
          top: 0,
          child: Column(
            children: [
              _LeafLayer(width: 140, height: 70, offset: 0),
              const SizedBox(height: 6),
              _LeafLayer(width: 120, height: 60, offset: 8),
              const SizedBox(height: 6),
              _LeafLayer(width: 100, height: 50, offset: 16),
            ],
          ),
        ),
      ],
    );
  }
}

class _LeafLayer extends StatelessWidget {
  final double width;
  final double height;
  final double offset;
  const _LeafLayer({
    required this.width,
    required this.height,
    required this.offset,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(offset, 0),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green.shade400, Colors.green.shade700],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.green.shade900.withValues(alpha: 0.25),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
      ),
    );
  }
}
