import 'package:flutter/material.dart';

import '../../../models/chart_axis_config.dart';

///Singleton class to manage configuration and operations related to the Y-axis
///in custom painting
class YAxisConfig {
  //Private constructor to prevent external instantiation.
  YAxisConfig._();

  static final YAxisConfig _instance = YAxisConfig._();

  /// The single instance of `YAxisConfig`.
  static YAxisConfig get instance => _instance;

  ///Cached width of the label on the Y-axis. This is nullable to handle cases
  ///where it might not be set yet.
  double? cachedLabelWidth;

  /// Cached label position on the Y-axis.
  YAxisLabelPosition cachedLabelPosition = YAxisLabelPosition.right;

  /// Whether Y-axis labels are painted on top of the chart (no clipping).
  bool cachedLabelsOverlay = false;

  ///Sets and caches the label width for the Y-axis. Returns the set width for
  ///potential immediate use.
  double setLabelWidth(double width) {
    cachedLabelWidth = width;
    return cachedLabelWidth!;
  }

  /// Sets the label position for the Y-axis.
  void setLabelPosition(YAxisLabelPosition position) {
    cachedLabelPosition = position;
  }

  /// Sets whether Y-axis labels are painted on top of the chart.
  void setLabelsOverlay(bool overlay) {
    cachedLabelsOverlay = overlay;
  }

  ///Executes painting logic within a clipped area of the canvas to prevent
  ///drawing over the Y-axis labels.
  void yAxisClipping(Canvas canvas, Size size, VoidCallback paintingLogic) {
    if (cachedLabelsOverlay) {
      paintingLogic();
      return;
    }

    final double labelWidth = cachedLabelWidth ?? 0;
    final Rect clipRect = cachedLabelPosition == YAxisLabelPosition.left
        ? Rect.fromLTWH(labelWidth, 0, size.width - labelWidth, size.height)
        : Rect.fromLTWH(0, 0, size.width - labelWidth, size.height);
    canvas
      ..save()
      ..clipRect(clipRect);
    paintingLogic();
    canvas.restore();
  }
}
