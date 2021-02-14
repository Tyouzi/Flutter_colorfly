import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorfly/component/customButton.dart';
import 'package:flutter_colorfly/component/gallery_dialog.dart';
import 'package:flutter_colorfly/config/event_names.dart';
import 'package:flutter_colorfly/config/routes.dart';
import 'package:flutter_colorfly/global.dart';
import 'package:flutter_colorfly/model/template_model.dart';

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
    String path = getImgPath();
    if (path.startsWith('builtin')) {
      return AssetImage(path);
    } else {
      return FileImage(File(path));
    }
  }

  String getImgPath() {
    if (imgPath != null) {
      return imgPath;
    }
    if (!template.thumbnailUrl.startsWith('/static')) {
      return template.thumbnailUrl;
    } else {
      return 'builtin/thumb/${template.id}.png';
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
                child: CustomButton(
                  onTap: () {
                    this.onPress(template.id, getImgPath());
                  },
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
