import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    print(this.paintId);
    return Hero(
        tag: paintId,
        child: Container(
          width: 100,
          height: 100,
          padding: EdgeInsets.all(7),
          child: FlatButton(
            padding: EdgeInsets.zero,
            child: Container(
              child: Image.file(File(url)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
            ),
            onPressed: () {
              onPress(index);
            },
          ),
        ));
  }
}
