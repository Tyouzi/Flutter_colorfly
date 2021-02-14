import 'package:flutter/cupertino.dart';
import 'package:flutter_colorfly/config/ImageAssets.dart';

enum ButtonType { normal, back, finish }

class CustomButton extends StatelessWidget {
  Function onTap;
  bool canCallBack = true;
  Widget child;
  ButtonType _buttonType = ButtonType.normal;
  Color color;
  double width;
  double height;

  CustomButton(
      {Key key,
      @required this.onTap,
      this.child,
      this.color,
      this.width,
      this.height})
      : super(key: key);

  handleTap() {
    if (canCallBack) {
      this.onTap();
      canCallBack = false;
      Future.delayed(Duration(milliseconds: 500), () {
        canCallBack = true;
      });
    }
  }

  CustomButton.back({Key key}) : _buttonType = ButtonType.back;
  CustomButton.finish({Key key, this.onTap}) : _buttonType = ButtonType.finish;
  @override
  Widget build(BuildContext context) {
    if (_buttonType == ButtonType.back) {
      return Container(
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.asset(ImgAssets.paintingBack),
        ),
      );
    }
    if (_buttonType == ButtonType.finish) {
      return Container(
        child: GestureDetector(
          onTap: this.handleTap,
          child: Image.asset(ImgAssets.paintingComplate),
        ),
      );
    }
    return Container(
      color: this.color,
      width: this.width,
      height: this.height,
      child: GestureDetector(
        onTap: this.handleTap,
        child: this.child,
      ),
    );
  }
}
