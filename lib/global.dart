import 'package:dio/dio.dart';
import 'package:flutter_colorfly/utils/sembast_db.dart';
import 'package:flutter_colorfly/utils/EventBus.dart';
import 'package:sembast/sembast.dart';

var dio = Dio();

final String themeColor = '#ed7c84';
final String themeGrey = '#f5f5f5';
final EventBus bus = new EventBus();

class Global {
  static Future initGlobal() async {
    SemDataBase.initDataBase();
  }
}
