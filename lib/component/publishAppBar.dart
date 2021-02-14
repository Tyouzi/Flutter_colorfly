import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorfly/config/ImageAssets.dart';
import 'package:flutter_colorfly/global.dart';
import 'package:flutter_colorfly/utils/HexColor.dart';

class PublishAppBar extends StatelessWidget {
  Function onFinish;
  PublishAppBar({Key key, this.onFinish}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 50,
      padding: EdgeInsets.only(left: 15, right: 15),
      child: Row(
        children: [
          GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                child: Image.asset(
                  ImgAssets.paintingBack,
                  width: 20,
                  height: 20,
                ),
              )),
          Expanded(
              child: Center(
            child: Text(
              '发布',
              style: TextStyle(fontSize: 20, color: HexColor(themeColor)),
            ),
          )),
          GestureDetector(
            onTap: () {
              this.onFinish();
            },
            child:
                Image.asset(ImgAssets.paintingComplate, width: 20, height: 20),
          )
        ],
      ),
    );
  }
}
