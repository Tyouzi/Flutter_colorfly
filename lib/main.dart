import 'package:flutter/material.dart';
import 'package:flutter_colorfly/pages/Creaction.dart';
import 'package:flutter_colorfly/service/FetchClient.dart';

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
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
  Widget build(BuildContext context) {
    var children = [
      new HomePage(),
      new ShowRoom(),
      new Creaction(),
      new Active(),
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
                  ? 'images/tabbar/biretta@3x.png'
                  : 'images/tabbar/acclimatising@3x.png',
              width: 25,
              height: 25,
            ),
            label: "主页",
          ),
          BottomNavigationBarItem(
            icon: new Image.asset(
              currentIndex == 1
                  ? 'images/tabbar/bulbul@3x.png'
                  : 'images/tabbar/amylene@3x.png',
              width: 25,
              height: 25,
            ),
            label: '画廊',
          ),
          BottomNavigationBarItem(
            icon: new Image.asset(
              currentIndex == 2
                  ? 'images/tabbar/baldheads@3x.png'
                  : 'images/tabbar/brushiest@3x.png',
              width: 25,
              height: 25,
            ),
            label: 'Creation',
          ),
          BottomNavigationBarItem(
            icon: new Image.asset(
              currentIndex == 3
                  ? 'images/tabbar/acidimetric@3x.png'
                  : 'images/tabbar/asseverates@3x.png',
              width: 25,
              height: 25,
            ),
            label: '消息',
          ),
          BottomNavigationBarItem(
            icon: new Image.asset(
              currentIndex == 4
                  ? 'images/tabbar/applets@3x.png'
                  : 'images/tabbar/biocomputing@3x.png',
              width: 25,
              height: 25,
            ),
            label: '个人',
          )
        ],
        selectedItemColor: Colors.amber,
        currentIndex: currentIndex,
        onTap: onTabPress,
      ),
    );
  }
}
