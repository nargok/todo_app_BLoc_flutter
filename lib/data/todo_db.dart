import 'dart:async';
import 'package:path/path.dart';
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
    final dbPath = join(docsPath.path, 'todos.db');
    final db = await dbFactory.openDatabase(dbPath);
    return db;
  }

  Future insertTodo(Todo todo) async {
    await store.add(_database, todo.toMap());
  }

  Future updateTodo(Todo todo) async {
    // Finder is helper for searching a given store
    final finder = Finder(filter: Filter.byKey(todo.id));
    await store.update(_database, todo.toMap(), finder: finder);
  }

  Future deleteTodo(Todo todo) async {
    final finder =Finder(filter: Filter.byKey(todo.id));
    await store.delete(_database, finder: finder);
  }

  Future deleteAll() async {
    await store.delete(_database);
  }

  Future<List<Todo>> getTodos() async {
    await database;
    final finder = Finder(sortOrders: [
      SortOrder('priority'),
      SortOrder('id'),
    ]);
    final todosSnapshot = await store.find(_database, finder: finder);
    return todosSnapshot.map((snapshot) {
      final todo = Todo.fromMap(snapshot.value);
      return todo;
    }).toList();
  }


}