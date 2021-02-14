import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorfly/component/customButton.dart';
import 'package:flutter_colorfly/config/ImageAssets.dart';
import 'package:flutter_colorfly/service/FetchClient.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class PublishedCell extends StatelessWidget {
  String imgPath;
  int id;
  Function onButtonPress;
  PublishedCell({Key key, this.imgPath, this.onButtonPress, this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double mWidth = MediaQuery.of(context).size.width;
    return Container(
      width: mWidth,
      height: mWidth + 10,
      margin: EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Container(
              width: mWidth - 20,
              height: mWidth - 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                    image: NetworkImage(FetchClient.ImgHost + imgPath)),
              )),
          Container(
            margin: EdgeInsets.only(right: 15),
            alignment: Alignment.centerRight,
            child: CustomButton(
              onTap: () {
                onButtonPress(id);
              },
              child: Image.asset(
                ImgAssets.showMoreButton,
                width: 25,
                height: 25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
