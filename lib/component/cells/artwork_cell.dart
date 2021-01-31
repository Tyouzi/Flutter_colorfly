import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ArtWorkCell extends StatelessWidget {
  Function onPress;
  String url;
  int index;
  ArtWorkCell({Key key, this.onPress, this.url, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      padding: EdgeInsets.all(7),
      child: FlatButton(
        padding: EdgeInsets.zero,
        child: Container(
          child: Image.asset(url),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
        ),
        onPressed: () {
          onPress(index);
        },
      ),
    );
  }
}
