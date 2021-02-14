import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'customButton.dart';

class CustomAlertDialog extends StatelessWidget {
  String title;
  Function onActionTap;
  CustomAlertDialog({Key key, this.title, this.onActionTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        child: Text(title, style: TextStyle(fontSize: 18)),
      ),
      actionsPadding: EdgeInsets.all(20),
      actions: [
        CustomButton(
            onTap: () {
              this.onActionTap();
            },
            child: Container(
              margin: EdgeInsets.only(right: 20),
              child: Text(
                '确定',
                style: TextStyle(fontSize: 15),
              ),
            )),
        CustomButton(
          onTap: () {
            Navigator.pop(context);
          },
          child: Text(
            '取消',
            style: TextStyle(fontSize: 15),
          ),
        ),
      ],
    );
  }
}
