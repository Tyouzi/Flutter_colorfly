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
