import 'package:dio/dio.dart';
import 'package:flutter_colorfly/service/UserRequest.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../global.dart';

class FetchClient {
  static final String ApiHost = "http://13.57.228.178:9000/v2";
  static final String ImgHost = "https://colorfly.joycastle.mobi";
  static createInstance() {
    dio.options.baseUrl = ApiHost;
    dio.options.connectTimeout = 15000;
  }

  static Future<Response> get(String url, Map<String, String> map) async {
    try {
      var sp = await SharedPreferences.getInstance();
      dio.options.headers["Authorization"] = sp.getString('token');
      print('token === ' + sp.getString('token'));
      Response response = await dio.get(url, queryParameters: map);
      return response;
    } on DioError catch (e) {
      print(e);
      if (e.response != null &&
          (e.response.statusCode == 401 || e.response.statusCode == 403)) {
        UserRequest.login();
      }
    }
  }

  static Future post(String url, Map map) async {
    try {
      Response response = await dio.post(url, data: map);
      return response;
    } on DioError catch (e) {
      if (e.response.statusCode == 401 || e.response.statusCode == 403) {
        UserRequest.login();
      }
    }
  }
}
