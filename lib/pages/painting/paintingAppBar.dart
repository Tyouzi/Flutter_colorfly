import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorfly/component/singleToggleButton.dart';
import 'package:flutter_colorfly/config/ImageAssets.dart';
import 'package:flutter_colorfly/pages/painting/painting_web.dart';

class PaintingAppBar extends StatefulWidget {
  PaintingAppBar({Key key}) : super(key: key);

  @override
  _PaintingAppBarState createState() => _PaintingAppBarState();
}

class _PaintingAppBarState extends State<PaintingAppBar>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation _backanimation;
  Animation _centeranimation;
  Animation _nextanimation;
  void onPressBack() {
    webviewKey.currentState.onPopClick();
  }

  onFinishClick() {
    webviewKey.currentState.onFinishClick();
  }

  onLockButtonClick() {
    webviewKey.currentState.onLockClick();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
        duration: Duration(milliseconds: 1200), vsync: this);
    _backanimation = Tween(begin: -50.0, end: 0.0).animate(CurvedAnimation(
        parent: controller, curve: Interval(0.0, 0.4, curve: Curves.linear)));
    _centeranimation = Tween(begin: -50.0, end: 0.0).animate(CurvedAnimation(
        parent: controller, curve: Interval(0.4, 0.7, curve: Curves.linear)));
    _nextanimation = Tween(begin: -50.0, end: 0.0).animate(CurvedAnimation(
        parent: controller, curve: Interval(0.7, 1.0, curve: Curves.linear)));
    controller.forward();
  }

  @override
  void didUpdateWidget(covariant PaintingAppBar oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Container(
            color: Colors.white,
            height: 50,
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Transform.translate(
                  offset: Offset(0, _backanimation.value),
                  child: Container(
                    height: 25,
                    width: 25,
                    child: GestureDetector(
                        onTap: this.onPressBack,
                        child: Image(
                            width: 25,
                            height: 25,
                            image: AssetImage(
                              ImgAssets.paintingBack,
                            ))),
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: Transform.translate(
                      offset: Offset(0, _centeranimation.value),
                      child: SingleToggleButton(
                          onPress: (value) {
                            this.onLockButtonClick();
                          },
                          sourceOn: ImgAssets.paintingContinue_black_on,
                          sourceOff: ImgAssets.paintingContinue_off),
                    )),
                Transform.translate(
                  offset: Offset(0, _nextanimation.value),
                  child: GestureDetector(
                      onTap: this.onFinishClick,
                      child: Image(
                          width: 25,
                          height: 25,
                          image: AssetImage(
                            ImgAssets.paintingComplate,
                          ))),
                ),
              ],
            ),
          );
        });
  }
}
