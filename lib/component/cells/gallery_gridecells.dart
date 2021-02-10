import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorfly/component/gallery_dialog.dart';
import 'package:flutter_colorfly/config/event_names.dart';
import 'package:flutter_colorfly/config/routes.dart';
import 'package:flutter_colorfly/global.dart';
import 'package:flutter_colorfly/model/template_model.dart';
import 'package:flutter_colorfly/pages/painting/painting.dart';

import 'package:flutter_colorfly/service/FetchClient.dart';
import 'package:flutter_colorfly/utils/DataBaseUtils.dart';
import 'package:sembast/sembast.dart';

class GalleryCells extends StatefulWidget {
  final TemplateModel tem;
  Function onPress;
  GalleryCells({this.tem, this.onPress});

  @override
  State<StatefulWidget> createState() {
    return GalleryCellsState(this.tem, this.onPress);
  }
}

class GalleryCellsState extends State {
  final TemplateModel template;
  Function onPress;
  GalleryCellsState(this.template, this.onPress);
  String imgPath;
  ImageProvider getImg() {
    if (imgPath != null) {
      return FileImage(File(imgPath));
    }
    if (!template.thumbnailUrl.startsWith('/static')) {
      return FileImage(File(template.thumbnailUrl));
    } else {
      return AssetImage('builtin/thumb/${template.id}.png');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bus.on(EventNames.cellPathUpdate, (arg) {
      String svgId = arg['svgId'];
      String imgPath = arg['thumbUrl'];
      if (svgId == template.id) {
        setState(() {
          this.imgPath = imgPath;
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    bus.off(
      EventNames.cellPathUpdate,
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // print(template.);
    return Container(
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.only(top: 0),
        child: Hero(
            tag: template.id,
            child: AspectRatio(
                aspectRatio: 1,
                child: FlatButton(
                  onPressed: () {
                    this.onPress(template.id);
                  },
                  padding: EdgeInsets.all(0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[50],
                        image: DecorationImage(
                          image: getImg(),
                          fit: BoxFit.fill,
                        )),
                  ),
                ))));
  }
}
