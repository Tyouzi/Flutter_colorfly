import 'dart:ui';

class Palettes {
  static List<String> convertColor(String strColor) {
    String colors = strColor.substring(4, strColor.length - 1);
    return colors.split(',').toList();
  }

  static List<Color> theme_macaron() {
    List colors = [
      "rgb(177,221,134)",
      "rgb(254,194,228)",
      "rgb(249,112,164)",
      "rgb(247,82,116)",
      "rgb(188,135,191)",
      "rgb(97,49,97)",
      "rgb(156,229,222)",
      "rgb(183,216,199)",
      "rgb(86,174,162)",
      "rgb(5,171,169)",
      "rgb(251,203,183)",
      "rgb(249,167,155)",
      "rgb(214,175,120)",
    ];
    List<Color> results = [];
    for (String color in colors) {
      List<String> colorNumbers = convertColor(color);
      results.add(Color.fromRGBO(int.parse(colorNumbers[0]),
          int.parse(colorNumbers[1]), int.parse(colorNumbers[2]), 1));
    }
    return results;
    // Color.fromRGBO(177, 221, 134, 1);
  }
}
