import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorfly/config/event_names.dart';
import 'package:flutter_colorfly/config/palettes.dart';
import 'package:flutter_colorfly/pages/Publish.dart';
import 'package:flutter_colorfly/utils/DataBaseUtils.dart';
import 'package:flutter_colorfly/utils/sembast_db.dart';
import 'package:flutter_colorfly/utils/HexColor.dart';
import 'package:flutter_colorfly/utils/ColorUtils.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';

import '../../global.dart';

GlobalKey<_PaintingWebViewState> webviewKey = GlobalKey();

class PaintingWebView extends StatefulWidget {
  String paintId;
  String svgId;

  PaintingWebView({Key key, this.paintId, this.svgId}) : super(key: key);

  @override
  _PaintingWebViewState createState() => _PaintingWebViewState();
}

class _PaintingWebViewState extends State<PaintingWebView> {
  String filePath = 'builtin/tintage/painting/index.html';
  InAppWebViewController webView;
  int popStatus = 0;
  bool paintLock = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bus.on(EventNames.colorCell, (arg) {
      //Color(0xfff970a4)
      String color = arg;
      onSwitchColor(color.substring(6, color.length - 1));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: InAppWebView(
      initialFile: filePath,
      initialHeaders: {},
      initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            debuggingEnabled: true,
            useShouldOverrideUrlLoading: true,
          ),
          android: AndroidInAppWebViewOptions(
              allowUniversalAccessFromFileURLs: true)),
      onWebViewCreated: this.onWebViewCreated,
      onLoadStart: (InAppWebViewController controller, String url) {},
      shouldOverrideUrlLoading:
          (controller, shouldOverrideUrlLoadingRequest) async {
        return ShouldOverrideUrlLoadingAction.ALLOW;
      },
      onLoadStop: (InAppWebViewController controller, String url) async {
        this._initWebView();
      },
      onConsoleMessage: (controller, consoleMessage) {
        print(consoleMessage.message);
      },
    ));
  }

  showLoading() {
    EasyLoading.show(dismissOnTap: false, maskType: EasyLoadingMaskType.black);
  }

  onFinishClick() {
    popStatus = 1;
    this._sendMsgToWebView('quit');
    showLoading();
  }

  onPopClick() {
    popStatus = 0;
    this._sendMsgToWebView('quit');
    showLoading();
  }

  onLockClick() {
    this._sendMsgToWebView('lock');
    if (!paintLock) {
      EasyLoading.showToast('连续涂色开启');
    } else {
      EasyLoading.showToast('连续涂色关闭');
    }
    paintLock = !paintLock;
  }

  void onSwitchColor(String color) {
    Color targetColor = HexColor(color);
    Map jsonMap = {
      'color':
          "rgb(${targetColor.red},${targetColor.green},${targetColor.blue})",
      'type': 0,
      'grad': {"x": 0, "y": 1, "z": 0}
    };
    String jsonMapString = JsonEncoder().convert(jsonMap);
    this._sendMsgToWebView('r${jsonMapString}');
  }

  void onWebViewCreated(InAppWebViewController controller) async {
    webView = controller;
    bus.emit(EventNames.colorCell, Palettes.theme_macaron()[0].toString());

    // List<RecordSnapshot> records = await PaintDataBase.readPaint('basic_1-0-3');
    addWebListener();
  }

  Future<String> _createFileFromString(String data, String name) async {
    final encodedStr = data;
    Uint8List bytes = base64.decode(encodedStr);
    String dir = (await getApplicationDocumentsDirectory()).path;

    String fullPath = '$dir/' + name;
    File file = File(fullPath);
    await file.writeAsBytes(bytes);

    return file.path;
  }

  Future<String> _createSvgFileFromString(String data, String name) async {
    String dir = (await getApplicationDocumentsDirectory()).path;

    String fullPath = '$dir/' + name;
    File file = File(fullPath);
    await file.writeAsString(data);

    return file.path;
  }

  Future saveStatus(String imgData, String svgData) async {
    int timeNow = DateTime.now().millisecondsSinceEpoch;
    String imgName = 'p${timeNow}.png';
    String svgName = 's${timeNow}.svg';
    String imgPath = await _createFileFromString(imgData, imgName);
    String svgPath = await _createSvgFileFromString(svgData, svgName);
    await PaintDataBase.updatePaint(widget.svgId, widget.paintId, imgPath);
    await TemplateDataBase.updateTemplate(widget.svgId, imgPath);
    EasyLoading.dismiss();

    if (popStatus == 1) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Publish(
              imgPath: imgPath,
              svgId: widget.svgId,
              svgPath: svgPath,
            ),
          ));
    } else {
      Navigator.pop(context);
    }
  }

  void addWebListener() {
    webView.addJavaScriptHandler(
        handlerName: 'jsMsg',
        callback: (args) {
          String message = args[0];
          switch (message[0]) {
            case 'c':
              break;
            case 'f':
              // 更改step调用
              String msg = message.substring(1, message.length);
              this._updateSteps(msg);
              break;
            case 'p':
              //吸色成功调用
              break;
            case 'b':
              //吸色失败调用
              break;
            case 'd':
              //保存图片到下一个界面
              break;
            case 'q':
              String mq = message.substring(1, message.length);
              String dataUri = JsonDecoder().convert(mq)['uri'];

              // print(dataUri.substring(22, dataUri.length));
              saveStatus(dataUri.substring(22, dataUri.length),
                  JsonDecoder().convert(mq)['svgContent']);

              //界面退出调用
              break;
            case 'a':
              //一条画笔画完后调用
              break;
          }
          if (message == 'window_onload') {
            _loadRecords();
          }
        });
  }

  _updateSteps(String msg) async {
    print('press message ' + msg);
    var step = JsonDecoder().convert(msg);
    String pathId = step['pathId'];
    String fillColor = step['fillColor'];
    String pageX = '${step['pageX']}';
    String pageY = "${step['pageY']}";
    // Finder finder =
    var filter = Filter.and([
      Filter.equals("paintId", widget.paintId),
      Filter.equals("pathId", pathId)
    ]);
    List<RecordSnapshot> records =
        await StepDataBase.readSteps(Finder(filter: filter));

    if (records.length > 0) {
      await StepDataBase.updateSteps(widget.paintId, pathId, fillColor);
    } else {
      Map<String, String> dataMap = {
        "pathId": pathId,
        "fillColor": fillColor,
        "paintId": widget.paintId,
        "pageX": pageX,
        "pageY": pageY
      };
      await StepDataBase.writeSteps(dataMap);
    }
  }

  _loadRecords() async {
    List<RecordSnapshot> records = await StepDataBase.readSteps(
        Finder(filter: Filter.equals("paintId", widget.paintId)));
    print("records length ${records.length} ");
    if (records.length == 0) return;

    List steps = [];
    for (RecordSnapshot record in records) {
      Map<String, dynamic> step = {
        "pathId": record['pathId'],
        "pageX": record['pageX'],
        "pageY": record['pageY'],
      };
      var fillColor = JsonDecoder().convert(record['fillColor']);
      String color = fillColor['color'];
      int type = fillColor['type'];
      var grad = fillColor['grad'];
      step['color'] = color;
      step['type'] = type;
      step['grad'] = grad;
      steps.add(step);
    }
    String json = JsonEncoder().convert(steps);
    _sendMsgToWebView(json, type: 'loadRecord');
  }

  _initWebView() {
    MediaQueryData mediaData = MediaQuery.of(context);
    double screenWidth = mediaData.size.width;
    double screenHeight = mediaData.size.height;
    String imgPath = '../../svg/${widget.svgId}.svg';
    Map init = {
      'isIOS': false,
      'portrait': true,
      'marginTop': 30,
      'ifShowPaintingAnimation': true,
      'screenWidth': screenWidth,
      'screenHeight': screenHeight,
      'imgPath': imgPath,
    };

    this._sendMsgToWebView(init, type: 'init');
  }

  _sendMsgToWebView(action, {String type}) {
    type ??= "previous";

    Map<String, dynamic> msg = {"type": type, "payload": action};
    String strMsg = JsonEncoder().convert(msg);
    webView.evaluateJavascript(source: "window.postMessage(${strMsg}, '*')");
  }
}
