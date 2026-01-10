import 'package:deriv_chart/src/deriv_chart/chart/helpers/paint_functions/paint_text.dart';
import 'package:deriv_chart/src/deriv_chart/chart/y_axis/y_grid_label_painter.dart';
import 'package:deriv_chart/src/models/chart_axis_config.dart';
import 'package:flutter/material.dart';

/// A painter for drawing Y-axis grid labels in a web-based chart.
///
/// This painter extends [YGridLabelPainter] to provide custom drawing
/// functionality specific to web-based charts.
class YGridLabelPainterWeb extends YGridLabelPainter {
  /// Initialize
  YGridLabelPainterWeb({
    required super.gridLineQuotes,
    required super.pipSize,
    required super.quoteToCanvasY,
    required super.style,
    super.labelPosition,
    super.labelFormatter,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final TextStyle textStyle = TextStyle(
      fontSize: style.yLabelStyle.fontSize,
      height: style.yLabelStyle.height,
      color: style.yLabelStyle.color,
    );

    for (final double quote in gridLineQuotes) {
      final String label = labelFormatter != null
          ? labelFormatter!(quote, pipSize)
          : quote.toStringAsFixed(pipSize);
      final TextPainter painter = makeTextPainter(label, textStyle);
      final y = (quoteToCanvasY(quote) - painter.height).clamp(0.0, size.height - painter.height);

      paintWithTextPainter(
        canvas,
        painter: painter,
        anchor: labelPosition == YAxisLabelPosition.left
            ? Offset(style.labelHorizontalPadding, y)
            : Offset(size.width - style.labelHorizontalPadding, y),
        anchorAlignment: labelPosition == YAxisLabelPosition.left
            ? Alignment.topLeft
            : Alignment.topRight,
      );
    }
  }
}
