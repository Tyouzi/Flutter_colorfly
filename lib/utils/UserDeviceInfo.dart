import 'dart:io';

import 'package:device_info/device_info.dart';

class UserDeviceInfo {
 
  static  Future<String> getDeviceId()async{
     DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
     if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
       return build.androidId;  //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        return data.identifierForVendor;  //UUID for iOS
      }
  }
}