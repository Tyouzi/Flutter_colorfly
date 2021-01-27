import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class SemDataBase {
  static Database db;
  static StoreRef paintStore;
  SemDataBase() {}
  static Future<Database> initDataBase() async {
    var dir = await getApplicationDocumentsDirectory();

    await dir.create(recursive: true);
    var dbPath = dir.path + '/flutter_colorfly.db';
    db = await databaseFactoryIo.openDatabase(dbPath);
    paintStore = intMapStoreFactory.store("paint");
    print('db loaded');
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
    // var finder = Finder(filter: Filter.equals('value', 'test'));
    var records = await store.find(db, finder: finder);
    return records;
  }
}
