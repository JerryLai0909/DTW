import 'package:dtw_flutter/pages/create_game_page.dart';
import 'package:dtw_flutter/pages/create_sensor_record.dart';
import 'package:dtw_flutter/pages/main_page.dart';
import 'package:dtw_flutter/providers/info_provider.dart';
import 'package:dtw_flutter/providers/sensor_provider.dart';
import 'package:dtw_flutter/providers/user_provider.dart';
import 'package:dtw_flutter/service/custom_service.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'http/service_manager.dart';
import 'pages/display.dart';

void main() {
  ServiceManager().registeredService(CustomService());
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<UserProvider>(
        create: (context) => UserProvider(),
      ),
      ChangeNotifierProvider<InfoProvider>(
        create: (context) => InfoProvider(),
      ),
      ChangeNotifierProvider<SensorProvider>(
        create: (context) => SensorProvider(),
      )
    ],
    child: const MyApp(),
  ));
}

final ThemeData lightTheme = ThemeData.light().copyWith(
  primaryColor: Colors.blue, // 设置主色
  accentColor: Colors.orange, // 设置强调色
  // 添加其他自定义主题数据，如字体等
);
final ThemeData darkTheme = ThemeData.dark().copyWith(
  primaryColor: Colors.blue, // 设置主色
  accentColor: Colors.orange, // 设置强调色
  // 添加其他自定义主题数据，如字体等
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: darkTheme,
      title: 'DTW Welcome',
      initialRoute: '/',
      routes: {
        '/': (context) => const MainPage(),
        '/display': (context) => const DisplayPage(),
        '/create_game_page': (context) => CreateGamePage(),
        '/create_sensor_record': (context) => CreateSensorRecordPage(),
      },
    );
  }
}
