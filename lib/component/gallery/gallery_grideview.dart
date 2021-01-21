import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorfly/component/cells/gallery_gridecells.dart';
import 'package:flutter_colorfly/config/gallery-tab.dart';
import 'package:flutter_colorfly/model/template_model.dart';
import 'package:flutter_colorfly/service/GalleryRequest.dart';

class GalleryGride extends StatefulWidget {
  TabController tabController;
  GalleryGride({
    Key key,
    @required this.tabController,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return GalleryGrideState(tabController: tabController);
  }
}

class GalleryGrideState extends State<GalleryGride>
    with AutomaticKeepAliveClientMixin {
  TabController tabController;
  Map<String, List> data = new HashMap();
  GalleryGrideState({
    @required this.tabController,
  });

  Map<String, List> createDataMap() {
    GalleryTabNames.tabNames.forEach((element) {
      data[element] = [];
    });

    return data;
  }

  @override
  initState() {
    super.initState();
    Map<String, List> dataMap = createDataMap();
    DefaultAssetBundle.of(context)
        .loadString('builtin/templates.json')
        .then((value) {
      List templateList = JsonDecoder().convert(value.toString());

      for (var i in templateList) {
        TemplateModel tem = TemplateModel.fromJson(i);
        if (dataMap.containsKey(tem.mainTag)) {
          dataMap[tem.mainTag].add(tem);
        }
      }
      setState(() {
        dataMap = dataMap;
      });
    });

    //  GalleryRequest.getAllPaintings().then((paintings){
    //       // print(paintings);
    //       List<dynamic> templateList = paintings.data["data"];
    //       print(templateList[0]);
    //       setState(() {
    //         templates=templateList;
    //       });

    //  });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return TabBarView(
      controller: tabController,
      children: GalleryTabNames.tabNames.map((e) {
        // print(e);
        List singleTemplateList = data[e];
        return Container(
          color: Colors.grey[200],
          child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing: 0, childAspectRatio: 1.1),
              itemCount: singleTemplateList.length,
              itemBuilder: (context, index) {
                return GalleryCells(
                  tem: singleTemplateList[index],
                );
              }),
        );
      }).toList(),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
