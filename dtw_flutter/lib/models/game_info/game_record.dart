import 'dart:convert';

import 'package:collection/collection.dart';

class GameRecord {
  int? id;
  String? gameHash;
  int? sensorType;
  String? sensorName;
  int? minX;
  int? maxX;
  int? minY;
  int? maxY;
  String? recordData;
  int? totalTime;
  int? needCheck;
  DateTime? createTime;

  GameRecord({
    this.id,
    this.gameHash,
    this.sensorType,
    this.sensorName,
    this.minX,
    this.maxX,
    this.minY,
    this.maxY,
    this.recordData,
    this.totalTime,
    this.needCheck,
    this.createTime,
  });

  @override
  String toString() {
    return 'GameRecord(id: $id, gameHash: $gameHash, sensorType: $sensorType, sensorName: $sensorName, minX: $minX, maxX: $maxX, minY: $minY, maxY: $maxY, recordData: $recordData, totalTime: $totalTime, needCheck: $needCheck, createTime: $createTime)';
  }

  factory GameRecord.fromMap(Map<String, dynamic> data) => GameRecord(
        id: data['id'] as int?,
        gameHash: data['game_hash'] as String?,
        sensorType: data['sensor_type'] as int?,
        sensorName: data['sensor_name'] as String?,
        minX: data['min_x'] as int?,
        maxX: data['max_x'] as int?,
        minY: data['min_y'] as int?,
        maxY: data['max_y'] as int?,
        recordData: data['record_data'] as String?,
        totalTime: data['total_time'] as int?,
        needCheck: data['need_check'] as int?,
        createTime: data['create_time'] == null
            ? null
            : DateTime.parse(data['create_time'] as String),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'game_hash': gameHash,
        'sensor_type': sensorType,
        'sensor_name': sensorName,
        'min_x': minX,
        'max_x': maxX,
        'min_y': minY,
        'max_y': maxY,
        'record_data': recordData,
        'total_time': totalTime,
        'need_check': needCheck,
        'create_time': createTime?.toIso8601String(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [GameRecord].
  factory GameRecord.fromJson(String data) {
    return GameRecord.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [GameRecord] to a JSON string.
  String toJson() => json.encode(toMap());

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! GameRecord) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode =>
      id.hashCode ^
      gameHash.hashCode ^
      sensorType.hashCode ^
      sensorName.hashCode ^
      minX.hashCode ^
      maxX.hashCode ^
      minY.hashCode ^
      maxY.hashCode ^
      recordData.hashCode ^
      totalTime.hashCode ^
      needCheck.hashCode ^
      createTime.hashCode;
}
