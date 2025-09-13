import 'package:flutter/material.dart';

class PercentageRing extends StatelessWidget {
  final double percentage;
  final Color color;

  const PercentageRing({super.key, required this.percentage, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(100, 100),
      painter: _RingPainter(percentage: percentage, color: color),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double percentage;
  final Color color;

  _RingPainter({required this.percentage, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = 10.0;
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - stroke;

    final bgPaint = Paint()
      ..strokeWidth = stroke
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke;

    final fgPaint = Paint()
      ..strokeWidth = stroke
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);
    final sweepAngle = 2 * 3.1416 * percentage;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -3.1416 / 2, sweepAngle, false, fgPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
