import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class HttpUtil {
  static Dio dio = new Dio();
  static const String BASE_URL = 'http://192.168.3.251:3000';

  static void init() {
    dio.options.baseUrl = BASE_URL;
    dio.options.connectTimeout = Duration(milliseconds: 5000); // 5s
    dio.options.receiveTimeout = Duration(milliseconds: 5000);
    dio.interceptors.add(InterceptorsWrapper(onRequest:
        (RequestOptions options, RequestInterceptorHandler handler) async {
      debugPrint('发送之前:${options.path}  ${options.data}');
    }, onResponse:
        (Response response, ResponseInterceptorHandler handler) async {
      debugPrint('响应之后:');
    }, onError: (DioError e, ErrorInterceptorHandler handler) async {
      debugPrint('失败了:${e.error}');
    }));
  }

  static Future<Map<String, dynamic>> get(
      String path, Map<String, dynamic> params) async {
    Response response = await dio.get(path, queryParameters: params);
    return response.data;
  }

  static Future<Map<String, dynamic>> post(
      String path, Map<String, dynamic> params) async {
    Response response = await dio.post(path, data: params);
    return response.data;
  }

  static Future<Map<String, dynamic>> upload(
      String path, Map<String, dynamic> params, List<File> files) async {
    FormData formData = new FormData();
    formData.fields.addAll(params.entries
        .map((entry) => MapEntry(entry.key, entry.value.toString())));
    for (var i = 0; i < files.length; i++) {
      String filename = files[i].path.split('/').last;
      formData.files.add(MapEntry("file$i",
          await MultipartFile.fromFile(files[i].path, filename: filename)));
    }
    Response response = await dio.post(path, data: formData);
    return response.data;
  }
}
