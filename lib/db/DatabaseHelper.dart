import 'package:contact/model/ContactUserModel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class DatabaseHelper {
  static late Database db;

  static Future<void> initDatabase() async {
    var dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    var dbPath = '${dir.path}_contact_database.db';
    db = await databaseFactoryIo.openDatabase(dbPath);
  }

  static Future<void> insertData(Map<String, dynamic> map) async {
    var store = intMapStoreFactory.store("ContactUser");
    await db.transaction((transaction) async {
      await store.add(transaction, map);
    });
  }

  static Future<List<ContactUserModel>> queryAllData() async {
    var store = intMapStoreFactory.store("ContactUser");
    var query =store.query(finder: Finder(sortOrders: [SortOrder("name")]));
    List<ContactUserModel> list = [];
    await query.getSnapshots(db).then((value) => value.forEach((element) async {
          list.add(ContactUserModel.fromJson(element.value));
        }));
    return list;
  }

  static Future<List<ContactUserModel>> qureyFavoriteData() async {
    var store = intMapStoreFactory.store("ContactUser");
    var query =
        store.query(finder: Finder(filter: Filter.equals("isFavorite", true), sortOrders: [SortOrder("name")]));
    List<ContactUserModel> list = [];
    await query.getSnapshots(db).then((value) => value.forEach((element) async {
          list.add(ContactUserModel.fromJson(element.value));
        }));
    return list;
  }

  static Future<ContactUserModel> queryUser(String name) async {
    var store = intMapStoreFactory.store("ContactUser");
    var query =
        store.query(finder: Finder(filter: Filter.equals("name", name)));
    ContactUserModel user = ContactUserModel();
    await query.getSnapshots(db).then((value) => value.forEach((element) {
          user = ContactUserModel.fromJson(element.value);
        }));
    return user;
  }

  static Future<void> updateUser(String name, Map<String, dynamic> map) async {
    var store = intMapStoreFactory.store("ContactUser");
    var query =
        store.query(finder: Finder(filter: Filter.equals("name", name)));
    await query.getSnapshots(db).then((value) => value.forEach((element) async {
          await store.record(element.key).put(db, map, merge: true);
        }));
  }

  static Future<void> deleteUser(String name) async {
    var store = intMapStoreFactory.store("ContactUser");
    var query =
        store.query(finder: Finder(filter: Filter.equals("name", name)));
    await query.getSnapshots(db).then((value) => value.forEach((element) async {
          await store.record(element.key).delete(db);
        }));
  }
}
