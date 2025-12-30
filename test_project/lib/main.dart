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

    // mockData.add(Tick(epoch: 1766220027498, quote: 35964450609.42));
    // mockData.add(Tick(epoch: 1766220327498, quote: 35898324061.37));
    // mockData.add(Tick(epoch: 1766220627498, quote: 35705237234.25));
    // mockData.add(Tick(epoch: 1766220927498, quote: 35757234074.64));
    // mockData.add(Tick(epoch: 1766221227498, quote: 35713559422.59));
    // mockData.add(Tick(epoch: 1766221527498, quote: 35528967339.93));
    // mockData.add(Tick(epoch: 1766221827498, quote: 35556780645.17));
    // mockData.add(Tick(epoch: 1766222127498, quote: 35478823941.18));
    // mockData.add(Tick(epoch: 1766222427498, quote: 35477052986.96));
    // mockData.add(Tick(epoch: 1766222727498, quote: 35434906356.213745));

    mockData.add(Tick(epoch: 1766220027498, quote: 1001.42));
    mockData.add(Tick(epoch: 1766220327498, quote: 1008));
    mockData.add(Tick(epoch: 1766220627498, quote: 1015.3));
    mockData.add(Tick(epoch: 1766220927498, quote: 1025.4));
    mockData.add(Tick(epoch: 1766221227498, quote: 1011.5));
    mockData.add(Tick(epoch: 1766221527498, quote: 1009.6));
    mockData.add(Tick(epoch: 1766221827498, quote: 1005.7));
    mockData.add(Tick(epoch: 1766222127498, quote: 1014.8));
    mockData.add(Tick(epoch: 1766222427498, quote: 1029.9));
    mockData.add(Tick(epoch: 1766222727498, quote: 1002));
    mockData.add(Tick(epoch: 1766223027000, quote: 1019));
    mockData.add(Tick(epoch: 1766223327000, quote: 1015));
    mockData.add(Tick(epoch: 1766223627000, quote: 1004));
    mockData.add(Tick(epoch: 1766223927000, quote: 1002));
    mockData.add(Tick(epoch: 1766224227000, quote: 1001));
    mockData.add(Tick(epoch: 1766224527000, quote: 998));
    mockData.add(Tick(epoch: 1766224827000, quote: 1004));
    mockData.add(Tick(epoch: 1766225127000, quote: 1001.42));
    mockData.add(Tick(epoch: 1766225427000, quote: 1008));
    mockData.add(Tick(epoch: 1766225727000, quote: 1015.3));
    mockData.add(Tick(epoch: 1766226027000, quote: 1025.4));
    mockData.add(Tick(epoch: 1766226327000, quote: 1011.5));
    mockData.add(Tick(epoch: 1766226627000, quote: 1009.6));
    mockData.add(Tick(epoch: 1766226927000, quote: 1005.7));
    mockData.add(Tick(epoch: 1766227227000, quote: 1014.8));
    mockData.add(Tick(epoch: 1766227527000, quote: 1029.9));
    mockData.add(Tick(epoch: 1766227827000, quote: 1002));
    mockData.add(Tick(epoch: 1766228127000, quote: 1019));
    mockData.add(Tick(epoch: 1766228427000, quote: 1015));
    mockData.add(Tick(epoch: 1766228727000, quote: 1004));
    mockData.add(Tick(epoch: 1766229027000, quote: 1002));
    mockData.add(Tick(epoch: 1766229327000, quote: 1001));
    mockData.add(Tick(epoch: 1766229627000, quote: 998));
    mockData.add(Tick(epoch: 1766229927000, quote: 1004));
    mockData.add(Tick(epoch: 1766230227000, quote: 1004));
    mockData.add(Tick(epoch: 1766230527000, quote: 1004));
    mockData.add(Tick(epoch: 1766230827000, quote: 1004));

    // mockData.add(Tick(epoch: 1766220927498, quote: 1025.4));
    mockData.add(Tick(epoch: 1766231127498, quote: 1011.5));
    mockData.add(Tick(epoch: 1766231427498, quote: 1009.6));
    mockData.add(Tick(epoch: 1766231727498, quote: 1005.7));
    mockData.add(Tick(epoch: 1766232027498, quote: 1014.8));
    mockData.add(Tick(epoch: 1766232327498, quote: 1029.9));
    mockData.add(Tick(epoch: 1766232627498, quote: 1002));
    mockData.add(Tick(epoch: 1766232927000, quote: 1019));
    mockData.add(Tick(epoch: 1766233227000, quote: 1015));
    mockData.add(Tick(epoch: 1766233527000, quote: 1004));
    mockData.add(Tick(epoch: 1766233827000, quote: 1002));
    mockData.add(Tick(epoch: 1766234127000, quote: 1001));
    mockData.add(Tick(epoch: 1766234427000, quote: 998));
    mockData.add(Tick(epoch: 1766234727000, quote: 1004));

    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 170, child: KChart(mockData)),
          ],
        ),
      ),
    );
  }
}
