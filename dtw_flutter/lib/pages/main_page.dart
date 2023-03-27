import 'package:dtw_flutter/pages/mine_page.dart';
import 'package:dtw_flutter/providers/info_provider.dart';
import 'package:dtw_flutter/providers/user_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api/index_api.dart';
import '../providers/sensor_provider.dart';
import 'create_game_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  late SensorProvider sensorProvider;
  @override
  void initState() {
    super.initState();
    sensorProvider = new SensorProvider();
    context.read<InfoProvider>().getInfoListRequest();
    context.read<UserProvider>().getUserInfoRequest();
    context.read<InfoProvider>().getGameInfoListRequest();
  }

  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
    ),
    Text(
      'Index 1: Business',
    ),
    Text(
      'Index 2: School',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameInfos = context.watch<InfoProvider>().gameInfo;

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background_kehuan.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.3),
        appBar: AppBar(
          backgroundColor: Colors.black.withOpacity(0.3),
          leading: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: Colors.black.withOpacity(0.5),
            ),
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: CircleAvatar(
              backgroundColor: Colors.black.withOpacity(0.8),
              child: Text(
                '${(context.watch<UserProvider>().userName)}',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          actions: <Widget>[
            Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: Colors.white.withOpacity(0.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      // 'Balance \$ 100',
                      'Balance :&&${(context.watch<UserProvider>().userCoin)}',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  )),
            ),
          ],
        ),
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 380,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 2,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 320,
                          margin: EdgeInsets.all(20),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Image.asset(
                                //   'assets/images/nftprofile_large.jpg',
                                //   fit: BoxFit.contain,
                                // ),
                                Container(
                                  margin: EdgeInsetsDirectional.fromSTEB(
                                      20, 40, 20, 20),
                                  child: Column(
                                    children: [
                                      Text(
                                        '${context.watch<UserProvider>().userCoin}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 100.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'TODAY',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 40.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Container(
                                      margin: EdgeInsetsDirectional.fromSTEB(
                                          20, 40, 20, 20),
                                      child: Text(
                                        '${context.watch<UserProvider>().userLevel}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 140,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: context.watch<InfoProvider>().infoList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 320,
                          margin: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              'Item ${context.watch<InfoProvider>().infoList[index].title}',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    childCount: gameInfos!.length,
                    (BuildContext context, int index) {
                      if (gameInfos == null || gameInfos == []) {
                        return Text('加载中');
                      } else {
                        return Container(
                          height: 250,
                          margin: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                                    gameInfos[index]
                                                        .gameRecords),
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
            Positioned(
              left: 30,
              right: 30,
              bottom: 35,
              child: Container(
                width: 220,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                margin: EdgeInsets.fromLTRB(60.0, 0.0, 60.0, 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(Icons.home),
                      onPressed: () {},
                      color: Colors.white,
                    ),
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: Duration(milliseconds: 500),
                            pageBuilder: (_, __, ___) => CreateGamePage(),
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
                      color: Colors.white,
                    ),
                    IconButton(
                      icon: Icon(Icons.settings),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MinePage()),
                        );
                      },
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
