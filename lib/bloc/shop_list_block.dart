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

  // constructor
  TodoBloc() {
    db = TodoDb();
    getTodos();

    // listen to changes
    _todosStreamController.stream.listen(returnTodos);
    _todoInsertController.stream.listen(_addTodo);
    _todoUpdateController.stream.listen(_updateTodo);
    _todoDeleteController.stream.listen(_deleteTodo);
  }

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

  List<Todo> returnTodos (todos) {
    return todos;
  }

  void _deleteTodo(Todo todo) {
    db.deleteTodo(todo).then((result) {
      getTodos();
    });
  }

  void _updateTodo(Todo todo) {
    db.updateTodo(todo).then((result) {
      getTodos();
    });
  }

  void _addTodo(Todo todo) {
    db.insertTodo(todo).then((result) {
      getTodos();
    });
  }

  void dispose() {
    _todosStreamController.close();
    _todoInsertController.close();
    _todoUpdateController.close();
    _todoDeleteController.close();
  }
}



/*
  1. Create the BLoC class
  2. Declaring the data that will change
  3. Setting the StreamControllers
  4. Creating the getters for streams and sinks
  5. Adding the logic of the BLoC
  6. Creating the constructor
  7. Setting the dispose() method
*/
