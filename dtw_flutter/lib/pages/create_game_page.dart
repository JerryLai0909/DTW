import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';
import '../providers/info_provider.dart';
import '../providers/sensor_provider.dart';
import 'create_sensor_record.dart';

class CreateGamePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CreateGamePageState();
}

class _CreateGamePageState extends State<CreateGamePage> {
  late VideoPlayerController _videoPlayerController;
  bool _isPlaying = false;
  late SensorProvider sensorProvider;

  @override
  void initState() {
    super.initState();
    sensorProvider = new SensorProvider();
    _videoPlayerController =
        VideoPlayerController.asset('assets/videos/demo_yat.mp4')
          ..addListener(() {
            if (_videoPlayerController.value.isPlaying != _isPlaying) {
              setState(() {
                _isPlaying = _videoPlayerController.value.isPlaying;
              });
            }
          })
          ..initialize().then((_) {
            setState(() {});
          });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameInfos = context.watch<InfoProvider>().gameInfo;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Create Game'),
      ),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                  child: Column(
                children: [
                  SizedBox(
                    height: 300,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: _videoPlayerController.value.isInitialized
                              ? VideoPlayer(_videoPlayerController)
                              : Container(),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: _isPlaying
                              ? Container()
                              : IconButton(
                                  icon: Icon(Icons.play_circle_outline),
                                  onPressed: () {
                                    _videoPlayerController.play();
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  MaterialButton(
                    height: 40,
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: Duration(milliseconds: 500),
                          pageBuilder: (_, __, ___) => CreateSensorRecordPage(),
                          transitionsBuilder: (_, Animation<double> animation,
                              __, Widget child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                    color: Colors.blue,
                    textColor: Colors.white,
                    child: Text('Create Game'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        'See more',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              )),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: gameInfos!.length,
                  (BuildContext context, int index) {
                    if (gameInfos == null || gameInfos == []) {
                      return Text('加载中');
                    } else {
                      return Container(
                        height: 250,
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: Colors.black.withOpacity(0.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16.0)),
                                color: Colors.black.withOpacity(0.8),
                              ),
                              child: Text(
                                '${gameInfos[index].gameTitle}',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.set_meal,
                                        color: Colors.white,
                                        size: 32.0,
                                      ),
                                      SizedBox(height: 20.0),
                                      Icon(
                                        Icons.search,
                                        color: Colors.white,
                                        size: 32.0,
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 16.0),
                                  Expanded(
                                    child: AspectRatio(
                                        aspectRatio: 1.8,
                                        child: LineChart(
                                          sensorProvider
                                              .getLineChartByRecordData(
                                                  gameInfos[index].gameRecords),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                left: 16.0,
                                right: 16.0,
                              ),
                              child: Text(
                                '${gameInfos[index].gameDesc}',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
