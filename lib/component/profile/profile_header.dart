import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorfly/service/UserRequest.dart';
import 'package:flutter_colorfly/utils/HexColor.dart';

import '../../global.dart';

class ProfileHeader extends StatefulWidget {
  ProfileHeader({Key key}) : super(key: key);

  @override
  _ProfileHeaderState createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader>
    with AutomaticKeepAliveClientMixin {
  List itemList = [
    {"number": 0, "title": "喜欢"},
    {"number": 0, "title": "已发布"},
    {"number": 0, "title": "粉丝"},
    {"number": 0, "title": "关注中"}
  ];
  String userName = '';
  double screenWidth = 0;
  Widget statusBarItem(String number, String title) {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          number,
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 12),
        )
      ],
    ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.requstUserInfo();
  }

  Future requstUserInfo() async {
    Response response = await UserRequest.getUserInfo();
    this.setState(() {
      userName = response.data['username'] ?? '';
      int likes = response.data['counts']['likes'] ?? 0;
      int follows = response.data['counts']['follows'] ?? 0;
      int followed_by = response.data['counts']['followed_by'] ?? 0;
      int painting = response.data['counts']['painting'] ?? 0;
      itemList = [
        {"number": likes, "title": "喜欢"},
        {"number": painting, "title": "已发布"},
        {"number": follows, "title": "粉丝"},
        {"number": followed_by, "title": "关注中"}
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 40, bottom: 20),
        child: Column(
          children: [
            Container(
              child: Row(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Image.asset(
                      "images/profile/burnables.png",
                      width: 70,
                      height: 70,
                    ),
                  ),
                  Container(
                    height: 70,
                    alignment: Alignment.center,
                    child: Text(
                      userName,
                      style: TextStyle(
                          color: HexColor('#2f2f2f'),
                          fontSize: 22,
                          fontWeight: FontWeight.w200),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 70,
              margin: EdgeInsets.only(left: 10, right: 10),
              padding: EdgeInsets.only(left: 25, right: 25),
              decoration: BoxDecoration(
                color: HexColor(themeColor),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: itemList.map((value) {
                    return statusBarItem("${value["number"]}", value["title"]);
                  }).toList()),
            ),
          ],
        ));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
