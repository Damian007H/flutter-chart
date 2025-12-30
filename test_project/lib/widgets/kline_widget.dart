import 'package:deriv_chart/deriv_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'kline_theme.dart';

class KChart extends StatefulWidget {
  final List<Tick> ticks;

  const KChart(this.ticks, {super.key});

  @override
  State<KChart> createState() => _KChartState();
}

class _KChartState extends State<KChart> {
  final ChartController _controller = ChartController();

  @override
  void initState() {
    super.initState();
    _syncChartMode();
  }

  @override
  void didUpdateWidget(covariant KChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncChartMode();
  }

  void _syncChartMode() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.toggleXScrollBlock?.call(isXScrollBlocked: true);
      _controller.toggleDataFitMode?.call(enableDataFit: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isLight = false;
    ChartDefaultTheme theme = isLight ? KLineLight() : KLineDark();

    final int targetVisiblePoints = widget.ticks.length;
    const int granularityMs = 5 * 60 * 1000;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double chartWidthPx = constraints.maxWidth;
        final double intervalWidthPx = (chartWidthPx / targetVisiblePoints).clamp(1.0, 80.0);
        final double msPerPx = granularityMs / intervalWidthPx;
        final double dataWidthPx = intervalWidthPx * widget.ticks.length;
        final double centerPaddingPx = ((chartWidthPx - dataWidthPx) / 2).clamp(0.0, chartWidthPx);

        return DerivChart(
          mainSeries: LineSeries(widget.ticks),
          activeSymbol: "BTC",
          granularity: granularityMs,
          theme: theme,
          indicatorsRepo: AddOnsRepository<IndicatorConfig>(
            createAddOn: (m) => IndicatorConfig.fromJson(m),
            onEditCallback: (_) {},
            sharedPrefKey: 'BTC',
          ),
          drawingToolsRepo: AddOnsRepository<DrawingToolConfig>(
            createAddOn: (m) => DrawingToolConfig.fromJson(m),
            onEditCallback: (_) {},
            sharedPrefKey: 'BTC',
          ),
          controller: _controller,
          msPerPx: msPerPx,
          minIntervalWidth: intervalWidthPx,
          maxIntervalWidth: intervalWidthPx,
          chartAxisConfig: ChartAxisConfig(
            yAxisLabelPosition: YAxisLabelPosition.left,
            yAxisLabelsOverlay: true,
            maxCurrentTickOffset: centerPaddingPx,
            yAxisLabelFormatter: _formatYAxisLabel,
          ),
          showCrosshair: false,
          dataFitEnabled: true,
          showDataFitButton: false,
          isLive: true,
        );
      },
    );
  }

  String _formatYAxisLabel(double value, int pipSize) {
    final double absValue = value.abs();
    if (absValue >= 1e12) {
      return '${(value / 1e12).toStringAsFixed(2)}T';
    }
    if (absValue >= 1e9) {
      return '${(value / 1e9).toStringAsFixed(2)}B';
    }
    if (absValue >= 1e6) {
      return '${(value / 1e6).toStringAsFixed(2)}M';
    }
    if (absValue >= 1e3) {
      return '${(value / 1e3).toStringAsFixed(2)}K';
    }
    return value.toStringAsFixed(pipSize);
  }
}
