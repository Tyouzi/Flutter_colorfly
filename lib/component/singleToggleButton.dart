import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SingleToggleButton extends StatefulWidget {
  bool initState = false;
  String sourceOn = '';
  String sourceOff = '';
  double imgWidth = 25;
  Function onPress;
  SingleToggleButton({
    Key key,
    this.initState,
    this.imgWidth,
    this.onPress,
    @required this.sourceOn,
    @required this.sourceOff,
  }) : super(key: key);

  @override
  _SingleToggleButtonState createState() => _SingleToggleButtonState();
}

class _SingleToggleButtonState extends State<SingleToggleButton> {
  bool isOn = false;
  // String sourceOn = '';
  // String sourceOff = '';
  // double imgWidth = 25;
  void onPress() {
    setState(() {
      isOn = !this.isOn;
    });
    widget.onPress(isOn);
  }

  Widget imgShow() {
    if (isOn) {
      return Image(
        image: AssetImage(widget.sourceOn),
        width: widget.imgWidth,
      );
    } else {
      return Image(
        image: AssetImage(widget.sourceOff),
        width: widget.imgWidth,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onPressed: this.onPress,
      child: imgShow(),
    );
  }
}
