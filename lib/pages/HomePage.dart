import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorfly/component/gallery/gallery_grideview.dart';
import 'package:flutter_colorfly/config/gallery-tab.dart';
import 'package:flutter_colorfly/service/GalleryRequest.dart';
import 'package:flutter_colorfly/service/UserRequest.dart';
import 'package:flutter_colorfly/utils/HexColor.dart';
import 'package:flutter_colorfly/global.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() {
    // TODO: implement createState
    return HomePageState();
  }
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController tabController;
  int currentIndex = 0;
  List<Widget> swiperItems = <Widget>[
    Icon(Icons.adb),
    Icon(Icons.add_box),
    Icon(Icons.wrap_text)
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController =
        new TabController(length: GalleryTabNames.tabNames.length, vsync: this);
    SharedPreferences.getInstance().then((sp) {
      var token = sp.getString('token');
      if (token == null) {
        UserRequest.login();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;
    return new SafeArea(
        child: new Container(
            child: Column(
      children: <Widget>[
        Container(
          width: width,
          height: height / 4.5,
          color: Colors.cyan,
          child: new Swiper(
            itemCount: 3,
            autoplay: true,
            autoplayDelay: 2000,
            itemBuilder: (BuildContext context, int index) {
              return swiperItems[index];
            },
            pagination: new SwiperPagination(),
          ),
        ),
        TabBar(
            controller: tabController,
            isScrollable: true,
            unselectedLabelColor: Colors.grey,
            labelColor: HexColor(themeColor),
            indicatorColor: HexColor(themeColor),
            tabs: GalleryTabNames.tabNames
                .map((e) => Tab(
                        child: Text(
                      e,
                      style: TextStyle(fontSize: 20),
                    )))
                .toList()),
        Expanded(
          flex: 1,
          child: GalleryGride(tabController: tabController),
        )
      ],
    )));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
