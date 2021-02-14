import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_colorfly/service/FetchClient.dart';
import 'package:flutter_colorfly/utils/UserDeviceInfo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRequest {
  static regist() async {
    String id = await UserDeviceInfo.getDeviceId();
    Response response = await FetchClient.post("/register", {"device_id": id});
    String name = response.data["id"];
    var sp = await SharedPreferences.getInstance();
    sp.setString("id", name);
    await login();
  }

  static Future<bool> login() async {
    var sp = await SharedPreferences.getInstance();
    String id = sp.getString('id');
    if (id != null) {
      String pwd = await UserDeviceInfo.getDeviceId();
      Response response =
          await FetchClient.post("/login", {"user_id": id, "password": pwd});
      String token = response.data["token"];
      sp.setString("token", "Bearer " + token);
      return true;
    } else {
      regist();
    }
  }

  static Future<Response> getUserInfo() async {
    String requestUri = FetchClient.ApiHost + '/me';
    Response response = await FetchClient.get(requestUri, {});
    return response;
  }

  static Future<Response> getMyPaintings(int page) async {
    String requestUri = '/me/paintings';
    Response response =
        await FetchClient.get(requestUri, {"page": page, "limit": 24});
    return response;
  }

  static Future<Response> deleteMyPaintings(int id) async {
    String requestUri = '/paintings/${id}';
    Response response = await FetchClient.delete(requestUri, {});
    return response;
  }
}
