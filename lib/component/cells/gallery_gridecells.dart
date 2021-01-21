import 'package:flutter/material.dart';
import 'package:flutter_colorfly/model/template_model.dart';

import 'package:flutter_colorfly/service/FetchClient.dart';

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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.only(top: 0),
      child: AspectRatio(
          // borderRadius: BorderRadius.circular(12),
          aspectRatio: 1,
          child: Container(
            // child:
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[50],
                image: DecorationImage(
                  image: NetworkImage(
                    getImgUrl(),
                  ),
                  fit: BoxFit.fill,
                )),
          )),
    );
  }
}
