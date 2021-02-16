import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter_colorfly/utils/sembast_db.dart';
import 'package:flutter_colorfly/utils/EventBus.dart';
import 'package:sembast/sembast.dart';

var dio = Dio();

final String themeColor = '#ed7c84';
final String themeGrey = '#f5f5f5';
final EventBus bus = new EventBus();
final double screenWidth = window.physicalSize.width / window.devicePixelRatio;
final double screenHeight =
    window.physicalSize.height / window.devicePixelRatio;

class Global {
  static Future initGlobal() async {
    SemDataBase.initDataBase();
  }
}
