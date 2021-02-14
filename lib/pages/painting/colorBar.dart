import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorfly/component/cells/painting_cell.dart';
import 'package:flutter_colorfly/config/palettes.dart';

import '../../global.dart';

class ColorBar extends StatefulWidget {
  ColorBar({Key key}) : super(key: key);

  @override
  _ColorBarState createState() => _ColorBarState();
}

class _ColorBarState extends State<ColorBar>
    with SingleTickerProviderStateMixin {
  List<Color> colors_row1 = [];
  List<Color> colors_row2 = [];
  Animation animation;
  AnimationController controller;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    List<Color> colors = Palettes.theme_macaron();
    colors_row1.addAll(colors.sublist(0, 6));
    colors_row2.addAll(colors.sublist(6, colors.length));
    print(screenHeight);
    controller =
        AnimationController(duration: Duration(milliseconds: 600), vsync: this);
    animation = Tween(begin: screenHeight / 4, end: 0.0).animate(controller);
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, animation.value),
            child: Container(
              color: Colors.white,
              height: height / 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: colors_row1.map((e) => ColorCell(e)).toList(),
                    ),
                  ),
                  Container(
                    width: width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: colors_row2.map((e) => ColorCell(e)).toList(),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
