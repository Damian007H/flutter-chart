import 'package:deriv_chart/src/theme/painting_styles/grid_style.dart';
import 'package:flutter/material.dart';

import '../../../models/chart_axis_config.dart';

/// A `CustomPainter` that paints the Y axis grids.

class YGridLinePainter extends CustomPainter {
  /// Initializes `CustomPainter` that paints the Y axis grids.

  YGridLinePainter({
    required this.gridLineQuotes,
    required this.quoteToCanvasY,
    required this.style,
    required this.labelWidth,
    this.labelPosition = YAxisLabelPosition.right,
    this.labelsOverlay = false,
  });

  /// The list of quotes.
  final List<double> gridLineQuotes;

  /// Conversion function for converting quote to chart's canvas' Y position.
  final double Function(double) quoteToCanvasY;

  /// The style of chart's grid.
  final GridStyle style;

  /// The width of the grid line's label
  final double labelWidth;

  /// Which side to reserve space for Y-axis labels.
  final YAxisLabelPosition labelPosition;

  /// If `true`, do not reserve any space (labels are drawn on top).
  final bool labelsOverlay;

  @override
  void paint(Canvas canvas, Size size) {
    for (final double quote in gridLineQuotes) {
      final double y = quoteToCanvasY(quote);

      final double reservedWidth = labelsOverlay
          ? 0
          : labelWidth + style.labelHorizontalPadding * 2;

      canvas.drawLine(
        Offset(labelPosition == YAxisLabelPosition.left ? reservedWidth : 0, y),
        Offset(
          labelPosition == YAxisLabelPosition.left
              ? size.width
              : size.width - reservedWidth,
          y,
        ),
        Paint()
          ..color = style.gridLineColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = style.lineThickness,
      );
    }
  }

  @override
  bool shouldRepaint(YGridLinePainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(YGridLinePainter oldDelegate) => false;
}
