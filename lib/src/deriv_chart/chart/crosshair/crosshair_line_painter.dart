import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// A custom painter to paint the crossshair `line`.
class CrosshairLinePainter extends CustomPainter {
  /// Initializes a custom painter to paint the crossshair `line`.
  const CrosshairLinePainter(this.upperStartColor, this.upperEndColor, this.lowerStartColor, this.lowerEndColor);

  final Color upperStartColor;
  final Color upperEndColor;
  final Color lowerStartColor;
  final Color lowerEndColor;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(
      const Offset(0, 8),
      Offset(0, size.height),
      Paint()
        ..strokeWidth = 2
        ..style = PaintingStyle.fill
        ..shader = ui.Gradient.linear(
          Offset.zero,
          Offset(0, size.height),
          <Color>[
            upperStartColor,
            upperEndColor,
            lowerStartColor,
            lowerEndColor,
          ],
          <double>[0.5, 0.5, 0.5, 1],
        ),
    );
  }

  @override
  bool shouldRepaint(CrosshairLinePainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(CrosshairLinePainter oldDelegate) => false;
}
