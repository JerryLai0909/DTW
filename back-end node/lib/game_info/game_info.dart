import 'dart:convert';

import 'package:collection/collection.dart';

import 'game_record.dart';

class GameInfo {
  int? id;
  String? gameHash;
  String? gameCreaterHash;
  String? gameSensorType;
  String? gameTitle;
  String? gameDesc;
  DateTime? createTime;
  List<GameRecord>? gameRecords;

  GameInfo({
    this.id,
    this.gameHash,
    this.gameCreaterHash,
    this.gameSensorType,
    this.gameTitle,
    this.gameDesc,
    this.createTime,
    this.gameRecords,
  });

  @override
  String toString() {
    return 'GameInfo(id: $id, gameHash: $gameHash, gameCreaterHash: $gameCreaterHash, gameSensorType: $gameSensorType, gameTitle: $gameTitle, gameDesc: $gameDesc, createTime: $createTime, gameRecords: $gameRecords)';
  }

  factory GameInfo.fromMap(Map<String, dynamic> data) => GameInfo(
        id: data['id'] as int?,
        gameHash: data['game_hash'] as String?,
        gameCreaterHash: data['game_creater_hash'] as String?,
        gameSensorType: data['game_sensor_type'] as String?,
        gameTitle: data['game_title'] as String?,
        gameDesc: data['game_desc'] as String?,
        createTime: data['create_time'] == null
            ? null
            : DateTime.parse(data['create_time'] as String),
        gameRecords: (data['game_records'] as List<dynamic>?)
            ?.map((e) => GameRecord.fromMap(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'game_hash': gameHash,
        'game_creater_hash': gameCreaterHash,
        'game_sensor_type': gameSensorType,
        'game_title': gameTitle,
        'game_desc': gameDesc,
        'create_time': createTime?.toIso8601String(),
        'game_records': gameRecords?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [GameInfo].
  factory GameInfo.fromJson(String data) {
    return GameInfo.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [GameInfo] to a JSON string.
  String toJson() => json.encode(toMap());

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! GameInfo) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode =>
      id.hashCode ^
      gameHash.hashCode ^
      gameCreaterHash.hashCode ^
      gameSensorType.hashCode ^
      gameTitle.hashCode ^
      gameDesc.hashCode ^
      createTime.hashCode ^
      gameRecords.hashCode;
}
