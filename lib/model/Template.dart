/// id : "holiday_235-17-3"
/// is_open : true
/// main_tag : "date"
/// tags : ["official","new"]
/// url : "/static/templates/20180302/5fb19555a3ac43b396fbd8b16d5237d8.svg"
/// thumbnail_url : "/static/templates/20180302/5fb19555a3ac43b396fbd8b16d5237d8.300w.png"
/// jigsaw_id : ""
/// jigsaw_num : 0
/// open_time : "2018-04-01T00:00:00Z"
/// updated_time : "2018-03-31T00:00:00Z"

class Template {
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

  Template(this._id, this._isOpen, this._mainTag, this._tags, this._url, this._thumbnailUrl, this._jigsawId, this._jigsawNum, this._openTime, this._updatedTime);

  Template.map(dynamic obj) {
    this._id = obj["id"];
    this._isOpen = obj["isOpen"];
    this._mainTag = obj["mainTag"];
    this._tags = obj["tags"].cast<String>();
    this._url = obj["url"];
    this._thumbnailUrl = obj["thumbnailUrl"];
    this._jigsawId = obj["jigsawId"];
    this._jigsawNum = obj["jigsawNum"];
    this._openTime = obj["openTime"];
    this._updatedTime = obj["updatedTime"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = _id;
    map["isOpen"] = _isOpen;
    map["mainTag"] = _mainTag;
    map["tags"] = _tags;
    map["url"] = _url;
    map["thumbnailUrl"] = _thumbnailUrl;
    map["jigsawId"] = _jigsawId;
    map["jigsawNum"] = _jigsawNum;
    map["openTime"] = _openTime;
    map["updatedTime"] = _updatedTime;
    return map;
  }

}