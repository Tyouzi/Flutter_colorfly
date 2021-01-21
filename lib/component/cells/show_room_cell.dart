import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorfly/service/FetchClient.dart';

class ShowRoomCell extends StatefulWidget {
  String url = '';
  int index = 0;
  ShowRoomCell(this.url, this.index, {Key key}) : super(key: key);

  @override
  _ShowRoomCellState createState() => _ShowRoomCellState(url, index);
}

class _ShowRoomCellState extends State<ShowRoomCell> {
  String url;
  int index;
  _ShowRoomCellState(this.url, this.index);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(3),
      child: Image.network(FetchClient.ImgHost + url),
      // width: 50,
      // height: 50,
    );
  }
}
