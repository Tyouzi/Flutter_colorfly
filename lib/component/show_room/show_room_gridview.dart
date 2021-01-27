import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorfly/component/cells/show_room_cell.dart';
import 'package:flutter_colorfly/service/FetchClient.dart';
import 'package:flutter_colorfly/service/ShowRoomRequest.dart';

class ShowRoomGridView extends StatefulWidget {
  String title;
  ShowRoomGridView(this.title, {Key key}) : super(key: key);

  @override
  _ShowRoomGridViewState createState() => _ShowRoomGridViewState(title);
}

class _ShowRoomGridViewState extends State<ShowRoomGridView>
    with AutomaticKeepAliveClientMixin {
  ScrollController _scrollController;
  String title;
  List dataImg = [];
  _ShowRoomGridViewState(this.title);
  bool is_loading = false;
  String previousDate = '';
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(title);
    if (title == '发现') {
      ShowRoomRequest.getAllPaintings().then((response) {
        print(response);
        if (response.data != null) {
          setState(() {
            dataImg = response.data['data'];
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
          });
        });
      });
    }

    _scrollController = new ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        if (!is_loading) {
          is_loading = true;
          this.handleLoadMore();
        }
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
        is_loading = false;
      });
    } else {
      ShowRoomRequest.getHotPaintingsList(date: previousDate).then((response) {
        previousDate = response.data['previous_date'];
        List paintingIds = response.data['painting_ids'];
        ShowRoomRequest.getHotPaintings(paintingIds).then((response) {
          setState(() {
            dataImg.addAll(response.data['data']);
          });
          print(dataImg.length);
          is_loading = false;
        });
      });
    }
  }

  Future onListRefresh() async {
    if (title == '发现') {
      int _targetId = dataImg[0]['id'];
      Response response = await ShowRoomRequest.getAllPaintings(
          lastId: "${_targetId}", targetId: "${_targetId + 25}");

      List newData = response.data['data'];

      print(newData[0]['id']);
      print(newData[newData.length - 1]['id']);
      int lengthNew = newData[0]['id'] - _targetId;
      newData.sublist(lengthNew).addAll(dataImg);
      print(newData.length);
      setState(() {
        dataImg = newData;
      });
      return response;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: RefreshIndicator(
      onRefresh: this.onListRefresh,
      child: GridView.builder(
          controller: _scrollController,
          padding: EdgeInsets.all(5),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5),
          itemCount: dataImg.length,
          itemBuilder: (context, index) {
            return ShowRoomCell(dataImg[index]['url'], index);
          }),
    ));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
