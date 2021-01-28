import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ArtWorkCell extends StatelessWidget {
  Function onPress;
  ArtWorkCell({Key key, this.onPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      padding: EdgeInsets.all(7),
      child: FlatButton(
        padding: EdgeInsets.zero,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.blue,
          ),
        ),
        onPressed: onPress,
      ),
    );
  }
}
