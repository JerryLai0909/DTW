import 'package:dtw_flutter/models/user.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:sensors/sensors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../providers/display_provider.dart';

class DisplayPage extends StatefulWidget {
  const DisplayPage({super.key});

  @override
  State<StatefulWidget> createState() => _DisplaypageState();
}

class _DisplaypageState extends State<DisplayPage> {
  List<double>? _accelerometerValues;
  final List<StreamSubscription<dynamic>> _streamSubscriptions =
      <StreamSubscription<dynamic>>[];

  bool canAddData = false;
  int millsec = 10;
  double timeMill = 0;
  bool isStarting = false;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    context.read<DisplayProvider>().resetDisplayData();
  }

  void start() async {
    isStarting = true;
    if (timeMill == 0) {
      context.read<DisplayProvider>().resetDisplayData();
    }
    _timer = Timer.periodic(Duration(milliseconds: millsec), (timer) {
      if (!isStarting) return;
      timeMill = timeMill + millsec;
      if (timeMill >= 3000) {
        canAddData = true;
      }
      if (timeMill >= 12000) {
        end();
      }
    });
    _streamSubscriptions
        .add(accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _accelerometerValues = <double>[event.x, event.y, event.z];
      });
      if (canAddData) {
        double x = event.x;
        double y = event.y;
        double z = event.z;
        if (x > 10) x = 10;
        if (y > 10) y = 10;
        if (z > 10) z = 10;
        context.read<DisplayProvider>().setFlSpot(
            (timeMill / 1000 - 3), (x + 10) / 2, (y + 10) / 2, (z + 10) / 2);
        canAddData = false;
      }
    }));
  }

  void end() {
    isStarting = false;
    timeMill = 0;
    canAddData = false;
    _timer.cancel();
    for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    DisplayProvider displayProvider = DisplayProvider();
    final List<String>? accelerometer =
        _accelerometerValues?.map((double v) => v.toStringAsFixed(1)).toList();
    return Scaffold(
        appBar: AppBar(
          title: const Text('HAHAH'),
          backgroundColor: Colors.black,
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Padding(
              // ignore: sort_child_properties_last
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                      'Accelerometer: $accelerometer,倒计时${((timeMill / 1000) - 3).toDouble()}${context.watch<DisplayProvider>().title}'),
                ],
              ),
              padding: const EdgeInsets.all(16.0),
            ),
            Stack(
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 1.50,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 18,
                      left: 12,
                      top: 24,
                      bottom: 12,
                    ),
                    child: LineChart(displayProvider.lineDataFactory(
                        context.read<DisplayProvider>().xAcceler)),
                  ),
                ),
                SizedBox(
                  width: 60,
                  height: 34,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        // showAvg = !showAvg;
                      });
                    },
                    child: const Text(
                      'avg',
                      style: TextStyle(
                        fontSize: 12,
                        // color: showAvg ? Colors.white.withOpacity(0.5) : Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Stack(
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 1.50,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 18,
                      left: 12,
                      top: 24,
                      bottom: 12,
                    ),
                    child: LineChart(displayProvider.lineDataFactory(
                        context.read<DisplayProvider>().yAcceler)),
                  ),
                ),
              ],
            ),
            Stack(
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 1.50,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 18,
                      left: 12,
                      top: 24,
                      bottom: 12,
                    ),
                    child: LineChart(displayProvider.lineDataFactory(
                        context.read<DisplayProvider>().zAcceler)),
                  ),
                ),
              ],
            ),
            FloatingActionButton(
              child: const Icon(Icons.start),
              onPressed: () => {start()},
            ),
            FloatingActionButton(
              child: const Icon(Icons.mic),
              onPressed: () => {end()},
            ),
          ]),
        ));
  }

  @override
  void dispose() {
    super.dispose();
    end();
  }
}
