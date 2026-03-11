import 'dart:math';
import 'package:flutter/material.dart';

class SnowPainter extends CustomPainter {
  final List<Snowflake> snowflakes;

  SnowPainter(this.snowflakes);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        2,
      ); // soft snow edges

    // Draw snowflakes
    for (final snow in snowflakes) {
      canvas.drawCircle(Offset(snow.x, snow.y), snow.radius, paint);
    }

    // Draw smooth snow hill at bottom
    final hillPath = Path();
    hillPath.moveTo(0, size.height);

    int segments = 30; // More segments = smoother hill
    double step = size.width / segments;
    for (int i = 0; i <= segments; i++) {
      double x = i * step;
      // Smooth hill using combination of sine waves for natural look
      double y =
          size.height -
          100 +
          15 * sin(x / 50) +
          10 * cos(x / 30) +
          5 * sin(x / 10);
      hillPath.lineTo(x, y);
    }

    hillPath.lineTo(size.width, size.height);
    hillPath.close();

    // Draw hill with soft edges
    canvas.drawShadow(hillPath, Colors.black.withOpacity(0.1), 4, false);
    canvas.drawPath(hillPath, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Snowflake model
class Snowflake {
  double x;
  double y;
  double radius;
  double speed;
  double drift; // horizontal drift for wind effect

  Snowflake({
    required this.x,
    required this.y,
    required this.radius,
    required this.speed,
    this.drift = 0,
  });
}
