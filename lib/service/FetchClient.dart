import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../global.dart';



class FetchClient {
  static const String ApiHost ="http://13.57.228.178:9000/v2";
  static const String ImgHost = "http://colorfly-testing.elitescastle.com:9998";
  static createInstance(){
    SharedPreferences.getInstance().then((sp){
      dio.options.baseUrl=ApiHost;
      dio.options.connectTimeout = 15000;
      print(sp.getString("token"));
      dio.options.headers["Authorization"]=sp.getString('token');
      // dio.options.contentType= Headers.formUrlEncodedContentType;
      
    });
    
  }
  static Future<Response> get(String url,Map<String,String> map) async{
      try {
          Response response = await dio.get(url,queryParameters:map);
            return response;
      }on DioError catch (e){
          print(e.error);
      }
     
    
  }
  static Future post(String url,Map map)async{
      Response response =await dio.post(url,data: map);
      return response;
  }
}