import 'package:deriv_chart/deriv_chart.dart';
import 'package:flutter/material.dart';

class KLineDark extends ChartDefaultDarkTheme {
  @override
  Color get areaLineColor => Color(0xFF12B76A);

  @override
  Color get areaGradientStart => Color(0xFF12B76A);

  @override
  Color get areaGradientEnd => Color(0x00147500);

  @override
  Color get backgroundColor => Color(0xFF000000);
}

class KLineLight extends ChartDefaultLightTheme {
  @override
  Color get areaLineColor => Color(0xFF12B76A);

  @override
  Color get areaGradientStart => Color(0xFF12B76A);

  @override
  Color get areaGradientEnd => Color(0x00147500);

  @override
  Color get backgroundColor => Color(0xFFFFFFFF);
}
