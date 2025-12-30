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
    const int granularityMs = 5 * 60 * 1000;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {

        return DerivChart(
          mainSeries: LineSeries(widget.ticks),
          activeSymbol: "BTC",
          granularity: granularityMs,
          theme: KLineDark(),
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
          chartAxisConfig: ChartAxisConfig(
            yAxisLabelPosition: YAxisLabelPosition.left,
            yAxisLabelsOverlay: true,
            yAxisLabelFormatter: _formatYAxisLabel,
            enableScaleGesture: false,
          ),
          showCrosshair: false,
          dataFitEnabled: true,
          showDataFitButton: false,
          dataFitPadding: EdgeInsets.zero,
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
