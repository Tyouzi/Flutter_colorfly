import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_colorfly/service/UserRequest.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../global.dart';

class FetchClient {
  static final String ApiHost = "https://colorfly.joycastle.mobi/v2";
  static final String ImgHost = "https://colorfly.joycastle.mobi";
  static createInstance() {
    dio.options.baseUrl = ApiHost;
    dio.options.connectTimeout = 15000;
  }

  static Future<Response> get(String url, Map<String, dynamic> map) async {
    try {
      var sp = await SharedPreferences.getInstance();
      dio.options.headers["Authorization"] = sp.getString('token');
      print('token === ' + sp.getString('token'));
      Response response = await dio.get(url,
          queryParameters: map,
          options: Options(
              followRedirects: false,
              validateStatus: (status) {
                return status < 500;
              }));
      if (response.statusCode != null &&
          (response.statusCode == 401 || response.statusCode == 403)) {
        bool result = await UserRequest.login();
        if (result) {
          response = await FetchClient.get(url, map);
        }
      }
      return response;
    } catch (e) {
      print('error ===' + e.message);
    }
  }

  static Future post(String url, map) async {
    try {
      var sp = await SharedPreferences.getInstance();
      dio.options.headers["Authorization"] = sp.getString('token');
      Response response = await dio.post(url,
          data: map,
          options: Options(
              followRedirects: false,
              validateStatus: (status) {
                return status < 500;
              }));
      if (response.statusCode != null &&
          (response.statusCode == 401 || response.statusCode == 403)) {
        bool result = await UserRequest.login();
        if (result) {
          response = await FetchClient.post(url, map);
        }
      }
      return response;
    } catch (e) {
      print('error ===' + e.message);
      if (e.response.statusCode == 401 || e.response.statusCode == 403) {
        UserRequest.login();
      }
    }
  }
}
//Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2MTEwNTQ5MTMsImlkIjoidTUzMjEyNDIifQ.B1-IPFrBsjqyvvTV3CnBuhF5wSW02g9E_chakQy4L5E
