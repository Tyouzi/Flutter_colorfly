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
import 'package:flutter_colorfly/provider_models/gallery_model.dart';
import 'package:flutter_colorfly/service/GalleryRequest.dart';
import 'package:flutter_colorfly/utils/DataBaseUtils.dart';
import 'package:flutter_colorfly/utils/DialogPageRoute.dart';
import 'package:flutter_colorfly/utils/paintHandler.dart';
import 'package:provider/provider.dart';
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
  // Map<String, List> data = new HashMap();
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
    if (records.length == 0) return;
    Map<String, List<TemplateModel>> dataMap = {};
    for (RecordSnapshot record in records) {
      String svgId = record.value['svgId'];
      String url = record.value['url'];
      String thumbUrl = record.value['thumbUrl'];
      String mainTag = record.value['mainTag'];
      TemplateModel tem = new TemplateModel(
          id: svgId, url: url, thumbnailUrl: thumbUrl, mainTag: mainTag);
      if (!dataMap.containsKey(tem.mainTag)) {
        dataMap[tem.mainTag] = [];
      }
      dataMap[tem.mainTag].add(tem);
    }
    Provider.of<GalleryModels>(context, listen: false)
        .loadGalleryDatas(dataMap);
  }

  void onPress(String svgId) async {
    List<RecordSnapshot> records = await PaintDataBase.readPaint(svgId);
    if (records.length > 0) {
      RecordSnapshot lastRecord = records[records.length - 1];
      String paintId = lastRecord['paintId'];
      String thumbnailUrl = lastRecord['paintPath'];
      Navigator.push(
          context,
          HeroDialogRoute(
            builder: (context) => GalleryDialog(
              svgId: svgId,
              imgSrc: thumbnailUrl,
              onNewPress: () {
                Navigator.pop(context);
                PaintHandler.createNewPaint(context, svgId);
              },
              continuePress: () {
                Navigator.pop(context);
                PaintHandler.continuePress(
                    context, paintId, svgId, thumbnailUrl);
              },
            ),
          ));
    } else {
      PaintHandler.createNewPaint(context, svgId);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Consumer<GalleryModels>(
      builder: (context, value, child) {
        return TabBarView(
          controller: tabController,
          children: GalleryTabNames.tabNames.map((e) {
            List singleTemplateList = value.galleryData[e] ?? [];
            return Container(
              color: Colors.grey[200],
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 0,
                      childAspectRatio: 1.1),
                  itemCount: singleTemplateList.length,
                  itemBuilder: (context, index) {
                    return Selector<GalleryModels, TemplateModel>(
                      builder: (context, value, child) {
                        return GalleryCells(
                            tem: value,
                            onPress: (String svgId, String imgPath) {
                              onPress(svgId);
                            });
                      },
                      shouldRebuild: (previous, next) =>
                          previous.thumbnailUrl != next.thumbnailUrl,
                      selector: (context, models) => singleTemplateList[index],
                    );
                  }),
            );
          }).toList(),
        );
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
