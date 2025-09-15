import 'package:flutter/material.dart';
import 'dart:math';

class SparklinePainter extends CustomPainter {
  final List<double> points;
  final Color color;

  SparklinePainter({required this.points, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final paintLine = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;

    final paintFill = Paint()
      ..color = color.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final minP = points.reduce(min);
    final maxP = points.reduce(max);
    final range = (maxP - minP) == 0 ? 1.0 : (maxP - minP);

    final path = Path();
    for (int i = 0; i < points.length; i++) {
      final x = (i / (points.length - 1)) * size.width;
      final y = size.height - ((points[i] - minP) / range) * size.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(fillPath, paintFill);
    canvas.drawPath(path, paintLine);
  }

  @override
  bool shouldRepaint(covariant SparklinePainter old) {
    return old.points != points || old.color != color;
  }
}
