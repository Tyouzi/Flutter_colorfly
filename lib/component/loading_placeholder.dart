import 'package:flutter/cupertino.dart';
import 'package:flutter_colorfly/global.dart';
import 'package:flutter_colorfly/utils/HexColor.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingPlaceHolder extends StatelessWidget {
  const LoadingPlaceHolder({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: SpinKitCircle(
          color: HexColor(themeColor),
        ),
      ),
    );
  }
}
