import 'package:flutter/material.dart';
import 'package:flutter_colorfly/pages/painting/painting.dart';

class Routes {
  static String painting = '/painting';

  static Map<String, Function> configureRoutes(BuildContext context) {
    Map<String, Function> routes = {
      painting: (context, {arguments}) => Painting()
    };
    return routes;
  }
}
