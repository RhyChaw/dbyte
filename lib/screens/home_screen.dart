import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int currentStep = 0;

  final List<Offset> puddlePositions = [
    const Offset(100, 150),
    const Offset(220, 300),
    const Offset(120, 450),
    const Offset(240, 600),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: Stack(
        children: [
          // River background
          CustomPaint(
            size: MediaQuery.of(context).size,
            painter: RiverPainter(puddlePositions),
          ),

          // Puddles with step numbers
          ...List.generate(puddlePositions.length, (index) {
            final pos = puddlePositions[index];
            return Positioned(
              left: pos.dx - 25,
              top: pos.dy - 25,
              child: GestureDetector(
                onTap: () {
                  if (index == currentStep) {
                    setState(() {
                      currentStep++;
                    });
                  }
                },
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: index <= currentStep
                      ? Colors.green
                      : Colors.white,
                  child: Text(
                    "${index + 1}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: index <= currentStep
                          ? Colors.white
                          : Colors.blueAccent,
                    ),
                  ),
                ),
              ),
            );
          }),

          // Happy image jumping on the current puddle
          if (currentStep < puddlePositions.length)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOut,
              left: puddlePositions[currentStep].dx - 30,
              top: puddlePositions[currentStep].dy - 80,
              child: Image.asset('images/Happy.png', height: 60),
            ),
        ],
      ),
    );
  }
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
