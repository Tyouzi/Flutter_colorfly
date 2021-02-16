import 'package:flutter/foundation.dart';
import 'package:flutter_colorfly/config/gallery-tab.dart';
import 'package:flutter_colorfly/model/template_model.dart';

class GalleryModels extends ChangeNotifier {
  Map<String, List<TemplateModel>> galleryData = {};

  GalleryModels() {
    galleryData = createDataMap();
  }

  loadGalleryDatas(Map<String, List<TemplateModel>> data) {
    galleryData.addAll(data);
    notifyListeners();
  }

  changeImgPathById(String tag, String svgId, String imgPath) {
    TemplateModel template =
        galleryData[tag].firstWhere((element) => element.id == svgId);
    int index = galleryData[tag].indexOf(template);
    template.setThumbnailUrl = imgPath;
    galleryData[tag].replaceRange(index, index + 1, [template]);
    notifyListeners();
    // for (TemplateModel tem in galleryData[tag]) {
    //   if (tem.id == svgId) {
    //     tem.setThumbnailUrl(imgPath);
    //     tem
    //   }
    // }
  }

  Map<String, List<TemplateModel>> createDataMap() {
    Map<String, List<TemplateModel>> data = {};
    GalleryTabNames.tabNames.forEach((element) {
      data[element] = [];
    });

    return data;
  }
}
