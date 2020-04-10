import 'package:flutter/material.dart';
import 'package:flutter_demo/pages/Creaction.dart';

import 'pages/Active.dart';
import 'pages/HomePage.dart';
import 'pages/Profile.dart';
import 'pages/ShowRoom.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentIndex = 0;

  void onTabPress(index){
    setState((){
      currentIndex=index;
    });
  }
  @override
  Widget build(BuildContext context) {

    var children =[new HomePage(),new ShowRoom(),new Creaction(),new Active(),new Profile()];

    return Scaffold(
      body:children[currentIndex],
      bottomNavigationBar:  BottomNavigationBar(
          items:  <BottomNavigationBarItem> [
            BottomNavigationBarItem(
              icon: new Image.asset(currentIndex==0? 'images/tabbar/biretta@3x.png':'images/tabbar/acclimatising@3x.png',width: 25,height: 25,),
              title: Text('主页',style: TextStyle(fontWeight: FontWeight.bold),),
            ),
            BottomNavigationBarItem(
              icon: new Image.asset(currentIndex==1? 'images/tabbar/bulbul@3x.png':'images/tabbar/amylene@3x.png',width: 25,height: 25,),
              title: Text('画廊'),
            ),
            BottomNavigationBarItem(
              icon:  new Image.asset(currentIndex==2? 'images/tabbar/baldheads@3x.png':'images/tabbar/brushiest@3x.png',width: 25,height: 25,),
              title: Text('Creation'),
            ),
            BottomNavigationBarItem(
              icon: new Image.asset(currentIndex==3? 'images/tabbar/acidimetric@3x.png':'images/tabbar/asseverates@3x.png',width: 25,height: 25,),
              title: Text('消息'),
            ),
            BottomNavigationBarItem(
              icon: new Image.asset(currentIndex==4? 'images/tabbar/applets@3x.png':'images/tabbar/biocomputing@3x.png',width: 25,height: 25,),
              title: Text('个人'),
            )
          ],
          selectedItemColor: Colors.amber,
          currentIndex: currentIndex,
          
          onTap: onTabPress,

      ),
    );
  }
}
