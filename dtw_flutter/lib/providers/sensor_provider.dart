import 'package:dtw_flutter/models/game_info/game_info.dart';
import 'package:dtw_flutter/models/game_info/game_record.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';

import '../api/index_api.dart';
import '../http/base_api.dart';
import '../resources/app_colors.dart';

class SensorProvider with ChangeNotifier {
  List<Color> gradientColorsA = [
    AppColors.contentColorRed,
    AppColors.contentColorPink,
  ];

  List<Color> gradientColorsB = [
    AppColors.contentColorYellow,
    AppColors.contentColorOrange,
  ];

  List<Color> gradientColorsC = [
    AppColors.contentColorCyan,
    AppColors.contentColorBlue,
  ];

  List<Color> gradientColorsNo = [
    AppColors.gridLinesColor,
    AppColors.borderColor,
  ];

  double totalTime = 30;

  void setTotalTime(double time) {
    totalTime = time;
  }

  void sendInsert(sensor_type, data_type, axis_data, datas, total_time,
      need_check, Function callBack) {
    IndexApi api = IndexApi(
        requestPath: IndexApi.createGameInfoAndRecords,
        requestMethod: RequestMethod.post);
    Map<String, dynamic> body = {
      "game_creater_hash": 'JERRYLAI-0XHAHAHAHHAHWINRICHNIUBIALITY',
      "sensor_type": sensor_type,
      "data_type": data_type,
      "axis_data": axis_data,
      "datas": datas,
      "total_time": total_time,
      "need_check": need_check
    };
    api.request(
        body: body,
        successCallBack: (res) {
          callBack(res);
          notifyListeners();
        },
        errorCallBack: (error) {});
  }

  List<FlSpot> convertStringToFlSpot(String str) {
    List<String> values = str.replaceAll(RegExp(r'[\[\]\(\)]'), '').split(', ');
    List<FlSpot> spots = [];
    for (int i = 0; i < values.length; i += 2) {
      spots.add(FlSpot(double.parse(values[i]), double.parse(values[i + 1])));
    }
    return spots;
  }

  LineChartData getLineChartByRecordData(List<GameRecord>? record) {
    debugPrint('查看record ===》 ${record}');
    if (record == null) {
      record = [];
    }
    final baseData = record[0];
    final sensorType = baseData.sensorType;
    final sensorName = baseData.sensorName;
    final totalTime = baseData.totalTime;
    final minX = baseData.minX;
    final maxX = baseData.maxX;
    final minY = baseData.minY;
    final maxY = baseData.maxY;
    final acceXStr = record[0].recordData;
    final accexChecked = record[0].needCheck;

    final acceYStr = record[1].recordData;
    final acceyChecked = record[0].needCheck;

    final acceZStr = record[2].recordData;
    final accezChecked = record[0].needCheck;

    List<LineChartBarData> charts = [];

    final acceX = convertStringToFlSpot(acceXStr!);
    final acceY = convertStringToFlSpot(acceYStr!);
    final acceZ = convertStringToFlSpot(acceZStr!);

    charts.add(getLineChartBarData(
        acceX, accexChecked == 1 ? gradientColorsA : gradientColorsNo));

    charts.add(getLineChartBarData(
        acceY, acceyChecked == 1 ? gradientColorsA : gradientColorsNo));

    charts.add(getLineChartBarData(
        acceZ, accezChecked == 1 ? gradientColorsA : gradientColorsNo));

    return LineChartData(
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(show: false),
      borderData: getFlBorderData(),
      minX: double.parse(minX.toString()),
      maxX: double.parse(maxX.toString()),
      minY: double.parse(minY.toString()),
      maxY: double.parse(maxY.toString()),
      lineBarsData: charts,
    );
  }

/**
 * sensorType 为传感器类型 1为加速度计 2为陀螺仪
 * dataType 为数据类型，如加速度计XYZ 三个轴，到底要哪个
 * 面对三个的情况 1 =》X 2=》Y 3=》Z 4=》X+Y 5=》X+Z 6=》Y+Z 7=》X+Y+Z
 */
  LineChartData lineDataFactory(
      int sensorType,
      int dataType,
      double minX,
      double maxX,
      double minY,
      double maxY,
      List<List<FlSpot>> datas,
      double totalTime) {
    List<LineChartBarData> charts = [];
    switch (sensorType) {
      case 0:
      case 1: //加速度计
        switch (dataType) {
          case 1:
            charts.add(getLineChartBarData(datas[0], gradientColorsA));
            charts.add(getLineChartBarData(datas[1], gradientColorsNo));
            charts.add(getLineChartBarData(datas[2], gradientColorsNo));
            break;
          case 2:
            charts.add(getLineChartBarData(datas[0], gradientColorsNo));
            charts.add(getLineChartBarData(datas[1], gradientColorsB));
            charts.add(getLineChartBarData(datas[2], gradientColorsNo));
            break;
          case 3:
            charts.add(getLineChartBarData(datas[0], gradientColorsNo));
            charts.add(getLineChartBarData(datas[1], gradientColorsNo));
            charts.add(getLineChartBarData(datas[2], gradientColorsC));
            break;
          case 4:
            charts.add(getLineChartBarData(datas[0], gradientColorsA));
            charts.add(getLineChartBarData(datas[1], gradientColorsB));
            charts.add(getLineChartBarData(datas[2], gradientColorsNo));
            break;
          case 5:
            charts.add(getLineChartBarData(datas[0], gradientColorsA));
            charts.add(getLineChartBarData(datas[1], gradientColorsNo));
            charts.add(getLineChartBarData(datas[2], gradientColorsC));
            break;
          case 6:
            charts.add(getLineChartBarData(datas[0], gradientColorsNo));
            charts.add(getLineChartBarData(datas[1], gradientColorsB));
            charts.add(getLineChartBarData(datas[2], gradientColorsC));
            break;
          case 7:
            charts.add(getLineChartBarData(datas[0], gradientColorsA));
            charts.add(getLineChartBarData(datas[1], gradientColorsB));
            charts.add(getLineChartBarData(datas[2], gradientColorsC));
            break;
          default:
            break;
        }
        break;
      default:
        break;
    }
    return LineChartData(
      gridData: getFlGridData(),
      titlesData: getFlTitleData(sensorType, totalTime),
      borderData: getFlBorderData(),
      minX: minX,
      maxX: maxX,
      minY: minY,
      maxY: maxY,
      lineBarsData: charts,
    );
  }

  LineChartBarData getLineChartBarData(
      List<FlSpot> data, List<Color> gradientColors) {
    return LineChartBarData(
      spots: data,
      isCurved: true,
      gradient: LinearGradient(
        colors: gradientColors,
      ),
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors:
              gradientColors.map((color) => color.withOpacity(0.3)).toList(),
        ),
      ),
    );
  }

  FlGridData getFlGridData() {
    return FlGridData(
      show: true,
      drawVerticalLine: true,
      horizontalInterval: 1,
      verticalInterval: 1,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: AppColors.mainGridLineColor,
          strokeWidth: 1,
        );
      },
      getDrawingVerticalLine: (value) {
        return FlLine(
          color: AppColors.mainGridLineColor,
          strokeWidth: 1,
        );
      },
    );
  }

  FlTitlesData getFlTitleData(int sensorType, double totalTime) {
    return FlTitlesData(
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
          getTitlesWidget:
              (sensorType == 0 ? leftTitleWidgetsAcce : leftTitleWidgetsGyro),
          reservedSize: 20,
        ),
      ),
    );
  }

  FlBorderData getFlBorderData() {
    return FlBorderData(
      show: true,
      border: Border.all(color: AppColors.pageBackground),
    );
  }

  Widget leftTitleWidgetsAcce(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 8,
    );
    String text = value.toString();
    switch (value.toInt()) {
      case -8:
        text = "-20";
        break;
      case -7:
        text = "-17.5";
        break;
      case -6:
        text = "-15";
        break;
      case -5:
        text = "-12.5";
        break;
      case -4:
        text = "-10";
        break;
      case -3:
        text = "-7.5";
        break;
      case -2:
        text = "-5";
        break;
      case -1:
        text = "-2.5";
        break;
      case 0:
        text = "0";
        break;
      case 1:
        text = "2.5";
        break;
      case 2:
        text = "5";
        break;
      case 3:
        text = "7.5";
        break;
      case 4:
        text = "10";
        break;
      case 5:
        text = "12.5";
        break;
      case 6:
        text = "15";
        break;
      case 7:
        text = "17.5";
        break;
      case 8:
        text = "20";
        break;
      default:
        text = "bug";
        break;
    }
    return Text(text, style: style, textAlign: TextAlign.left);
  }

  Widget leftTitleWidgetsGyro(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 8,
    );
    String text = value.toStringAsFixed(2);
    return Text(text, style: style, textAlign: TextAlign.left);
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 8,
    );
    Widget text;
    double single = totalTime / 10;
    String content = '';
    content = value.toStringAsFixed(2);
    text = Text(
      content,
      style: style,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }
}
