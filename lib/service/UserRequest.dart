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

  static login() async {
    var sp = await SharedPreferences.getInstance();
    String id = sp.getString('id');
    if (id != null) {
      String pwd = await UserDeviceInfo.getDeviceId();
      Response response =
          await FetchClient.post("/login", {"user_id": id, "password": pwd});
      String token = response.data["token"];
      sp.setString("token", "Bearer " + token);
    } else {
      regist();
    }
  }
}
