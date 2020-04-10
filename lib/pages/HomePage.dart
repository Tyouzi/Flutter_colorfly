import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/component/gallery_grideview.dart';
import 'package:flutter_demo/config/gallery-tab.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class HomePage extends StatefulWidget{
  @override
  State<HomePage> createState() {
    // TODO: implement createState
    return  HomePageState();
  }

}
class HomePageState extends State<HomePage>   with SingleTickerProviderStateMixin {

  TabController tabController;
  int currentIndex = 0;
  List<Widget> swiperItems = <Widget>[
    Icon(Icons.adb),Icon(Icons.add_box),Icon(Icons.wrap_text)
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = new TabController(length: GalleryTabNames.tabNames.length, vsync: this);
    tabController.addListener((){
      // this.setState((){
      //   currentIndex = tabController.index;
      // });
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
          child:Column(
            children: <Widget>[
              Container(
                width: width,
                height: height/4.5,
                color: Colors.cyan,
                child: new Swiper(
                  itemCount: 3,
                  autoplay: true,
                  autoplayDelay: 2000,
                  itemBuilder: (BuildContext context,int index){
                    return swiperItems[index];
                  },
                  pagination: new SwiperPagination(),
                  
                  ),
              ),
              TabBar(
                      controller: tabController,
                      isScrollable: true,
                      unselectedLabelColor:Colors.deepOrange,
                      labelColor: Colors.blueGrey,
                      indicatorColor: Colors.orange,
                      tabs:GalleryTabNames.tabNames.map((e) => 
                       Tab(child: Text(e,style:TextStyle(fontSize: 20),))
                      ).toList()),
              Expanded(
                      flex: 1,
                      child: GalleryGride(tabController: tabController),
                      )
            ],
            )
        )
    );
  }

}