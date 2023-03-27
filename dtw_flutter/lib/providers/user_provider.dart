import 'package:dtw_flutter/http/base_api.dart';
import 'package:flutter/material.dart';

import '../api/index_api.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  User user = new User();
  UserProvider() {
    user.userCoin = 0;
    user.userName = '?';
    user.userLevel = '正在加载';
  }
  String? get userName => user.userName;
  String? get userCoin => user.userCoin.toString();
  String? get userLevel => user.userLevel;

  void getUserInfoRequest() async {
    IndexApi api = IndexApi(
        requestPath: IndexApi.getUserInfo, requestMethod: RequestMethod.post);
    Map<String, dynamic> body = {
      "user_id": "1",
    };
    api.request(
        body: body,
        successCallBack: (res) {
          final result = res.data;
          final User userResult = User.fromMap(result);
          user = userResult;
          notifyListeners();
        },
        errorCallBack: (error) {});
  }
}
