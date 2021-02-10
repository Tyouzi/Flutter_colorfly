import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorfly/component/cells/artwork_cell.dart';
import 'package:flutter_colorfly/config/event_names.dart';
import 'package:flutter_colorfly/utils/DataBaseUtils.dart';
import 'package:flutter_colorfly/utils/DialogPageRoute.dart';
import 'package:flutter_colorfly/utils/PaintHandler.dart';
import 'package:sembast/sembast.dart';

import '../../global.dart';
import '../gallery_dialog.dart';

class ArtWorkList extends StatefulWidget {
  ArtWorkList({Key key}) : super(key: key);

  @override
  _ArtWorkListState createState() => _ArtWorkListState();
}

class _ArtWorkListState extends State<ArtWorkList> {
  List<RecordSnapshot> records = [];
  Widget itemBuilder(BuildContext context, int index) {
    return ArtWorkCell(
        paintId: records[index]['paintId'],
        onPress: (index) {
          String url = records[index]['paintPath'];
          String svgId = records[index]['svgId'];
          String paintId = records[index]['paintId'];
          this.onItemPress(url, svgId, paintId);
        },
        url: records[index]['paintPath'],
        index: index);
  }

  onItemPress(String url, String svgId, String paintId) {
    Navigator.push(
        context,
        HeroDialogRoute(
            builder: (context) => GalleryDialog(
                  svgId: paintId,
                  imgSrc: url,
                  type: 'profile',
                  onNewPress: () {
                    Navigator.pop(context);
                    PaintHandler.createNewPaint(context, svgId);
                  },
                  continuePress: () {
                    Navigator.pop(context);
                    PaintHandler.continuePress(context, paintId, svgId);
                  },
                  onDeletePress: () async {
                    int totalNum = 0;
                    for (RecordSnapshot record in records) {
                      if (record['svgId'] == svgId) {
                        totalNum++;
                      }
                    }
                    print(totalNum);
                    if (totalNum == 1) {
                      await TemplateDataBase.updateTemplate(svgId, '/static');
                    }
                    await PaintHandler.deletePaint(svgId, paintId);
                    Navigator.pop(context);
                    await initData();
                  },
                )));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initData();
    bus.on(EventNames.cellPathUpdate, (arg) {
      initData();
    });
  }

  initData() async {
    List<RecordSnapshot> records = await PaintDataBase.readPaintRecord();
    setState(() {
      this.records = records;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.builder(
        itemBuilder: this.itemBuilder,
        itemCount: records.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 1,
          crossAxisCount: 2,
        ),
      ),
    );
  }
}
