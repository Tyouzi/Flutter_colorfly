import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorfly/component/singleToggleButton.dart';
import 'package:flutter_colorfly/config/ImageAssets.dart';
import 'package:flutter_colorfly/pages/painting/colorBar.dart';
import 'package:flutter_colorfly/pages/painting/paintingAppBar.dart';
import 'package:flutter_colorfly/pages/painting/painting_web.dart';

class Painting extends StatefulWidget {
  Painting({Key key}) : super(key: key);

  @override
  _PaintingState createState() => _PaintingState();
}

class _PaintingState extends State<Painting> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
              child: PaintingWebView(
                key: webviewKey,
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
