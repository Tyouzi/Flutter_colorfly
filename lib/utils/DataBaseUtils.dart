import 'package:flutter_colorfly/utils/sembast_db.dart';
import 'package:sembast/sembast.dart';

class PaintDataBase {
  static Future createPaint(String svgId) async {
    int timeNow = DateTime.now().millisecondsSinceEpoch;
    String paintId = "t${timeNow}";
    Map<String, String> paintMap = {
      "svgId": svgId,
      "paintPath": '',
      "paintId": paintId
    };

    await SemDataBase.writeData(SemDataBase.paintStore, paintMap);
  }

  static Future<List<RecordSnapshot>> readPaint(String svgId) async {
    Finder finder = Finder(filter: Filter.equals("svgId", svgId));
    return await SemDataBase.readData(SemDataBase.paintStore, finder);
  }

  static Future updatePaint(
      String svgId, String paintId, String paintPath) async {
    List<RecordSnapshot> records = await SemDataBase.readData(
        SemDataBase.paintStore,
        Finder(filter: Filter.equals("paintId", paintId)));
    await SemDataBase.updateData(records[0].ref, {'paintPath': paintPath});
  }
}
