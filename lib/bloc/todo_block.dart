import 'dart:async';
import '../data/todo.dart';
import '../data/todo_db.dart';

class TodoBloc {
  TodoDb db;
  List<Todo> todoList;

  final _todosStreamController = StreamController<List<Todo>>.broadcast();
  // for update
  final _todoInsertController = StreamController<Todo>();
  final _todoUpdateController = StreamController<Todo>();
  final _todoDeleteController = StreamController<Todo>();

  Stream<List<Todo>> get todos => _todosStreamController.stream;
  StreamSink<List<Todo>> get todosSink => _todosStreamController.sink;
  StreamSink<Todo> get todoInsertSink => _todoInsertController.sink;
  StreamSink<Todo> get todoUpdateSink => _todoUpdateController.sink;
  StreamSink<Todo> get todoDeleteSink => _todoDeleteController.sink;

  Future getTodos() async {
    List<Todo> todos = await db.getTodos();
    todoList = todos;
    todosSink.add(todos);
  }

}



/*
1. Create the BLoC class
2. Declaring the data that will change
3. Setting the StreamControllers
4. Creating the getters for streams and sinks
5. Adding the logic of the BLoC
*/
