import 'dart:math' as math;
import 'package:deriv_chart/deriv_chart.dart';
import 'package:flutter/material.dart';
import 'package:test_project/widgets/kline_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    final List<Tick> mockData = <Tick>[];
    final DateTime now = DateTime.now();
    double price = 1000.0;

    for (int i = 200; i >= 0; i--) {
      final int timestamp = now.subtract(Duration(seconds: i)).millisecondsSinceEpoch;
      price += (math.Random().nextDouble() - 0.5) * 2;
      mockData.add(Tick(epoch: timestamp, quote: price));
    }
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 170, child: KChart(mockData),),
          ],
        ),
      ),
    );
  }
}
