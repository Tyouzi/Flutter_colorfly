import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorfly/global.dart';
import 'package:flutter_colorfly/pages/AnimationTest.dart';
import 'package:flutter_colorfly/utils/HexColor.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class Creaction extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CreationState();
  }
}

class CreationState extends State<Creaction> {
  onPressCamera() {
    // EasyLoading.showToast('敬请期待');
    Navigator.push(
        context, MaterialPageRoute(builder: (builder) => AnimationTest()));
  }

  onPressAlbum() {
    EasyLoading.showToast('敬请期待');
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    double width = MediaQuery.of(context).size.width;
    double btWidth = width * 0.80;
    return SafeArea(
        child: Container(
      color: HexColor('#e9e9e9'),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            color: HexColor(themeColor),
            height: 50,
            child: Text(
              '创建',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          Image.asset(
            'images/painting/adjoints.png',
            width: btWidth,
            height: btWidth,
          ),
          Text(
            '从你的相册或照相导入一张线图进行涂色吧！',
            style: TextStyle(color: HexColor('#4b4b4b'), fontSize: 14),
          ),
          FlatButton(
              onPressed: onPressCamera,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              padding: EdgeInsets.only(bottom: 20, top: 40),
              child: Container(
                width: btWidth,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: HexColor('#9982de'),
                ),
                child: Text(
                  '拍照',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              )),
          FlatButton(
              onPressed: onPressAlbum,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              padding: EdgeInsets.only(bottom: 20, top: 20),
              child: Container(
                width: btWidth,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: HexColor('#88a4f8'),
                ),
                child: Text(
                  '从相册导入',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ))
        ],
      ),
    ));
  }
}
