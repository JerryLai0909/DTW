import 'package:flutter/material.dart';
import 'dart:async';
import 'package:dtw_flutter/resources/app_colors.dart';
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
  List<Color> gradientColors = [
    AppColors.contentColorCyan,
    AppColors.contentColorBlue,
  ];

  bool showAvg = false;

  List<double>? _accelerometerValues;
  List<double>? _userAccelerometerValues;
  List<double>? _gyroscopeValues;
  List<StreamSubscription<dynamic>> _streamSubscriptions =
      <StreamSubscription<dynamic>>[];
  List<String>? _items = [];
  List<FlSpot> x_acceler = [];
  List<FlSpot> y_acceler = [];
  List<FlSpot> z_acceler = [];
  bool isCount = true;
  double countSec = 0;
  bool addData = false;
  double waitTime = 0;
  var now = DateTime.now().millisecondsSinceEpoch;

  myTimer() {
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (isCount) {
        countSec = countSec + 0.05;
        addData = true;
      }
      if (countSec >= 10.8) {
        isCount = false;
        waitTime = waitTime + 0.05;
      }
      if (waitTime >= 2) {
        countSec = 0;
        x_acceler = [];
        y_acceler = [];
        z_acceler = [];
        isCount = true;
        waitTime = 0;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    myTimer(); //启动计时器

    _streamSubscriptions
        .add(accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _accelerometerValues = <double>[event.x, event.y, event.z];
        if (x_acceler == [] && y_acceler == [] && z_acceler == []) {
          x_acceler.add(FlSpot(countSec.toDouble(), (event.x + 10) / 2));
          y_acceler.add(FlSpot(countSec.toDouble(), (event.y + 10) / 2));
          z_acceler.add(FlSpot(countSec.toDouble(), (event.z + 10) / 2));
        }
        if (addData) {
          x_acceler.add(FlSpot(countSec.toDouble(), (event.x + 10) / 2));
          y_acceler.add(FlSpot(countSec.toDouble(), (event.y + 10) / 2));
          z_acceler.add(FlSpot(countSec.toDouble(), (event.z + 10) / 2));
          addData = false;
        }
      });
    }));
  }

  @override
  Widget build(BuildContext context) {
    final List<String>? accelerometer =
        _accelerometerValues?.map((double v) => v.toStringAsFixed(1)).toList();
    final List<String>? gyroscope =
        _gyroscopeValues?.map((double v) => v.toStringAsFixed(1)).toList();
    final List<String>? userAccelerometer = _userAccelerometerValues
        ?.map((double v) => v.toStringAsFixed(1))
        .toList();

    return Scaffold(
        appBar: AppBar(
          title: Text('HAHAH${context.watch<DisplayProvider>().count}'),
          backgroundColor: Colors.black,
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Padding(
              // ignore: sort_child_properties_last
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Accelerometer: $accelerometer'),
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
                    child: LineChart(xyzData(x_acceler)),
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
                    child: Text(
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
                    child: LineChart(xyzData(y_acceler)),
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
                    child: LineChart(xyzData(z_acceler)),
                  ),
                ),
              ],
            ),
            FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () => {context.read<DisplayProvider>().increment()}),
          ]),
        ));
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('0', style: style);
        break;
      case 1:
        text = const Text('1', style: style);
        break;
      case 2:
        text = const Text('2', style: style);
        break;
      case 3:
        text = const Text('3', style: style);
        break;
      case 4:
        text = const Text('4', style: style);
        break;
      case 5:
        text = const Text('5', style: style);
        break;
      case 6:
        text = const Text('6', style: style);
        break;
      case 7:
        text = const Text('7', style: style);
        break;
      case 8:
        text = const Text('8', style: style);
        break;
      case 9:
        text = const Text('9', style: style);
        break;
      case 10:
        text = const Text('10', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 8,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = '0';
        break;
      case 1:
        text = '1';
        break;
      case 2:
        text = '2';
        break;
      case 3:
        text = '3';
        break;
      case 4:
        text = '4';
        break;
      case 5:
        text = '5';
        break;
      case 6:
        text = '6';
        break;
      case 7:
        text = '7';
        break;
      case 8:
        text = '8';
        break;
      case 9:
        text = '9';
        break;
      case 10:
        text = '10';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData xyzData(List<FlSpot> accelerData) {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: AppColors.contentColorOrange,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: AppColors.contentColorPurple,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 10,
      lineBarsData: [
        LineChartBarData(
          spots: accelerData,
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }
}
