import 'package:flutter_colorfly/config/event_names.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

import '../global.dart';

class SemDataBase {
  static Database db;
  static StoreRef paintStore;
  static StoreRef templateStore;
  static StoreRef paintStepStore;
  SemDataBase() {}
  static Future<Database> initDataBase() async {
    var dir = await getApplicationDocumentsDirectory();

    await dir.create(recursive: true);
    var dbPath = dir.path + '/flutter_colorfly.db';
    db = await databaseFactoryIo.openDatabase(dbPath);
    paintStore = intMapStoreFactory.store("paint");
    templateStore = intMapStoreFactory.store('template');
    paintStepStore = intMapStoreFactory.store('paintStep');
    print('db loaded');
    bus.emit(EventNames.dbStatus);
    return db;
  }

  static Future writeData(StoreRef store, value) async {
    await store.add(db, value);
  }

  static Future updateData(RecordRef recordRef, value) async {
    await recordRef.update(db, value);
  }

  static Future<List<RecordSnapshot>> readData(
      StoreRef store, Finder finder) async {
    var records = await store.find(db, finder: finder);
    return records;
  }

  static Future<int> deleteData(StoreRef store, Finder finder) async {
    int result = await store.delete(db, finder: finder);
    return result;
  }
}
