import 'dart:core';

import 'package:dio/dio.dart';
import 'package:flutter_colorfly/service/FetchClient.dart';

class ShowRoomRequest {
  static Future<Response> getAllPaintings(
      {String lastId = "", String targetId = ""}) async {
    String requestUrl = FetchClient.ApiHost + '/paintings';
    Map<String, dynamic> params = {"limit": "24", "order": "desc"};
    params['id_greater_than'] = lastId;
    params['id_less_than'] = targetId;
    params['BundleID'] = 'com.elitescastle.colorfy';
    return await FetchClient.get(requestUrl, params);
  }

  static Future<Response> getHotPaintingsList({String date}) async {
    String requestUrl;
    if (date != null) {
      requestUrl = FetchClient.ApiHost + '/famehall/${date}';
    } else {
      requestUrl = FetchClient.ApiHost + '/famehall-latest';
    }

    return await FetchClient.get(requestUrl, new Map());
  }

  static Future<Response> getHotPaintings(List paintingList) async {
    String requestUrl = FetchClient.ApiHost + '/paintings_batch';
    return await FetchClient.post(requestUrl, paintingList);
  }
}
