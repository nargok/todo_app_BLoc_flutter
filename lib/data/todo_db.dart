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
}