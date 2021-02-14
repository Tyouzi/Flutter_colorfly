import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_colorfly/config/share-preference-tags.dart';
import 'package:flutter_colorfly/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'FetchClient.dart';

class GalleryRequest {
  static getAllPaintings() async {
    var sp = await SharedPreferences.getInstance();
    String lastUpdateTimes =
        sp.getString(SharePreferenceTags.lastUpdateGallery);
    if (lastUpdateTimes == null) lastUpdateTimes = "2018-03-20T11:01:01.801Z";
    return FetchClient.get('/templates',
        {"updated_after": lastUpdateTimes, "is_official": "true"});
  }

  static upLoadPainting(String url, String svgUrl, String svgId) async {
    var name = url.substring(url.lastIndexOf("/") + 1, url.length);
    var image = await MultipartFile.fromFile(
      url,
      filename: 'painting_file.png',
    );
    var image2 = await MultipartFile.fromFile(
      svgUrl,
      filename: 'color_file.svg',
    );
    String path = '/paintings';
    FormData data = FormData.fromMap({
      "painting_file": image,
      "template_id": svgId,
      "is_template_open": true,
      'color_file': image2
    });
    print(data.toString());
    Response response = await FetchClient.post(path, data);
    print(response.data);
  }
}
// String id;
// bool is_open;
// String main_tag;
// List<String> tags ;
// String url;
// String thumbnail_url;
// String jigsaw_id;
// String jigsaw_num;
// String open_time;
// String updated_time;
