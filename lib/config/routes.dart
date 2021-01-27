import 'package:flutter/material.dart';
import 'package:flutter_colorfly/pages/painting/painting.dart';

class Routes {
  static String painting = '/painting';

  static Map<String, WidgetBuilder> configureRoutes(BuildContext context) {
    Map<String, WidgetBuilder> routes = {painting: (context) => Painting()};
    return routes;
  }
}
