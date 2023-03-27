import 'dart:convert';

class User {
  int? id;
  String? userHash;
  String? blockChainHash;
  String? userName;
  int? userCoin;
  String? userLevel;
  int? doneNumber;
  int? nftNumber;
  DateTime? createTime;
  DateTime? updateTime;

  User({
    this.id,
    this.userHash,
    this.blockChainHash,
    this.userName,
    this.userCoin,
    this.userLevel,
    this.doneNumber,
    this.nftNumber,
    this.createTime,
    this.updateTime,
  });

  @override
  String toString() {
    return 'User(id: $id, userHash: $userHash, blockChainHash: $blockChainHash, userName: $userName, userCoin: $userCoin, userLevel: $userLevel, doneNumber: $doneNumber, nftNumber: $nftNumber, createTime: $createTime, updateTime: $updateTime)';
  }

  factory User.fromMap(Map<String, dynamic> data) => User(
        id: data['id'] as int?,
        userHash: data['user_hash'] as String?,
        blockChainHash: data['block_chain_hash'] as String?,
        userName: data['user_name'] as String?,
        userCoin: data['user_coin'] as int?,
        userLevel: data['user_level'] as String?,
        doneNumber: data['done_number'] as int?,
        nftNumber: data['nft_number'] as int?,
        createTime: data['create_time'] == null
            ? null
            : DateTime.parse(data['create_time'] as String),
        updateTime: data['update_time'] == null
            ? null
            : DateTime.parse(data['update_time'] as String),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'user_hash': userHash,
        'block_chain_hash': blockChainHash,
        'user_name': userName,
        'user_coin': userCoin,
        'user_level': userLevel,
        'done_number': doneNumber,
        'nft_number': nftNumber,
        'create_time': createTime?.toIso8601String(),
        'update_time': updateTime?.toIso8601String(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [User].
  factory User.fromJson(String data) {
    return User.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [User] to a JSON string.
  String toJson() => json.encode(toMap());
}
