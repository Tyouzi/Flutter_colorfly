import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorfly/component/customButton.dart';
import 'package:flutter_colorfly/service/FetchClient.dart';

class ShowRoomCell extends StatefulWidget {
  String url = '';
  int index = 0;
  Function onPress;
  ShowRoomCell(this.url, this.index, {Key key, this.onPress}) : super(key: key);

  @override
  _ShowRoomCellState createState() => _ShowRoomCellState(url, index, onPress);
}

class _ShowRoomCellState extends State<ShowRoomCell> {
  String url;
  int index;
  Function onPress;
  _ShowRoomCellState(this.url, this.index, this.onPress);

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(3),
      child: CustomButton(
          onTap: () {
            this.onPress(index);
          },
          child: Hero(
            tag: url,
            child: Image.network(
              FetchClient.ImgHost + url,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  child: Text('出错了！'),
                );
              },
            ),
          )),
    );
  }
}
