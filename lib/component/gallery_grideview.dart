import 'package:flutter/material.dart';
import 'package:flutter_demo/component/cells/gallery_gridecells.dart';
import 'package:flutter_demo/config/gallery-tab.dart';

class GalleryGride extends StatefulWidget{
 TabController tabController;
   GalleryGride({
     Key key,
     @required this.tabController
  }): super(key:key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return GalleryGrideState(tabController: tabController);
  }

}
class GalleryGrideState extends State<GalleryGride>{
  TabController tabController;
  GalleryGrideState({
    @required this.tabController
  });
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return TabBarView(
        controller: tabController,
        children: GalleryTabNames.tabNames.map((e){
                return Container(
                  color: Colors.grey,
                  child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisSpacing: 0,childAspectRatio: 1.1),
                        itemCount: 10, 
                        itemBuilder: (contex,index){
                          return GalleryCells();
                        }),
                );
      }).toList(),
    );
  }
  
}