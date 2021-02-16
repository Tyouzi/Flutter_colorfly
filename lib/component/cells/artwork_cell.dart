import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorfly/component/customButton.dart';

class ArtWorkCell extends StatelessWidget {
  Function onPress;
  String url;
  int index;
  String paintId;
  ArtWorkCell({Key key, this.onPress, this.url, this.index, this.paintId})
      : super(key: key);

  @override
  StatelessElement createElement() {
    // TODO: implement createElement
    return super.createElement();
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: paintId,
        child: Container(
          width: 100,
          height: 100,
          padding: EdgeInsets.all(7),
          child: CustomButton(
            child: Container(
              child: Image.file(File(url)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
            ),
            onTap: () => onPress(index),
          ),
        ));
  }
}
