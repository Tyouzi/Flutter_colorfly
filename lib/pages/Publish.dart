import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorfly/component/customButton.dart';
import 'package:flutter_colorfly/component/publishAppBar.dart';
import 'package:flutter_colorfly/config/event_names.dart';
import 'package:flutter_colorfly/global.dart';
import 'package:flutter_colorfly/service/GalleryRequest.dart';
import 'package:flutter_colorfly/utils/HexColor.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class Publish extends StatelessWidget {
  String imgPath;
  String svgId;
  String svgPath;
  Publish({Key key, this.imgPath, this.svgId, this.svgPath}) {
    print(imgPath);
  }
  onTapFinish(BuildContext buildContext) {
    bus.emit(EventNames.changeBottomBar, 3);
    bus.emit(EventNames.cellPathUpdate, {"svgId": svgId, "thumbUrl": imgPath});
    Navigator.of(buildContext).popUntil((route) => route.isFirst);
  }

  onTapPublish(BuildContext buildContext) async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black, dismissOnTap: false);
    String nPath = this.imgPath.substring(0, imgPath.lastIndexOf('/')) +
        '/compressed_pic.jpg';
    await FlutterImageCompress.compressAndGetFile(this.imgPath, nPath,
        minWidth: 800, minHeight: 800, quality: 80);
    await GalleryRequest.upLoadPainting(this.imgPath, svgPath, svgId);
    EasyLoading.dismiss();
    bus.emit(EventNames.changeBottomBar, 1);
    Navigator.of(buildContext).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.width;
    return SafeArea(
        child: DecoratedBox(
      decoration: BoxDecoration(color: HexColor(themeGrey)),
      child: Column(
        children: [
          PublishAppBar(
            onFinish: () {
              onTapFinish(context);
            },
          ),
          Container(
            margin: EdgeInsets.only(
                top: screenHeight * 0.15, bottom: screenHeight * 0.15),
            child: Image.file(File(imgPath)),
          ),
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            child: CustomButton(
              onTap: () {
                onTapPublish(context);
              },
              child: DecoratedBox(
                child: Center(
                  child: Text(
                    '分享到画廊',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: HexColor(themeColor)),
              ),
              width: 200,
              height: 50,
            ),
          )
        ],
      ),
    ));
  }
}
