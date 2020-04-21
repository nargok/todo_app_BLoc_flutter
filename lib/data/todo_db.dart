import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'todo.dart';

class TodoDb {
  // this needs tod be a singleton
  static final TodoDb _singleton = TodoDb._internal();
  // private internal constructor todo 後で意味を調べる
  TodoDb._internal();

  factory TodoDb() { // only return a single instance of the current class
    return _singleton;
  }

  // open the database
  DatabaseFactory dbFactory = databaseFactoryIo;

  /*
    specify the location in which you want to save files
    store is the directory inside the database
  */
  final store = intMapStoreFactory.store('todos');

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
    final dbPath = join(docsPath.path, 'todos.db');
    final db = await dbFactory.openDatabase(dbPath);
    return db;
  }


}