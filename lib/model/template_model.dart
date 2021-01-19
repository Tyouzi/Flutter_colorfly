/// id : "omnom_269-14-3"
/// is_open : true
/// main_tag : "omnom"
/// tags : ["official","free"]
/// url : "/static/templates/20190129/ea74304c4efb4cb3b78c0ed9ecdc0c92.svg"
/// thumbnail_url : "/static/templates/20190129/ea74304c4efb4cb3b78c0ed9ecdc0c92.300w.jpg"
/// jigsaw_id : ""
/// jigsaw_num : 0
/// open_time : "2019-02-23T00:00:00Z"
/// updated_time : "2019-02-22T00:00:00Z"

class TemplateModel {
  String _id;
  bool _isOpen;
  String _mainTag;
  List<String> _tags;
  String _url;
  String _thumbnailUrl;
  String _jigsawId;
  int _jigsawNum;
  String _openTime;
  String _updatedTime;

  String get id => _id;
  bool get isOpen => _isOpen;
  String get mainTag => _mainTag;
  List<String> get tags => _tags;
  String get url => _url;
  String get thumbnailUrl => _thumbnailUrl;
  String get jigsawId => _jigsawId;
  int get jigsawNum => _jigsawNum;
  String get openTime => _openTime;
  String get updatedTime => _updatedTime;

  TemplateModel(
      {String id,
      bool isOpen,
      String mainTag,
      List<String> tags,
      String url,
      String thumbnailUrl,
      String jigsawId,
      int jigsawNum,
      String openTime,
      String updatedTime}) {
    _id = id;
    _isOpen = isOpen;
    _mainTag = mainTag;
    _tags = tags;
    _url = url;
    _thumbnailUrl = thumbnailUrl;
    _jigsawId = jigsawId;
    _jigsawNum = jigsawNum;
    _openTime = openTime;
    _updatedTime = updatedTime;
  }

  TemplateModel.fromJson(dynamic json) {
    _id = json["id"];
    _isOpen = json["is_open"];
    _mainTag = json["main_tag"];
    _tags = json["tags"] != null ? json["tags"].cast<String>() : [];
    _url = json["url"];
    _thumbnailUrl = json["thumbnail_url"];
    _jigsawId = json["jigsaw_id"];
    _jigsawNum = json["jigsaw_num"];
    _openTime = json["open_time"];
    _updatedTime = json["updated_time"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["is_open"] = _isOpen;
    map["main_tag"] = _mainTag;
    map["tags"] = _tags;
    map["url"] = _url;
    map["thumbnail_url"] = _thumbnailUrl;
    map["jigsaw_id"] = _jigsawId;
    map["jigsaw_num"] = _jigsawNum;
    map["open_time"] = _openTime;
    map["updated_time"] = _updatedTime;
    return map;
  }
}
