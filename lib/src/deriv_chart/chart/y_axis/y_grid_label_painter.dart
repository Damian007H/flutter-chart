import 'package:deriv_chart/src/deriv_chart/chart/helpers/paint_functions/paint_text.dart';
import 'package:deriv_chart/src/models/chart_axis_config.dart';
import 'package:deriv_chart/src/theme/painting_styles/grid_style.dart';
import 'package:flutter/material.dart';

/// A class that paints a lable on the Y axis of grid.
class YGridLabelPainter extends CustomPainter {
  /// initializes a class that paints a lable on the Y axis of grid.
  YGridLabelPainter({
    required this.gridLineQuotes,
    required this.pipSize,
    required this.quoteToCanvasY,
    required this.style,
    this.labelPosition = YAxisLabelPosition.right,
    this.labelFormatter,
  });

  /// Number of digits after decimal point in price.
  final int pipSize;

  /// The list of quotes.
  final List<double> gridLineQuotes;

  /// Conversion function for converting quote to chart's canvas' Y position.
  final double Function(double) quoteToCanvasY;

  /// The style of chart's grid.

  final GridStyle style;

  /// Which side to paint Y-axis labels on.
  final YAxisLabelPosition labelPosition;

  /// Optional formatter for Y-axis labels.
  final String Function(double value, int pipSize)? labelFormatter;

  @override
  void paint(Canvas canvas, Size size) {
    for (final double quote in gridLineQuotes) {
      final double y = quoteToCanvasY(quote);
      final String label = labelFormatter != null
          ? labelFormatter!(quote, pipSize)
          : quote.toStringAsFixed(pipSize);

      paintText(
        canvas,
        text: label,
        style: style.yLabelStyle,
        anchor: labelPosition == YAxisLabelPosition.left
            ? Offset(style.labelHorizontalPadding, y)
            : Offset(size.width - style.labelHorizontalPadding, y),
        anchorAlignment: labelPosition == YAxisLabelPosition.left
            ? Alignment.centerLeft
            : Alignment.centerRight,
      );
    }
  }

  @override
  bool shouldRepaint(YGridLabelPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(YGridLabelPainter oldDelegate) => false;
}
