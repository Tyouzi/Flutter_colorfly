import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_colorfly/config/event_names.dart';
import 'package:flutter_colorfly/config/routes.dart';
import 'package:flutter_colorfly/config/share-preference-tags.dart';
import 'package:flutter_colorfly/global.dart';
import 'package:flutter_colorfly/pages/Creaction.dart';
import 'package:flutter_colorfly/utils/DataBaseUtils.dart';
import 'package:flutter_colorfly/utils/HexColor.dart';
import 'package:flutter_colorfly/utils/sembast_db.dart';
import 'package:flutter_colorfly/service/FetchClient.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/gallery-tab.dart';
import 'model/template_model.dart';
import 'pages/Active.dart';
import 'pages/HomePage.dart';
import 'pages/Profile.dart';
import 'pages/ShowRoom.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    FetchClient.createInstance();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // routes: Routes.configureRoutes(context),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
      builder: EasyLoading.init(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentIndex = 0;
  PageController _pageController = new PageController(initialPage: 0);
  void onTabPress(index) {
    _pageController.jumpToPage(index);
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initData();
    bus.on(EventNames.changeBottomBar, (arg) {
      _pageController.jumpToPage(3);
      setState(() {
        currentIndex = 3;
      });
    });
  }

  initData() async {
    await SemDataBase.initDataBase();
    SharedPreferences sp = await SharedPreferences.getInstance();
    int launchTimes = sp.getInt(SharePreferenceTags.launchTimes) ?? 0;
    if (launchTimes == 0) {
      await loadTemplateData();

      bus.emit(EventNames.dbStatus);
    }
    sp.setInt(SharePreferenceTags.launchTimes, ++launchTimes);
  }

  customEasyLoading() {
    EasyLoading.instance
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.light
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..progressColor = Colors.yellow
      ..backgroundColor = Colors.green
      ..indicatorColor = Colors.yellow
      ..textColor = Colors.yellow
      ..maskColor = Colors.blue.withOpacity(0.5)
      ..userInteractions = true
      ..dismissOnTap = false;
  }

  loadTemplateData() async {
    String value = await DefaultAssetBundle.of(context)
        .loadString('builtin/templates1.json');

    List templateList = JsonDecoder().convert(value.toString());

    for (var i in templateList) {
      TemplateModel tem = TemplateModel.fromJson(i);
      await TemplateDataBase.saveTemplate(tem);
    }
  }

  @override
  Widget build(BuildContext context) {
    var children = [
      new HomePage(),
      new ShowRoom(),
      new Creaction(),
      new Profile()
    ];

    return Scaffold(
      body: PageView(
        children: children,
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: new Image.asset(
              currentIndex == 0
                  ? 'images/tabbar/biretta.png'
                  : 'images/tabbar/acclimatising.png',
              width: 25,
              height: 25,
            ),
            label: "主页",
          ),
          BottomNavigationBarItem(
            icon: new Image.asset(
              currentIndex == 1
                  ? 'images/tabbar/bulbul.png'
                  : 'images/tabbar/amylene.png',
              width: 25,
              height: 25,
            ),
            label: '画廊',
          ),
          BottomNavigationBarItem(
            icon: new Image.asset(
              currentIndex == 2
                  ? 'images/tabbar/baldheads.png'
                  : 'images/tabbar/brushiest.png',
              width: 25,
              height: 25,
            ),
            label: 'Creation',
          ),
          // BottomNavigationBarItem(
          //   icon: new Image.asset(
          //     currentIndex == 3
          //         ? 'images/tabbar/acidimetric.png'
          //         : 'images/tabbar/asseverates.png',
          //     width: 25,
          //     height: 25,
          //   ),
          //   label: '消息',
          // ),
          BottomNavigationBarItem(
            icon: new Image.asset(
              currentIndex == 3
                  ? 'images/tabbar/applets.png'
                  : 'images/tabbar/biocomputing.png',
              width: 25,
              height: 25,
            ),
            label: '个人',
          )
        ],
        selectedItemColor: HexColor(themeColor),
        currentIndex: currentIndex,
        onTap: onTabPress,
      ),
    );
  }
}
