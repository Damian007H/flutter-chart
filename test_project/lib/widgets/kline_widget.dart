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
    _lockHorizontalScroll();
  }

  @override
  void didUpdateWidget(covariant KChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    _lockHorizontalScroll();
  }

  void _lockHorizontalScroll() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.toggleXScrollBlock?.call(isXScrollBlocked: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isLight = true;
    ChartDefaultTheme theme = isLight ? KLineLight() : KLineLight();

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
          ),
          showCrosshair: false,
          isLive: true,
        );
      },
    );
  }
}
