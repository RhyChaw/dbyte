import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/animated_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int currentStep = 0;

  final List<Offset> puddlePositions = [
    const Offset(100, 150),
    const Offset(220, 300),
    const Offset(120, 450),
    const Offset(240, 600),
  ];

  late AnimationController _puddleController;
  late AnimationController _characterController;
  late AnimationController _rippleController;
  late AnimationController _backgroundController;

  late Animation<double> _puddleScaleAnimation;
  late Animation<double> _characterBounceAnimation;
  late Animation<double> _rippleAnimation;
  late Animation<double> _backgroundAnimation;

  @override
  void initState() {
    super.initState();

    // Puddle animation controller
    _puddleController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    // Character bounce animation
    _characterController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    // Ripple effect animation
    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Background animation
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _puddleScaleAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _puddleController, curve: Curves.easeInOut),
    );

    _characterBounceAnimation = Tween<double>(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(parent: _characterController, curve: Curves.elasticInOut),
    );

    _rippleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rippleController, curve: Curves.easeOut),
    );

    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_backgroundController);
  }

  @override
  void dispose() {
    _puddleController.dispose();
    _characterController.dispose();
    _rippleController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  void _onPuddleTap(int index) {
    if (index == currentStep) {
      // Add haptic feedback
      HapticFeedback.mediumImpact();

      // Start ripple animation
      _rippleController.forward().then((_) {
        _rippleController.reset();
      });

      setState(() {
        currentStep++;
      });
    } else {
      // Wrong puddle - add light haptic feedback
      HapticFeedback.lightImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: AnimatedBuilder(
        animation: _backgroundController,
        builder: (context, child) {
          return Stack(
            children: [
              // Animated River background
              CustomPaint(
                size: MediaQuery.of(context).size,
                painter: AnimatedRiverPainter(
                  puddlePositions,
                  _backgroundAnimation.value,
                ),
              ),

              // Animated puddles with step numbers
              ...List.generate(puddlePositions.length, (index) {
                final pos = puddlePositions[index];
                final isActive = index == currentStep;
                final isCompleted = index < currentStep;

                return Positioned(
                  left: pos.dx - 30,
                  top: pos.dy - 30,
                  child: AnimatedBuilder(
                    animation: _puddleController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: isActive ? _puddleScaleAnimation.value : 1.0,
                        child: GestureDetector(
                          onTap: () => _onPuddleTap(index),
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: isCompleted
                                    ? [
                                        Colors.green.shade400,
                                        Colors.green.shade600,
                                      ]
                                    : isActive
                                    ? [
                                        Colors.blue.shade300,
                                        Colors.blue.shade500,
                                      ]
                                    : [Colors.white, Colors.grey.shade200],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: (isActive ? Colors.blue : Colors.green)
                                      .withOpacity(0.3),
                                  blurRadius: isActive ? 15 : 8,
                                  spreadRadius: isActive ? 2 : 1,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                "${index + 1}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: isCompleted || isActive
                                      ? Colors.white
                                      : Colors.blueAccent,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),

              // Ripple effect for current puddle
              if (currentStep < puddlePositions.length)
                AnimatedBuilder(
                  animation: _rippleAnimation,
                  builder: (context, child) {
                    final pos = puddlePositions[currentStep];
                    return Positioned(
                      left: pos.dx - 40 - (_rippleAnimation.value * 20),
                      top: pos.dy - 40 - (_rippleAnimation.value * 20),
                      child: Container(
                        width: 80 + (_rippleAnimation.value * 40),
                        height: 80 + (_rippleAnimation.value * 40),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.blue.withOpacity(
                              1 - _rippleAnimation.value,
                            ),
                            width: 3,
                          ),
                        ),
                      ),
                    );
                  },
                ),

              // Animated Happy image jumping on the current puddle
              if (currentStep < puddlePositions.length)
                AnimatedBuilder(
                  animation: _characterController,
                  builder: (context, child) {
                    final pos = puddlePositions[currentStep];
                    return AnimatedPositioned(
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeInOut,
                      left: pos.dx - 30,
                      top: pos.dy - 80 - _characterBounceAnimation.value,
                      child: Transform.scale(
                        scale: 1.0 + (_characterBounceAnimation.value * 0.05),
                        child: Image.asset('images/Happy.png', height: 60),
                      ),
                    );
                  },
                ),

              // Progress indicator
              Positioned(
                top: 50,
                left: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Your Journey",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: currentStep / puddlePositions.length,
                        backgroundColor: Colors.blue.shade100,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.blue.shade400,
                        ),
                        minHeight: 8,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Step ${currentStep + 1} of ${puddlePositions.length}",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Floating action button for next step
              if (currentStep < puddlePositions.length)
                Positioned(
                  bottom: 100,
                  right: 20,
                  child: AnimatedFloatingActionButton(
                    icon: Icons.arrow_forward,
                    backgroundColor: Colors.blue.shade400,
                    foregroundColor: Colors.white,
                    tooltip: "Next Step",
                    onPressed: () {
                      if (currentStep < puddlePositions.length) {
                        _onPuddleTap(currentStep);
                      }
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class AnimatedRiverPainter extends CustomPainter {
  final List<Offset> puddles;
  final double animationValue;

  AnimatedRiverPainter(this.puddles, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    // Animated river with flowing effect
    final paint = Paint()
      ..color = Colors.blueAccent.withOpacity(0.3 + (animationValue * 0.1))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 40 + (animationValue * 5)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    if (puddles.isNotEmpty) {
      path.moveTo(puddles.first.dx, puddles.first.dy);
      for (var i = 1; i < puddles.length; i++) {
        // Add wave effect to the river
        final waveOffset = sin(animationValue * 2 * 3.14159 + i) * 10;
        path.quadraticBezierTo(
          puddles[i - 1].dx + 20,
          puddles[i - 1].dy + waveOffset,
          puddles[i].dx,
          puddles[i].dy + waveOffset,
        );
      }
    }
    canvas.drawPath(path, paint);

    // Add floating particles
    for (int i = 0; i < 10; i++) {
      final x = (animationValue * 100 + i * 50) % size.width;
      final y = 100 + sin(animationValue * 2 * 3.14159 + i) * 20;

      final particlePaint = Paint()
        ..color = Colors.white.withOpacity(0.6 - (animationValue * 0.3))
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(x, y), 3, particlePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class RiverPainter extends CustomPainter {
  final List<Offset> puddles;

  RiverPainter(this.puddles);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blueAccent.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 40
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    if (puddles.isNotEmpty) {
      path.moveTo(puddles.first.dx, puddles.first.dy);
      for (var i = 1; i < puddles.length; i++) {
        path.lineTo(puddles[i].dx, puddles[i].dy);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
