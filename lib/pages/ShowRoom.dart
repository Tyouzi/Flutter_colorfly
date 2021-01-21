import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorfly/component/show_room/show_room_gridview.dart';
import 'package:flutter_colorfly/utils/HexColor.dart';
import 'package:flutter_colorfly/global.dart';

import '../global.dart';

class ShowRoom extends StatefulWidget {
  @override
  State<ShowRoom> createState() {
    // TODO: implement createState
    return ShowRoomPageState();
  }
}

class ShowRoomPageState extends State<ShowRoom>
    with SingleTickerProviderStateMixin {
  double screenWidth;
  List tabNames = ['发现', '热门'];
  TabController _tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = new TabController(length: tabNames.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
        child: Container(
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: HexColor(themeColor),
            height: 50,
            alignment: Alignment(0.0, 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '画廊',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                )
              ],
            ),
          ),
          Material(
            color: Colors.white,
            child: TabBar(
              tabs: tabNames.map((e) {
                return Tab(
                  child: Text(
                    e,
                    style: TextStyle(fontSize: 18),
                  ),
                );
              }).toList(),
              controller: _tabController,
              labelColor: HexColor(themeColor),
              indicatorColor: HexColor(themeColor),
              unselectedLabelColor: Colors.black,
            ),
          ),
          Expanded(
              flex: 1,
              child: TabBarView(
                children: tabNames.map((e) {
                  return ShowRoomGridView(e);
                }).toList(),
                controller: _tabController,
              ))
        ],
      ),
    ));
  }
}
