import 'package:flutter_colorfly/model/template_model.dart';
import 'package:flutter_colorfly/utils/sembast_db.dart';
import 'package:sembast/sembast.dart';

class PaintDataBase {
  static Future<String> createPaint(String svgId) async {
    int timeNow = DateTime.now().millisecondsSinceEpoch;
    String paintId = "t${timeNow}";
    Map<String, String> paintMap = {
      "svgId": svgId,
      "paintPath": '',
      "paintId": paintId
    };

    await SemDataBase.writeData(SemDataBase.paintStore, paintMap);
    return paintId;
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

  static Future<List<RecordSnapshot>> readPaintRecord() async {
    return await SemDataBase.readData(SemDataBase.paintStore, new Finder());
  }

  static Future deletePaint(String svgId, String paintId) async {
    Finder finder = Finder(
        filter: Filter.and([
      Filter.equals("svgId", svgId),
      Filter.equals('paintId', paintId)
    ]));
    return await SemDataBase.deleteData(SemDataBase.paintStore, finder);
  }
}

class TemplateDataBase {
  static saveTemplate(TemplateModel model) async {
    Map<String, String> templateMap = {
      "svgId": model.id,
      "url": model.url,
      "thumbUrl": model.thumbnailUrl,
      "mainTag": model.mainTag
    };
    await SemDataBase.writeData(SemDataBase.templateStore, templateMap);
  }

  static Future<List<RecordSnapshot>> readTemplate() async {
    return await SemDataBase.readData(SemDataBase.templateStore, new Finder());
  }

  static Future updateTemplate(String svgId, String paintPath) async {
    List<RecordSnapshot> records = await SemDataBase.readData(
        SemDataBase.templateStore,
        Finder(filter: Filter.equals("svgId", svgId)));
    await SemDataBase.updateData(records[0].ref, {'thumbUrl': paintPath});
  }
}

class StepDataBase {
  static Future<List<RecordSnapshot>> readSteps(Finder finder) async {
    return await SemDataBase.readData(SemDataBase.paintStepStore, finder);
  }

  static Future writeSteps(Map<String, String> values) async {
    await SemDataBase.writeData(SemDataBase.paintStepStore, values);
  }

  static Future updateSteps(String paintId, String pathId, String color) async {
    // await
    var filter = Filter.and(
        [Filter.equals("paintId", paintId), Filter.equals("pathId", pathId)]);
    List<RecordSnapshot> records = await SemDataBase.readData(
        SemDataBase.paintStepStore, Finder(filter: filter));
    await SemDataBase.updateData(records[0].ref, {'fillColor': color});
  }
}
