import 'dart:async';
import 'package:dtw_flutter/providers/sensor_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';

class CreateSensorRecordPage extends StatefulWidget {
  @override
  _CreateSensorRecordPageState createState() => _CreateSensorRecordPageState();
}

class _CreateSensorRecordPageState extends State<CreateSensorRecordPage>
    with TickerProviderStateMixin {
  late StreamSubscription<AccelerometerEvent> _accelerometerStreamSubscription;
  bool _isAccelerometerChecked = true;
  // bool _isGyroscopeChecked = false;

  bool _showAreaA = true;
  // bool _showAreaB = false;

  late AnimationController _controller;
  late Animation<double> _animation;

  bool _isStartButtonPressed = false;
  bool _isEndButtonPressed = false;

  final double initialValue = 30;
  final double minValue = 20;
  final double maxValue = 100; //每一个是0.1秒
  double _value = 0;

  void _handleStartButtonLongPressStart(LongPressStartDetails details) {
    setState(() {
      _isStartButtonPressed = true;
    });
    _startProgressAnimation();
  }

  void _handleStartButtonLongPressEnd(LongPressEndDetails details) {
    setState(() {
      _isStartButtonPressed = false;
    });
    _stopProgressAnimation();
    onStartButtonLongPress();
  }

  void _handleEndButtonLongPressStart(LongPressStartDetails details) {
    setState(() {
      _isEndButtonPressed = true;
    });
    _startProgressAnimation();
  }

  void _handleEndButtonLongPressEnd(LongPressEndDetails details) {
    setState(() {
      _isEndButtonPressed = false;
    });
    _stopProgressAnimation();
    onEndButtonLongPress();
  }

  void _startProgressAnimation() {
    _controller.forward();
  }

  void _stopProgressAnimation() {
    _controller.stop();
    _controller.reset();
  }

  bool canAddData = true;
  int millsec = 20;
  double timeMill = 0;
  bool isStarting = false;
  late Timer _timer;

  List<FlSpot> acceX = [];
  List<FlSpot> acceY = [];
  List<FlSpot> acceZ = [];

  // List<FlSpot> gyroX = [];
  // List<FlSpot> gyroY = [];
  // List<FlSpot> gyroZ = [];

  double totalTime = 30;

  void onStartButtonLongPress() {
    if (isStarting) return;
    isStarting = true;
    debugPrint('长按开始');
    _timer = Timer.periodic(Duration(milliseconds: millsec), (timer) {
      if (timeMill >= totalTime * 100) return;
      timeMill = timeMill + millsec;
      canAddData = true;
    });
  }

  void onEndButtonLongPress() {
    isStarting = false;
    debugPrint('长按结束');
    _timer.cancel();
    canAddData = false;
  }

  void setZero() {
    onEndButtonLongPress();
    setState(() {
      acceX = [];
      acceY = [];
      acceZ = [];
      // gyroX = [];
      // gyroY = [];
      // gyroZ = [];
      timeMill = 0;
    });
  }

  late ValueChanged<double> onValueChanged;
  late SensorProvider sensorProvider;
  GlobalKey globalKey = GlobalKey();
  // Future<void> _capturePng() async {
  //   final RenderRepaintBoundary boundary =
  //       globalKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
  //   final image = await boundary.toImage();
  //   final ByteData? byteData =
  //       await image.toByteData(format: ImageByteFormat.png);
  //   final Uint8List pngBytes = byteData!.buffer.asUint8List();
  //   // final Directory appDocDir = await getApplicationDocumentsDirectory();
  //   // debugPrint('appDocDir${appDocDir}');
  //   // final String appDocPath = appDocDir.path;
  //   // final File file = File('$appDocPath/hahahah.png');
  //   // await file.writeAsBytes(pngBytes);
  //   // print(pngBytes);
  // }

  @override
  void initState() {
    sensorProvider = new SensorProvider();

    super.initState();
    _value = initialValue;
    onValueChanged = (value) {
      sensorProvider.setTotalTime(value);
      setState(() {
        totalTime = value;
      });
    };
    _accelerometerStreamSubscription =
        accelerometerEvents.listen((AccelerometerEvent event) {
      if (acceX == []) {}
      if (_isAccelerometerChecked && canAddData && isStarting) {
        setState(() {
          double millTime = timeMill / 1000;
          double x = event.x;
          double y = event.y;
          double z = event.z;
          if (x >= 20) {
            x = 20;
          }
          if (y >= 20) {
            y = 20;
          }
          if (z >= 20) {
            z = 20;
          }
          if (x <= -20) {
            x = -20;
          }
          if (y <= -20) {
            y = -20;
          }
          if (z <= -20) {
            z = -20;
          }
          x = (((x / 20) * 8 * 100).truncateToDouble()) / 100;
          y = (((y / 20) * 8 * 100).truncateToDouble()) / 100;
          z = (((z / 20) * 8 * 100).truncateToDouble()) / 100;

          acceX.add(FlSpot(millTime, x));
          acceY.add(FlSpot(millTime, y));
          acceZ.add(FlSpot(millTime, z));
        });
        canAddData = false;
      }
    });
    // gyroscopeEvents.listen((GyroscopeEvent event) {
    //   if (_isGyroscopeChecked && canAddData && isStarting) {
    //     // debugPrint('陀螺仪${event.x} ${event.y} ${event.z}');
    //     setState(() {
    //       double millTime = timeMill / 1000;
    //       double x = ((event.x * 100).truncateToDouble()) / 100;
    //       double y = ((event.y * 100).truncateToDouble()) / 100;
    //       double z = ((event.z * 100).truncateToDouble()) / 100;
    //       if (x >= 5) {
    //         x = 5;
    //       }
    //       if (y >= 5) {
    //         y = 5;
    //       }
    //       if (z >= 5) {
    //         z = 5;
    //       }
    //       if (x <= -5) {
    //         x = -5;
    //       }
    //       if (y <= -5) {
    //         y = -5;
    //       }
    //       if (z <= -5) {
    //         z = -5;
    //       }
    //       gyroX.add(FlSpot(millTime, x));
    //       gyroY.add(FlSpot(millTime, y));
    //       gyroZ.add(FlSpot(millTime, z));
    //     });
    //     canAddData = false;
    //   }
    // });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addListener(() {
        setState(() {});
      });
    _animation = Tween<double>(begin: 0, end: 10).animate(_controller);
  }

  @override
  void dispose() {
    super.dispose();
    _accelerometerStreamSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text("CreateSensorRecord"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text(
                      'Sensor Record',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.blue,
                      ),
                    ),
                    content: Text(
                      'This page allows you to create a new sensor record by recording data from the accelerometer and gyroscope sensors.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('OK'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 10.0),
              if (_showAreaA) ...[
                AspectRatio(
                  aspectRatio: 1.8,
                  child: Padding(
                      padding: const EdgeInsets.only(
                        right: 12,
                        left: 12,
                        top: 8,
                        bottom: 8,
                      ),
                      child: RepaintBoundary(
                        key: globalKey,
                        child: LineChart(sensorProvider.lineDataFactory(
                            0,
                            1,
                            0,
                            (totalTime / 10),
                            -8,
                            8,
                            [acceX, acceY, acceZ],
                            totalTime)),
                      )),
                ),
              ],
              SizedBox(height: 10.0),
              // if (_showAreaB) ...[
              //   AspectRatio(
              //     aspectRatio: 1.8,
              //     child: Padding(
              //       padding: const EdgeInsets.only(
              //         right: 12,
              //         left: 12,
              //         top: 8,
              //         bottom: 8,
              //       ),
              //       child: LineChart(sensorProvider.lineDataFactory(
              //           1,
              //           7,
              //           0,
              //           (totalTime / 10),
              //           -5,
              //           5,
              //           [gyroX, gyroY, gyroZ],
              //           totalTime)),
              //     ),
              //   ),
              // ],
              Row(
                children: <Widget>[
                  Checkbox(
                    value: _isAccelerometerChecked,
                    onChanged: (value) {
                      setState(() {
                        _isAccelerometerChecked = value!;
                        _showAreaA = !_showAreaA;
                      });
                    },
                  ),
                  Text("打开加速度计"),
                ],
              ),
              // Row(
              //   children: <Widget>[
              //     Checkbox(
              //       value: _isGyroscopeChecked,
              //       onChanged: (value) {
              //         setState(() {
              //           _isGyroscopeChecked = value!;
              //           _showAreaB = !_showAreaB;
              //         });
              //       },
              //     ),
              //     Text("打开陀螺仪"),
              //   ],
              // ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: Container(
                  height: 35,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: FractionallySizedBox(
                    widthFactor: (_value - minValue) / (maxValue - minValue),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                onPanUpdate: (details) {
                  setState(() {
                    _value = (_value - details.delta.dx / 10.0)
                        .clamp(minValue, maxValue);
                    onValueChanged(_value);
                  });
                },
              ),
              Text(
                  '所选择时间为:${(((totalTime / 10) * 100).truncateToDouble() / 100)}'),
              Container(
                height: 150.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    GestureDetector(
                      onLongPressStart: _handleStartButtonLongPressStart,
                      onLongPressEnd: _handleStartButtonLongPressEnd,
                      child: _buildButton(
                        text: 'Start',
                        isPressed: _isStartButtonPressed,
                      ),
                    ),
                    GestureDetector(
                      onLongPressStart: _handleEndButtonLongPressStart,
                      onLongPressEnd: _handleEndButtonLongPressEnd,
                      child: _buildButton(
                        text: 'End',
                        isPressed: _isEndButtonPressed,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setZero();
                      },
                      icon: Icon(Icons.format_list_bulleted_rounded),
                    ),
                    IconButton(
                      onPressed: () {
                        // _capturePng();
                        String datas = acceX.toString() +
                            '***' +
                            acceY.toString() +
                            '***' +
                            acceZ.toString();
                        sensorProvider.sendInsert(
                            0,
                            7,
                            '0,${(totalTime / 10)},-8,8',
                            datas,
                            totalTime,
                            '1,1,1',
                            (res) => {
                                  debugPrint('res === >>> ${res.code}'),
                                  if (res.code == 200)
                                    {Navigator.of(context).pop()}
                                });
                      },
                      icon: Icon(Icons.settings),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Widget _buildButton({required String text, required bool isPressed}) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(Icons.macro_off),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        padding: EdgeInsets.all(26),
      ),
    );
  }
}
