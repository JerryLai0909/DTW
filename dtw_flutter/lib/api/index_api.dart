import 'package:dtw_flutter/http/base_api.dart';
import 'package:dtw_flutter/service/custom_service.dart';

class IndexApi extends BaseApi {
  static String getMainInfoData = '/getMainInfoData';
  static String getUserInfo = '/getUserInfo';
  static String createGameInfoAndRecords = '/createGameInfoAndRecords';
  static String getGameMainInfoList = '/getGameMainInfoList';

  String requestPath;
  RequestMethod requestMethod;

  IndexApi({required this.requestPath, required this.requestMethod});

  @override
  String path() {
    return '/dtw' + requestPath;
  }

  @override
  RequestMethod method() {
    return requestMethod;
  }

  @override
  String serviceKey() {
    return customServiceKey;
  }
}
