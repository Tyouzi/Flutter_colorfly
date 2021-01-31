import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorfly/component/cells/gallery_gridecells.dart';
import 'package:flutter_colorfly/config/event_names.dart';
import 'package:flutter_colorfly/config/gallery-tab.dart';
import 'package:flutter_colorfly/global.dart';
import 'package:flutter_colorfly/model/template_model.dart';
import 'package:flutter_colorfly/pages/painting/painting.dart';
import 'package:flutter_colorfly/service/GalleryRequest.dart';
import 'package:flutter_colorfly/utils/DataBaseUtils.dart';
import 'package:flutter_colorfly/utils/paintHandler.dart';
import 'package:sembast/sembast.dart';

import '../gallery_dialog.dart';

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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    bus.off(EventNames.dbStatus);
  }

  @override
  initState() {
    super.initState();

    bus.on(EventNames.dbStatus, (arg) {
      loadDataFromDB();
    });
  }

  loadDataFromDB() async {
    List<RecordSnapshot> records = await TemplateDataBase.readTemplate();
    print('db Status ${records.length}');
    if (records.length == 0) return;
    Map<String, List> dataMap = createDataMap();
    for (RecordSnapshot record in records) {
      String svgId = record.value['svgId'];
      String url = record.value['url'];
      String thumbUrl = record.value['thumbUrl'];
      String mainTag = record.value['mainTag'];
      TemplateModel tem = new TemplateModel(
          id: svgId, url: url, thumbnailUrl: thumbUrl, mainTag: mainTag);
      if (dataMap.containsKey(tem.mainTag)) {
        dataMap[tem.mainTag].add(tem);
      }
    }
    setState(() {
      dataMap = dataMap;
    });
  }

  Map<String, List> createDataMap() {
    GalleryTabNames.tabNames.forEach((element) {
      data[element] = [];
    });

    return data;
  }

  void onPress(String svgId) async {
    List<RecordSnapshot> records = await PaintDataBase.readPaint(svgId);
    if (records.length > 0) {
      RecordSnapshot lastRecord = records[records.length - 1];
      String paintId = lastRecord['paintId'];
      String thumbnailUrl = lastRecord['paintPath'];
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => GalleryDialog(
                imgSrc: thumbnailUrl,
                onNewPress: () {
                  Navigator.pop(context);
                  PaintHandler.createNewPaint(context, svgId);
                },
                continuePress: () {
                  Navigator.pop(context);
                  PaintHandler.continuePress(context, paintId, svgId);
                },
              ));
    } else {
      PaintHandler.createNewPaint(context, svgId);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return TabBarView(
      controller: tabController,
      children: GalleryTabNames.tabNames.map((e) {
        List singleTemplateList = data[e] ?? [];
        return Container(
          color: Colors.grey[200],
          child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing: 0, childAspectRatio: 1.1),
              itemCount: singleTemplateList.length,
              itemBuilder: (context, index) {
                return GalleryCells(
                    tem: singleTemplateList[index],
                    onPress: (svgId) {
                      onPress(svgId);
                    });
              }),
        );
      }).toList(),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
