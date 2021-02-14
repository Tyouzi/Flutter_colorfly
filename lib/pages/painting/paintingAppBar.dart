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

class _PaintingAppBarState extends State<PaintingAppBar> {
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
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        color: Colors.white,
        height: 50,
        padding: EdgeInsets.only(left: 15, right: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
                onTap: this.onPressBack,
                child: Image(
                    width: 25,
                    height: 25,
                    image: AssetImage(
                      ImgAssets.paintingBack,
                    ))),
            Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  child: SingleToggleButton(
                      onPress: (value) {
                        this.onLockButtonClick();
                      },
                      sourceOn: ImgAssets.paintingContinue_black_on,
                      sourceOff: ImgAssets.paintingContinue_off),
                )),
            GestureDetector(
                onTap: this.onFinishClick,
                child: Image(
                    width: 25,
                    height: 25,
                    image: AssetImage(
                      ImgAssets.paintingComplate,
                    ))),
          ],
        ),
      ),
    );
  }
}
