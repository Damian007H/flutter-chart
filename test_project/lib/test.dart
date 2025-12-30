import 'dart:collection';
import 'dart:math' as math;
import 'package:deriv_chart/deriv_chart.dart';
import 'package:flutter/material.dart';

class SimpleChartDemo2 extends StatefulWidget {
  const SimpleChartDemo2({super.key});

  @override
  State<SimpleChartDemo2> createState() => _SimpleChartDemo2State();
}

class _SimpleChartDemo2State extends State<SimpleChartDemo2> {
  List<Tick> ticks = <Tick>[];
  ChartStyle style = ChartStyle.line;
  int granularity = 0;

  final List<Barrier> _sampleBarriers = <Barrier>[];
  HorizontalBarrier? _slBarrier, _tpBarrier;
  bool _sl = false, _tp = false;

  final SplayTreeSet<Marker> _markers = SplayTreeSet<Marker>();
  ActiveMarker? _activeMarker;

  final Asset _symbol = Asset(name: 'R_50');
  final ChartController _controller = ChartController();

  @override
  void initState() {
    super.initState();
    _generateMockData();
  }

  /// 生成模拟数据
  void _generateMockData() {
    final List<Tick> mockData = <Tick>[];
    final DateTime now = DateTime.now();
    double price = 1000.0;

    if (granularity == 0) {
      for (int i = 200; i >= 0; i--) {
        final int timestamp = now.subtract(Duration(days: i)).millisecondsSinceEpoch;
        price += (math.Random().nextDouble() - 0.5) * 2;
        mockData.add(Tick(epoch: timestamp, quote: price));
      }
    } else {
      // 生成Candle数据
      for (int i = 100; i >= 0; i--) {
        final int timestamp = now.subtract(Duration(minutes: i * 5)).millisecondsSinceEpoch;
        final double open = price;
        final double high = open + math.Random().nextDouble() * 10;
        final double low = open - math.Random().nextDouble() * 10;
        final double close = low + math.Random().nextDouble() * (high - low);
        price = close;

        mockData.add(Candle(
          epoch: timestamp,
          open: open,
          high: high,
          low: low,
          close: close,
          currentEpoch: timestamp,
        ));
      }
    }

    setState(() {
      ticks = mockData;
      _updateSampleSLAndTP();
    });
  }

  DataSeries<Tick> _getDataSeries(ChartStyle style) {
    if (ticks is List<Candle> && style != ChartStyle.line) {
      switch (style) {
        case ChartStyle.hollow:
          return HollowCandleSeries(ticks as List<Candle>);
        case ChartStyle.ohlc:
          return OhlcCandleSeries(ticks as List<Candle>);
        default:
          return CandleSeries(ticks as List<Candle>);
      }
    }
    return LineSeries(ticks);
  }

  void _addMarker(MarkerDirection direction) {
    if (ticks.isEmpty) return;

    final Tick lastTick = ticks.last;
    void onTap() {
      setState(() {
        _activeMarker = ActiveMarker(
          direction: direction,
          epoch: lastTick.epoch,
          quote: lastTick.quote,
          text: '0.00 USD',
          onTap: () {
            // 空实现
          },
          onTapOutside: () {
            setState(() {
              _activeMarker = null;
            });
          },
        );
      });
    }

    setState(() {
      _markers.add(Marker(
        direction: direction,
        epoch: lastTick.epoch,
        quote: lastTick.quote,
        onTap: onTap,
      ));
    });
  }

  void _clearMarkers() {
    _markers.clear();
    _activeMarker = null;
  }

  void _clearBarriers() {
    _sampleBarriers.clear();
    _sl = false;
    _tp = false;
  }

  void _updateSampleSLAndTP() {
    if (ticks.isEmpty) return;

    final double ticksMin = ticks.map((Tick t) => t.quote).reduce(math.min);
    final double ticksMax = ticks.map((Tick t) => t.quote).reduce(math.max);

    _slBarrier = HorizontalBarrier(
      ticksMin,
      title: 'Stop loss',
      style: const HorizontalBarrierStyle(
        color: Color(0xFFCC2E3D),
        isDashed: false,
      ),
      visibility: HorizontalBarrierVisibility.forceToStayOnRange,
    );

    _tpBarrier = HorizontalBarrier(
      ticksMax,
      title: 'Take profit',
      style: const HorizontalBarrierStyle(
        isDashed: false,
      ),
      visibility: HorizontalBarrierVisibility.forceToStayOnRange,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF191d21),
      child: Column(
        children: <Widget>[
          // 顶部控制栏
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: <Widget>[
                const Expanded(
                  child: Text(
                    'Simple Chart Demo',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    style == ChartStyle.line
                        ? Icons.show_chart
                        : style == ChartStyle.candles
                        ? Icons.candlestick_chart
                        : Icons.bar_chart,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      switch (style) {
                        case ChartStyle.line:
                          style = ChartStyle.candles;
                          break;
                        case ChartStyle.candles:
                          style = ChartStyle.hollow;
                          break;
                        default:
                          style = ChartStyle.line;
                          break;
                      }
                    });
                  },
                ),
                Theme(
                  data: ThemeData.dark(),
                  child: DropdownButton<int>(
                    value: granularity,
                    items: <int>[0, 60, 300, 900, 3600]
                        .map<DropdownMenuItem<int>>(
                          (int value) => DropdownMenuItem<int>(
                        value: value,
                        child: Text(
                          value == 0 ? 'Ticks' : '${value}s',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                        .toList(),
                    onChanged: (int? value) {
                      setState(() {
                        granularity = value ?? 0;
                        _clearMarkers();
                        _clearBarriers();
                        _generateMockData();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          // 图表区域
          Expanded(
            child: Stack(
              children: <Widget>[
                ClipRect(
                  child: DerivChart(
                    mainSeries: _getDataSeries(style),
                    markerSeries: MarkerSeries(
                      _markers,
                      activeMarker: _activeMarker,
                      markerIconPainter: MultipliersMarkerIconPainter(),
                    ),
                    activeSymbol: _symbol.name,
                    annotations: ticks.length > 4
                        ? <ChartAnnotation<ChartObject>>[
                      ..._sampleBarriers,
                      if (_sl && _slBarrier != null) _slBarrier as ChartAnnotation<ChartObject>,
                      if (_tp && _tpBarrier != null) _tpBarrier as ChartAnnotation<ChartObject>,
                      TickIndicator(
                        ticks.last,
                        style: const HorizontalBarrierStyle(
                          color: Color(0xFF6490F1),
                          labelShape: LabelShape.pentagon,
                          hasBlinkingDot: true,
                          hasArrow: false,
                          lineColor: Color(0xFF6490F1),
                          isDashed: false,
                          labelShapeBackgroundColor: Color(0xFF1F2943),
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                        visibility: HorizontalBarrierVisibility.keepBarrierLabelVisible,
                      ),
                    ]
                        : null,
                    pipSize: 2,
                    granularity: granularity == 0 ? 1000 : granularity * 1000,
                    controller: _controller,
                    isLive: false,
                    opacity: 1.0,
                    onVisibleAreaChanged: (int leftEpoch, int rightEpoch) {},
                  ),
                ),
              ],
            ),
          ),

          // 操作按钮行 - 标记操作
          SizedBox(
            height: 64,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    _generateMockData();
                  },
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) => const Color(0xFF00C390),
                    ),
                  ),
                  child: const Text('Up'),
                  onPressed: () => _addMarker(MarkerDirection.up),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) => const Color(0xFFDE0040),
                    ),
                  ),
                  child: const Text('Down'),
                  onPressed: () => _addMarker(MarkerDirection.down),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => setState(_clearMarkers),
                ),
              ],
            ),
          ),

          // 操作按钮行 - 障碍线操作
          SizedBox(
            height: 64,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                TextButton(
                  child: const Text('V barrier'),
                  onPressed: () => setState(() {
                    if (ticks.isNotEmpty) {
                      _sampleBarriers.add(
                        VerticalBarrier.onTick(
                          ticks.last,
                          title: 'V Barrier',
                          id: 'VBarrier${_sampleBarriers.length}',
                          longLine: math.Random().nextBool(),
                          style: VerticalBarrierStyle(
                            isDashed: math.Random().nextBool(),
                          ),
                        ),
                      );
                    }
                  }),
                ),
                TextButton(
                  child: const Text('H barrier'),
                  onPressed: () => setState(() {
                    if (ticks.isNotEmpty) {
                      _sampleBarriers.add(
                        HorizontalBarrier(
                          ticks.last.quote,
                          epoch: math.Random().nextBool() ? ticks.last.epoch : null,
                          id: 'HBarrier${_sampleBarriers.length}',
                          longLine: math.Random().nextBool(),
                          visibility: HorizontalBarrierVisibility.normal,
                          style: HorizontalBarrierStyle(
                            color: Colors.grey,
                            isDashed: math.Random().nextBool(),
                          ),
                        ),
                      );
                    }
                  }),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => setState(_clearBarriers),
                ),
              ],
            ),
          ),

          // 复选框行
          SizedBox(
            height: 64,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: CheckboxListTile(
                    value: _sl,
                    onChanged: (bool? value) => setState(() => _sl = value!),
                    title: const Text(
                      'Stop loss',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Expanded(
                  child: CheckboxListTile(
                    value: _tp,
                    onChanged: (bool? value) => setState(() => _tp = value!),
                    title: const Text(
                      'Take profit',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
