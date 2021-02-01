import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorfly/component/profile/artwork_list.dart';
import 'package:flutter_colorfly/component/profile/published_list.dart';
import 'package:flutter_colorfly/global.dart';
import 'package:flutter_colorfly/utils/HexColor.dart';

class ProfileTabBar extends StatefulWidget {
  ProfileTabBar({Key key}) : super(key: key);

  @override
  _ProfileTabBarState createState() => _ProfileTabBarState();
}

class _ProfileTabBarState extends State<ProfileTabBar>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = new TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    double itemWidth = MediaQuery.of(context).size.width / 2;
    return Container(
      child: Column(children: [
        TabBar(
            controller: tabController,
            unselectedLabelColor: Colors.black54,
            labelColor: HexColor(themeColor),
            indicatorColor: HexColor(themeColor),
            indicatorPadding: EdgeInsets.only(left: 10, right: 10),
            labelStyle: TextStyle(fontSize: 20),
            tabs: [
              Tab(
                  child: Container(
                width: itemWidth,
                alignment: Alignment.center,
                child: Text(
                  '所有作品',
                  style: TextStyle(fontSize: 18),
                ),
              )),
              Tab(
                  child: Container(
                width: itemWidth,
                alignment: Alignment.center,
                child: Text(
                  '已发布',
                  style: TextStyle(fontSize: 18),
                ),
              )),
            ]),
        Expanded(
            flex: 1,
            child: TabBarView(
              controller: tabController,
              children: [ArtWorkList(), PublishedList()],
            ))
      ]),
    );
  }
}
