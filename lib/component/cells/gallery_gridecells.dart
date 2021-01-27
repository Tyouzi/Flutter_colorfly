import 'package:flutter/material.dart';
import 'package:flutter_colorfly/config/routes.dart';
import 'package:flutter_colorfly/model/template_model.dart';

import 'package:flutter_colorfly/service/FetchClient.dart';
import 'package:flutter_colorfly/utils/DataBaseUtils.dart';

class GalleryCells extends StatefulWidget {
  final TemplateModel tem;
  GalleryCells({this.tem});

  @override
  State<StatefulWidget> createState() {
    return GalleryCellsState(this.tem);
  }
}

class GalleryCellsState extends State {
  final TemplateModel template;
  GalleryCellsState(this.template);

  String getImgUrl() {
    return FetchClient.ImgHost + template.thumbnailUrl;
  }

  void onPress() async {
    // await PaintDataBase.createPaint('basic_1-0-3');
    Navigator.of(context).pushNamed(Routes.painting,
        arguments: {"svgUrl": template.thumbnailUrl});
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.only(top: 0),
      child: AspectRatio(
          aspectRatio: 1,
          child: FlatButton(
            onPressed: this.onPress,
            padding: EdgeInsets.all(0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[50],
                  image: DecorationImage(
                    image: NetworkImage(
                      getImgUrl(),
                    ),
                    fit: BoxFit.fill,
                  )),
            ),
          )),
    );
  }
}
