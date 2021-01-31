import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GalleryDialog extends StatelessWidget {
  String imgSrc;
  Function continuePress;
  Function onNewPress;
  Function onDeletePress;
  String type = 'gallery';
  GalleryDialog(
      {Key key,
      this.imgSrc,
      this.continuePress,
      this.onNewPress,
      this.type,
      this.onDeletePress})
      : super(key: key);

  Widget renderDeleteButton() {
    if (this.type == 'profile')
      return FlatButton(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onPressed: this.onDeletePress,
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(right: 10),
              child: Image.asset(
                'images/painting/barbarous.png',
                width: 35,
                height: 35,
              ),
            ),
            Text(
              "删除",
              style: TextStyle(color: Colors.black, fontSize: 20),
            )
          ],
        ),
        height: 65,
      );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FlatButton(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onPressed: () {
                Navigator.pop(context);
              },
              padding: EdgeInsets.zero,
              child: Container(
                alignment: Alignment.centerLeft,
                child: Image.asset('images/painting/bondages.png'),
                padding: EdgeInsets.only(left: 12, top: 15),
              )),
          Container(
            width: width,
            height: width * 0.7,
            margin: EdgeInsets.only(
                left: width * 0.15,
                right: width * 0.15,
                top: height * 0.1,
                bottom: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.white,
                image: DecorationImage(image: FileImage(File(this.imgSrc)))),
          ),
          Container(
            width: width * 0.7,
            padding: EdgeInsets.only(left: 15),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                FlatButton(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onPressed: this.onNewPress,
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Image.asset(
                          'images/painting/ampere.png',
                          width: 35,
                          height: 35,
                        ),
                      ),
                      Text(
                        "新建",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      )
                    ],
                  ),
                  height: 65,
                ),
                FlatButton(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onPressed: this.continuePress,
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Image.asset(
                          'images/painting/blastochyle.png',
                          width: 35,
                          height: 35,
                        ),
                      ),
                      Text(
                        "继续",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      )
                    ],
                  ),
                  height: 65,
                ),
                Container(
                  child: renderDeleteButton(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
