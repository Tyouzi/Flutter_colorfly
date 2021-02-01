import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorfly/component/gallery/gallery_grideview.dart';
import 'package:flutter_colorfly/component/gallery/sliverPersistentTabBar.dart';
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

  List<String> swipButtonUrls = [
    'images/tabbar/alkalies.jpg',
    'images/tabbar/arblast.jpg',
    'images/tabbar/brassards.jpg',
    'images/tabbar/carcinomatoses.png'
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

  List<Widget> renderHeader() {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;
    return [
      SliverAppBar(
        expandedHeight: height / 4.5,
        flexibleSpace: Swiper(
          itemCount: 4,
          autoplay: true,
          autoplayDelay: 5000,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              child: Image.asset(swipButtonUrls[index], fit: BoxFit.cover),
              width: width,
              height: height / 4.5,
            );
          },
          pagination: SwiperPagination(),
        ),
      ),
      SliverPersistentHeader(
          pinned: true,
          delegate: SliverPersistentTabBar(
              child: TabBar(
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
                      .toList())))
    ];
  }

  Widget renderBody() {
    return GalleryGride(tabController: tabController);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return new SafeArea(
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool isscrolled) {
          return renderHeader();
        },
        body: renderBody(),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
