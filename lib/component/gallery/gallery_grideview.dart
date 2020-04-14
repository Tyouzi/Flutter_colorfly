import 'package:flutter/material.dart';
import 'package:flutter_demo/component/cells/gallery_gridecells.dart';
import 'package:flutter_demo/config/gallery-tab.dart';
import 'package:flutter_demo/model/template.dart';
import 'package:flutter_demo/service/GalleryRequest.dart';

class GalleryGride extends StatefulWidget{
 TabController tabController;
   GalleryGride({
     Key key,
     @required this.tabController,
  }): super(key:key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return GalleryGrideState(tabController: tabController);
  }

}
class GalleryGrideState extends State<GalleryGride>{
  TabController tabController;
  List templates= [];
  GalleryGrideState({
    @required this.tabController,
  });

  @override
  initState(){
    super.initState();
     GalleryRequest.getAllPaintings().then((paintings){
          // print(paintings);
          List<dynamic> templateList = paintings.data["data"];
          setState(() {
            templates=templateList;
          });
           
     });
  }

  Widget renderItem (context,index){
    return GalleryCells(tem: Template.map(templates[index]),);
  }
  
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
                        itemCount: templates.length, 
                        itemBuilder: renderItem),
                );
      }).toList(),
    );
  }
  
}