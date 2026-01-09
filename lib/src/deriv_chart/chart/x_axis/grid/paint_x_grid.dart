import 'package:deriv_chart/src/deriv_chart/chart/helpers/paint_functions/paint_text.dart';
import 'package:deriv_chart/src/deriv_chart/chart/x_axis/grid/check_new_day.dart';
import 'package:deriv_chart/src/deriv_chart/chart/x_axis/grid/time_label.dart';
import 'package:deriv_chart/src/deriv_chart/chart/y_axis/y_axis_config.dart';
import 'package:deriv_chart/src/theme/chart_theme.dart';
import 'package:deriv_chart/src/theme/painting_styles/grid_style.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Paints x-axis grid lines and labels.
void paintXGrid(
  Canvas canvas,
  Size size, {
  required List<double> xCoords,
  required ChartTheme style,
  required List<DateTime> timestamps,
  required double msPerPx,
  String Function(DateTime time)? xAxisLabelFormatter,
  bool showGridLines = true,
  bool showLabels = true,
}) {
  assert(timestamps.length == xCoords.length);
  final GridStyle gridStyle = style.gridStyle;

  if (showGridLines) {
    _paintTimeGridLines(
      canvas,
      size,
      xCoords,
      style,
      gridStyle,
      timestamps,
      msPerPx,
    );
  }

  if (showLabels) {
    if (kIsWeb) {
      _paintTimeLabelsWeb(
        canvas,
        size,
        xCoords: xCoords,
        gridStyle: gridStyle,
        timestamps: timestamps,
        xAxisLabelFormatter: xAxisLabelFormatter,
      );
    } else {
      _paintTimeLabels(
        canvas,
        size,
        xCoords: xCoords,
        gridStyle: gridStyle,
        timestamps: timestamps,
        xAxisLabelFormatter: xAxisLabelFormatter,
      );
    }
  }
}

void _paintTimeGridLines(
  Canvas canvas,
  Size size,
  List<double> xCoords,
  ChartTheme style,
  GridStyle gridStyle,
  List<DateTime> time,
  double msPerPx,
) {
  for (int i = 0; i < xCoords.length; i++) {
    YAxisConfig.instance.yAxisClipping(canvas, size, () {
      canvas.drawLine(
        Offset(xCoords[i], 0),
        Offset(xCoords[i], size.height - gridStyle.xLabelsAreaHeight),
        Paint()
          ..color =  gridStyle.gridLineColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = gridStyle.lineThickness,
      );
    });
  }
}

void _paintTimeLabels(
  Canvas canvas,
  Size size, {
  required List<double> xCoords,
  required GridStyle gridStyle,
  required List<DateTime> timestamps,
  String Function(DateTime time)? xAxisLabelFormatter,
}) {
  for (int index = 0; index < timestamps.length; index++) {
    final String label = xAxisLabelFormatter?.call(timestamps[index]) ??
        timeLabel(timestamps[index]);
    final TextPainter painter = makeTextPainter(label, gridStyle.xLabelStyle);
    final double halfWidth = painter.width / 2;
    final double clampedX =
        xCoords[index].clamp(halfWidth, size.width - halfWidth);

    paintWithTextPainter(
      canvas,
      painter: painter,
      anchor: Offset(
        clampedX,
        size.height - gridStyle.xLabelsAreaHeight / 2,
      ),
    );
  }
}

void _paintTimeLabelsWeb(
  Canvas canvas,
  Size size, {
  required List<double> xCoords,
  required GridStyle gridStyle,
  required List<DateTime> timestamps,
  String Function(DateTime time)? xAxisLabelFormatter,
}) {
  final TextStyle textStyle = TextStyle(
    fontSize: gridStyle.xLabelStyle.fontSize,
    height: gridStyle.xLabelStyle.height,
    color: gridStyle.xLabelStyle.color,
  );

  for (int index = 0; index < timestamps.length; index++) {
    final String label = xAxisLabelFormatter?.call(timestamps[index]) ??
        timeLabel(timestamps[index]);
    final TextPainter painter = makeTextPainter(label, textStyle);
    final double halfWidth = painter.width / 2;
    final double clampedX =
        xCoords[index].clamp(halfWidth, size.width - halfWidth);

    paintWithTextPainter(
      canvas,
      painter: painter,
      anchor: Offset(
        clampedX,
        size.height - gridStyle.xLabelsAreaHeight / 2,
      ),
    );
  }
}
