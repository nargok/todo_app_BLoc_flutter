import 'dart:async';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'shop_list.dart';

class ShopListDb {
  // this needs tod be a singleton
  static final ShopListDb _singleton = ShopListDb._internal();
  // private internal constructor todo 後で意味を調べる
  ShopListDb._internal();

  factory ShopListDb() { // only return a single instance of the current class
    return _singleton;
  }

  // open the database
  DatabaseFactory dbFactory = databaseFactoryIo;

  /*
    specify the location in which you want to save files
    store is the directory inside the database
  */
  final store = intMapStoreFactory.store('shop_list');

  // initial db settings
  Database _database;
  Future get database async {
    if (_database == null) {
      await _openDb().then((db) {
        _database = db;
      });
    }
  }

  Future _openDb() async {
    final docsPath = await getApplicationDocumentsDirectory();
    final dbPath = join(docsPath.path, 'shopList.db');
    final db = await dbFactory.openDatabase(dbPath);
    return db;
  }

  Future insertTodo(ShopList shopList) async {
    await store.add(_database, shopList.toMap());
  }

  Future updateTodo(ShopList shopList) async {
    // Finder is helper for searching a given store
    final finder = Finder(filter: Filter.byKey(shopList.id));
    await store.update(_database, shopList.toMap(), finder: finder);
  }

  Future deleteTodo(ShopList shopList) async {
    final finder =Finder(filter: Filter.byKey(shopList.id));
    await store.delete(_database, finder: finder);
  }

  Future deleteAll() async {
    await store.delete(_database);
  }

  Future<List<ShopList>> getShopLists() async {
    await database;
    final finder = Finder(sortOrders: [
      SortOrder('id'),
    ]);
    final shopListsSnapshot = await store.find(_database, finder: finder);
    return shopListsSnapshot.map((snapshot) {
      final shopList = ShopList.fromMap(snapshot.value);
      shopList.id = snapshot.key;
      return shopList;
    }).toList();
  }
}
