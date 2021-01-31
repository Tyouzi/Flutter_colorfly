import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_colorfly/pages/painting/painting.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'DataBaseUtils.dart';

class PaintHandler {
  static continuePress(
      BuildContext context, String paintId, String svgId) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                Painting(arguments: {"paintId": paintId, "svgId": svgId})));
  }

  static createNewPaint(BuildContext context, String svgId) async {
    String paintId = await PaintDataBase.createPaint(svgId);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                Painting(arguments: {"paintId": paintId, "svgId": svgId})));
  }

  static deletePaint(String svgId, String paintId) async {
    await PaintDataBase.deletePaint(svgId, paintId);
    EasyLoading.showToast('删除成功');
  }
}
