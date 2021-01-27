import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorfly/config/event_names.dart';
import 'package:flutter_colorfly/config/palettes.dart';
import 'package:flutter_colorfly/utils/DataBaseUtils.dart';
import 'package:flutter_colorfly/utils/sembast_db.dart';
import 'package:flutter_colorfly/utils/HexColor.dart';
import 'package:flutter_colorfly/utils/ColorUtils.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';

import '../../global.dart';

GlobalKey<_PaintingWebViewState> webviewKey = GlobalKey();

class PaintingWebView extends StatefulWidget {
  PaintingWebView({Key key}) : super(key: key);

  @override
  _PaintingWebViewState createState() => _PaintingWebViewState();
}

class _PaintingWebViewState extends State<PaintingWebView> {
  String filePath = 'builtin/tintage/painting/index.html';
  InAppWebViewController webView;
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
        addWebListener();
      },
      onConsoleMessage: (controller, consoleMessage) {},
    ));
  }

  onFinishClick() {
    this._sendMsgToWebView('quit');
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

    List<RecordSnapshot> records = await PaintDataBase.readPaint('basic_1-0-3');

    print(records.length);
    print(records[0]['paintPath']);
    print(records[records.length - 1]['paintPath']);
  }

  Future<String> _createFileFromString(String data) async {
    final encodedStr = data;
    Uint8List bytes = base64.decode(encodedStr);
    String dir = (await getApplicationDocumentsDirectory()).path;
    int timeNow = DateTime.now().millisecondsSinceEpoch;
    String fullPath = '$dir/p${timeNow}.png';
    File file = File(fullPath);
    await file.writeAsBytes(bytes);

    return file.path;
  }

  Future saveStatus(String imgData) async {
    String imgPath = await _createFileFromString(imgData);
    await PaintDataBase.updatePaint('basic_1-0-3', 't782', imgPath);
    print('save_complate');
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
              saveStatus(dataUri.substring(22, dataUri.length));
              //界面退出调用
              break;
            case 'window_onload':
              _loadRecords();
              break;
            case 'a':
              //一条画笔画完后调用
              break;
          }
        });
  }

  _loadRecords() {}
  _initWebView() {
    MediaQueryData mediaData = MediaQuery.of(context);
    double screenWidth = mediaData.size.width;
    double screenHeight = mediaData.size.height;
    Map init = {
      'isIOS': true,
      'portrait': true,
      'marginTop': 40,
      'ifShowPaintingAnimation': true,
      'screenWidth': screenWidth,
      'screenHeight': screenHeight,
      'imgPath': 'basic_1-0-3.svg',
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
