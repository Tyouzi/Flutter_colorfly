import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorfly/global.dart';
import 'package:flutter_colorfly/service/FetchClient.dart';
import 'package:flutter_colorfly/utils/HexColor.dart';

class ShowRoomDetail extends StatefulWidget {
  var data;
  ShowRoomDetail({Key key, this.data}) : super(key: key);

  @override
  _ShowRoomDetailState createState() => _ShowRoomDetailState();
}

class _ShowRoomDetailState extends State<ShowRoomDetail> {
  String imgUrl;
  String name;
  String profile_picture;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.data);
    imgUrl = FetchClient.ImgHost + widget.data['url'] ?? '';
    name = widget.data['user']['username'] ?? '';
    profile_picture = widget.data['user']['profile_picture'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor(themeColor),
        title: Text('详情'),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [
            Column(
              children: [
                Container(
                  height: 50,
                  child: Row(
                    children: [
                      Container(
                          width: 40,
                          height: 40,
                          margin: EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100)),
                          child: Image.asset(
                            "images/profile/burnables.png",
                            width: 40,
                            height: 40,
                          )),
                      Text(
                        name,
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      )
                    ],
                  ),
                ),
                Container(
                  width: width,
                  height: width,
                  child: Image.network(imgUrl),
                )
              ],
            )
          ],
        ),
      ),
    ));
  }
}
