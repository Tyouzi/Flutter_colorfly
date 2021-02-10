import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StaggerAnimation extends StatelessWidget {
  AnimationController controller;
  Animation<double> height;
  Animation color;
  Animation<double> padding;
  StaggerAnimation({Key key, this.controller}) : super(key: key) {
    height = Tween(begin: 10.0, end: 100.0).animate(controller);
    color =
        ColorTween(begin: Colors.white, end: Colors.black).animate(controller);
    padding = Tween(begin: 0.0, end: 100.0).animate(controller);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Container(
            width: 100,
            padding: EdgeInsets.only(left: padding.value),
            height: height.value,
            color: color.value,
          );
        });
  }
}
