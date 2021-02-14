import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorfly/component/singleToggleButton.dart';
import 'package:flutter_colorfly/config/ImageAssets.dart';
import 'package:flutter_colorfly/pages/painting/colorBar.dart';
import 'package:flutter_colorfly/pages/painting/paintingAppBar.dart';
import 'package:flutter_colorfly/pages/painting/painting_web.dart';

class Painting extends StatefulWidget {
  final Map arguments;
  Painting({Key key, this.arguments}) : super(key: key);

  @override
  _PaintingState createState() => _PaintingState();
}

class _PaintingState extends State<Painting> {
  String paintId;
  String svgId;
  String imgPath;
  bool loadEnded = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    paintId = widget.arguments['paintId'];
    svgId = widget.arguments['svgId'];
    imgPath = widget.arguments['imgPath'];
  }

  Widget createPlaceHolder() {
    if (loadEnded) {
      return Container();
    }
    if (imgPath.startsWith('builtin')) {
      return Hero(
          tag: svgId,
          child: Container(
            margin: EdgeInsets.only(top: 30),
            child: Image.asset(imgPath),
          ));
    } else {
      return Hero(
          tag: svgId,
          child: Container(
            margin: EdgeInsets.only(top: 30),
            child: Image.file(File(imgPath)),
          ));
    }
  }

  onLoadEnded() {
    setState(() {
      loadEnded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
          child: Container(
        color: Colors.grey[200],
        child: Column(
          children: [
            PaintingAppBar(),
            Expanded(
              child: Stack(
                children: [
                  PaintingWebView(
                    key: webviewKey,
                    paintId: paintId,
                    svgId: svgId,
                    imgPath: imgPath,
                    onloadEnded: () {
                      onLoadEnded();
                    },
                  ),
                  createPlaceHolder()
                ],
              ),
              flex: 1,
            ),
            ColorBar()
          ],
        ),
      )),
    );
  }
}
