import 'package:deriv_chart/deriv_chart.dart';
import 'package:flutter/material.dart';

import 'number_util.dart';

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
    print("当前数据：${widget.ticks.length}");
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return DerivChart(
          loadingAnimationColor: Colors.grey,
          mainSeries: LineSeries(widget.ticks),
          activeSymbol: "BTC",
          granularity: granularityMs,
          theme: ChartDefaultLightTheme(),
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
            yAxisGridLineCount: 4,
            xAxisGridLineCount: 4,
            yAxisLabelPosition: YAxisLabelPosition.left,
            yAxisLabelsOverlay: true,
            yAxisLabelFormatter: _formatLogYAxisLabel,
            enableScaleGesture: false,
            xAxisLabelFormatter: (time) {
              return "testa";
            },
          ),
          dataFitEnabled: true,
          showDataFitButton: false,
          dataFitPadding: EdgeInsets.zero,
          isLive: true,
        );
      },
    );
  }

  String _formatLogYAxisLabel(double value, int pipSize) {
    return NumberUtil.formatShortAmount(value.toString(), decimals: pipSize);
  }
}
