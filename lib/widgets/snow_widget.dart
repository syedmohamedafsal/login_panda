import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'snow_painter.dart';

class SnowWidget extends StatefulWidget {
  final int numberOfSnowflakes;

  const SnowWidget({super.key, this.numberOfSnowflakes = 150});

  @override
  State<SnowWidget> createState() => _SnowWidgetState();
}

class _SnowWidgetState extends State<SnowWidget>
    with SingleTickerProviderStateMixin {
  late List<Snowflake> snowflakes;
  final Random random = Random();
  late Timer timer;

  @override
  void initState() {
    super.initState();

    snowflakes = List.generate(widget.numberOfSnowflakes, (index) {
      return Snowflake(
        x: random.nextDouble() * 400,
        y: random.nextDouble() * 600,
        radius: 2 + random.nextDouble() * 3,
        speed: 0.5 + random.nextDouble() * 2,
        drift: random.nextDouble() * 1.5 - 0.75, // sideways movement
      );
    });

    timer = Timer.periodic(const Duration(milliseconds: 30), (_) {
      setState(() {
        for (final snow in snowflakes) {
          snow.y += snow.speed;
          snow.x += snow.drift;

          // Wrap around horizontally
          if (snow.x > MediaQuery.of(context).size.width) snow.x = 0;
          if (snow.x < 0) snow.x = MediaQuery.of(context).size.width;

          // Reset to top if hits bottom snow hill (~50 pixels from bottom)
          if (snow.y > MediaQuery.of(context).size.height - 50) {
            snow.y = 0;
            snow.x = random.nextDouble() * MediaQuery.of(context).size.width;
          }
        }
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size.infinite, painter: SnowPainter(snowflakes));
  }
}
