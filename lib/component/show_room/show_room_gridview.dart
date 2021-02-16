import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorfly/component/cells/show_room_cell.dart';
import 'package:flutter_colorfly/config/event_names.dart';
import 'package:flutter_colorfly/global.dart';
import 'package:flutter_colorfly/pages/showroom/showroom_detail.dart';
import 'package:flutter_colorfly/service/FetchClient.dart';
import 'package:flutter_colorfly/service/ShowRoomRequest.dart';
import 'package:flutter_colorfly/utils/HexColor.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ShowRoomGridView extends StatefulWidget {
  String title;
  ShowRoomGridView(this.title, {Key key}) : super(key: key);

  @override
  _ShowRoomGridViewState createState() => _ShowRoomGridViewState(title);
}

class _ShowRoomGridViewState extends State<ShowRoomGridView>
    with AutomaticKeepAliveClientMixin {
  // ScrollController _scrollController;
  RefreshController _refreshController;
  String title;
  List dataImg = [];
  _ShowRoomGridViewState(this.title);
  // bool is_loading = false;
  String previousDate = '';
  bool loading = true;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refreshController = RefreshController(initialRefresh: false);
    if (title == '发现') {
      ShowRoomRequest.getAllPaintings().then((response) {
        print(response);
        if (response.data != null) {
          setState(() {
            dataImg = response.data['data'];
            loading = false;
          });
        }
      });
    } else if (title == '热门') {
      ShowRoomRequest.getHotPaintingsList().then((response) {
        List hotListId = response.data['painting_ids'];
        previousDate = response.data['previous_date'];
        ShowRoomRequest.getHotPaintings(hotListId).then((response) {
          setState(() {
            dataImg = response.data['data'];
            loading = false;
          });
          EasyLoading.dismiss();
        });
      });
    }

    bus.on(EventNames.changeBottomBar, (arg) async {
      if (arg == 1) {
        _refreshController.requestRefresh();
      }
    });
  }

  handleLoadMore() {
    if (title == '发现') {
      int _targetId = dataImg[dataImg.length - 1]['id'];
      ShowRoomRequest.getAllPaintings(
              lastId: "${_targetId - 25}", targetId: "${_targetId}")
          .then((response) {
        setState(() {
          dataImg.addAll(response.data['data']);
        });
        _refreshController.loadComplete();
      });
    } else {
      ShowRoomRequest.getHotPaintingsList(date: previousDate).then((response) {
        previousDate = response.data['previous_date'];
        List paintingIds = response.data['painting_ids'];
        ShowRoomRequest.getHotPaintings(paintingIds).then((response) {
          setState(() {
            dataImg.addAll(response.data['data']);
          });
          _refreshController.loadComplete();
        });
      });
    }
  }

  onListRefresh() async {
    if (title == '发现') {
      int _targetId = dataImg[0]['id'];
      Response response = await ShowRoomRequest.getAllPaintings(
          lastId: "${_targetId}", targetId: "${_targetId + 25}");

      List newData = response.data['data'];

      int lengthNew = newData[0]['id'] - _targetId;
      newData.sublist(lengthNew).addAll(dataImg);
      setState(() {
        dataImg = newData;
      });
      _refreshController.refreshCompleted();
    } else {
      _refreshController.refreshCompleted();
    }
  }

  onCellPress(int index) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => ShowRoomDetail(
                  data: dataImg[index],
                )));
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return SpinKitRing(color: HexColor(themeColor));
    }
    return Container(
      child: SmartRefresher(
        header: MaterialClassicHeader(
          color: HexColor(themeColor),
        ),
        enablePullDown: true,
        enablePullUp: true,
        footer: ClassicFooter(
          loadStyle: LoadStyle.ShowWhenLoading,
        ),
        controller: this._refreshController,
        onRefresh: this.onListRefresh,
        onLoading: this.handleLoadMore,
        child: GridView.builder(
            padding: EdgeInsets.all(5),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5),
            itemCount: dataImg.length,
            itemBuilder: (context, index) {
              return ShowRoomCell(
                dataImg[index]['url'],
                index,
                onPress: (index) {
                  this.onCellPress(index);
                },
              );
            }),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
