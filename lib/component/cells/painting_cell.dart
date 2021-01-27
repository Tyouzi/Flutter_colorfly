import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorfly/config/event_names.dart';
import 'package:flutter_colorfly/global.dart';

class ColorCell extends StatefulWidget {
  Color _color;
  bool _isSelected;
  ColorCell(this._color);

  @override
  _ColorCellState createState() => _ColorCellState();
}

class _ColorCellState extends State<ColorCell> {
  bool isSelected = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bus.on(EventNames.colorCell, (arg) {
      if (widget._color.toString() == arg) {
        setState(() {
          isSelected = true;
        });
      } else if (isSelected && widget._color.toString() != arg) {
        setState(() {
          isSelected = false;
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    bus.off(EventNames.colorCell);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.11;
    return FlatButton(
        onPressed: onPressed,
        padding: EdgeInsets.all(0),
        minWidth: 0,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        child: Container(
          width: width,
          height: width,
          margin: EdgeInsets.all(2),
          alignment: Alignment.center,
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: widget._color),
          child: selectedWidget(),
        ));
  }

  Widget selectedWidget() {
    return isSelected
        ? Container(
            width: 10,
            height: 10,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.white),
          )
        : Container();
  }

  void onPressed() {
    if (isSelected) return;
    print(widget._color.toString());
    bus.emit(EventNames.colorCell, widget._color.toString());
    // print(_color.value);
  }
}
