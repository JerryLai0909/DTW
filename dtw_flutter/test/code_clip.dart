// 检查传感器权限
Future<void> _checkSensorPermission() async {
  bool hasPermission = await Sensors.isSensorPermissionGranted();
  setState(() {
    _hasSensorPermission = hasPermission;
  });
}

// 请求传感器权限
Future<void> _requestSensorPermission() async {
  bool success = await Sensors.requestSensorPermission();
  setState(() {
    _hasSensorPermission = success;
  });
}
