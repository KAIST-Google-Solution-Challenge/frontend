import 'dart:math';

import 'package:flutter/material.dart';

class DoughnutChart extends StatelessWidget {
  final bool isChat;
  final double radius;
  final double probability;

  DoughnutChart({
    super.key,
    required this.isChat,
    required this.radius,
    required this.probability,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;

    if (isChat) {
      return Stack(
        alignment: Alignment.center,
        children: [
          SweepCircle(
            radius: 2 * radius,
            probability: probability - 100,
            color: colorScheme.secondary,
          ),
          SweepCircle(
            radius: 2 * radius,
            probability: probability,
            color: colorScheme.primary,
          ),
          Container(
            width: radius,
            height: radius,
            decoration: BoxDecoration(
              color: ElevationOverlay.applySurfaceTint(
                colorScheme.background,
                colorScheme.surfaceTint,
                1,
              ),
              borderRadius: BorderRadius.circular(radius / 2),
            ),
          ),
        ],
      );
    } else {
      return Stack(
        alignment: Alignment.center,
        children: [
          SweepCircle(
            radius: 2 * radius,
            probability: probability - 100,
            color: colorScheme.secondary,
          ),
          SweepCircle(
            radius: 2 * radius,
            probability: probability,
            color: colorScheme.primary,
          ),
          Container(
            width: radius,
            height: radius,
            decoration: BoxDecoration(
              color: ElevationOverlay.applySurfaceTint(
                colorScheme.background,
                colorScheme.surfaceTint,
                1,
              ),
              borderRadius: BorderRadius.circular(radius / 2),
            ),
          ),
          Text(probability.toString(), style: textTheme.displaySmall)
        ],
      );
    }
  }
}

class SweepCircle extends StatelessWidget {
  final double radius;
  final double probability;
  final Color color;

  SweepCircle({
    required this.radius,
    required this.probability,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(radius, radius),
      painter: SweepPainter(probability: probability, color: color),
    );
  }
}

class SweepPainter extends CustomPainter {
  final double probability;
  final Color color;

  SweepPainter({required this.probability, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      1.5 * pi,
      2 * pi * probability / 100,
      true,
      paint,
    );
  }

  @override
  bool shouldRepaint(SweepPainter oldDelegate) {
    return oldDelegate.probability != probability || oldDelegate.color != color;
  }
}
