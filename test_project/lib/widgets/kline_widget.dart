import 'package:deriv_chart/deriv_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'kline_theme.dart';

class KChart extends StatelessWidget {
  final List<Tick> ticks;

  KChart(this.ticks, {super.key});

  final ChartController _controller = ChartController();

  @override
  Widget build(BuildContext context) {
    bool isLight = true;
    ChartDefaultTheme theme = isLight ? KLineLight() : KLineLight();
    return DerivChart(
      mainSeries: LineSeries(ticks),
      activeSymbol: "BTC",
      granularity: 1000,
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
      // ...
      chartAxisConfig: const ChartAxisConfig(
        yAxisLabelPosition: YAxisLabelPosition.left,
        yAxisLabelsOverlay: true,
      ),
      showCrosshair: false,
      isLive: true,
    );
  }
}
