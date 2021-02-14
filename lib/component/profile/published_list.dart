import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorfly/component/alert_dialog.dart';
import 'package:flutter_colorfly/component/cells/published_cell.dart';
import 'package:flutter_colorfly/component/customButton.dart';
import 'package:flutter_colorfly/component/loading_placeholder.dart';
import 'package:flutter_colorfly/global.dart';
import 'package:flutter_colorfly/model/models/user_painting.dart';
import 'package:flutter_colorfly/service/UserRequest.dart';
import 'package:flutter_colorfly/utils/HexColor.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PublishedList extends StatefulWidget {
  PublishedList({Key key}) : super(key: key);

  @override
  _PublishedListState createState() => _PublishedListState();
}

class _PublishedListState extends State<PublishedList>
    with AutomaticKeepAliveClientMixin {
  bool isLoading = true;
  RefreshController _refreshController;
  List paintData = [];
  int page = 1;
  bool hasMore = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refreshController = RefreshController();
    initData();
  }

  initData() async {
    Response response = await UserRequest.getMyPaintings(0);

    hasMore = response.data['data'].length == 24;

    List userPaintings = response.data['data'];
    setState(() {
      paintData = userPaintings;
      isLoading = false;
    });
    _refreshController.refreshCompleted();
  }

  Widget itemBuilder(BuildContext context, int nums) {
    UserPainting userPainting = UserPainting.fromJson(paintData[nums]);
    String imgPath = userPainting.url;
    int id = userPainting.id;
    return PublishedCell(
      imgPath: imgPath,
      id: id,
      onButtonPress: (id) {
        onButtonPress(id);
      },
    );
  }

  onButtonPress(int id) {
    showDialog(
        context: context,
        barrierDismissible: false,
        child: CustomAlertDialog(
          title: "确定要删除这张图片吗",
          onActionTap: () {
            this.deleteMyPainting(id);
          },
        ));
  }

  deleteMyPainting(int id) async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black, dismissOnTap: false);
    Response response = await UserRequest.deleteMyPaintings(id);
    await initData();
    EasyLoading.dismiss();
    Navigator.pop(context);
  }

  onLoadMore() async {
    if (!hasMore) {
      _refreshController.loadComplete();
      EasyLoading.showToast("没有更多，快去发布吧");
      return;
    }
    page = ++page;
    Response response = await UserRequest.getMyPaintings(page);
    List userPaintings = response.data['data'];
    hasMore = userPaintings.length == 24;
    print(hasMore);
    setState(() {
      paintData.addAll(userPaintings);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return LoadingPlaceHolder();
    }
    print(paintData.length);
    return Container(
      color: HexColor(themeGrey),
      margin: EdgeInsets.only(top: 15),
      child: SmartRefresher(
        controller: _refreshController,
        header: MaterialClassicHeader(
          color: HexColor(themeColor),
        ),
        enablePullDown: true,
        enablePullUp: true,
        footer: ClassicFooter(
          loadStyle: LoadStyle.ShowWhenLoading,
        ),
        onRefresh: () {
          this.initData();
        },
        onLoading: this.onLoadMore,
        child: ListView.separated(
            itemBuilder: this.itemBuilder,
            separatorBuilder: (context, nu) {
              return SizedBox(
                height: 5,
              );
            },
            itemCount: paintData.length),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
