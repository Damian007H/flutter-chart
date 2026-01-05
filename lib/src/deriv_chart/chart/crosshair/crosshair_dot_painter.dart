import 'package:flutter/material.dart';

/// A custom painter to paint the crossshair `dot`.
class CrosshairDotPainter extends CustomPainter {
  /// Initializes a custom painter to paint the crossshair `dot`.
  const CrosshairDotPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
      const Offset(0, 0),
      3,
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(CrosshairDotPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(CrosshairDotPainter oldDelegate) => false;
}
