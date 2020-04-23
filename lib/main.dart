import 'package:flutter/material.dart';
import 'data/todo.dart';
import 'data/todo_db.dart';
import 'bloc/todo_block.dart';
import 'todo_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todos BLoC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State {
  TodoBloc todoBloc;
  List<Todo> todos;

  @override
  void initState() {
    todoBloc = TodoBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
//    _testData();

    Todo todo = Todo('', '', '', 0);
    todos = todoBloc.todoList;
    return Scaffold(
        appBar: AppBar(
          title: Text('Todo List'),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TodoScreen(todo, true))
            );
          },
        ),
        body: Container(
          child: StreamBuilder<List<Todo>>(
            stream: todoBloc.todos,
            initialData: todos,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return ListView.builder(
                itemCount: (snapshot.hasData) ? snapshot.data.length : 0,
                itemBuilder: (context, index) {
                  return Dismissible( // swipe to delete
                    key: Key(snapshot.data[index].id.toString()),
                    onDismissed: (_) => todoBloc.todoDeleteSink.add(snapshot.data[index]),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).highlightColor,
                        child: Text("${snapshot.data[index].priority}"),
                      ),
                      title: Text("${snapshot.data[index].name}"),
                      subtitle: Text("${snapshot.data[index].description}"),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TodoScreen(
                                snapshot.data[index], false))
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ));
  }

  Future _testData() async {
    TodoDb db = TodoDb();
    await db.database;
    List<Todo> todos = await db.getTodos();
    await db.deleteAll();
    todos = await db.getTodos();

    await db.insertTodo(
        Todo('Call Donald', 'And tell him about Daisy', '02/02/2020', 1));
    await db.insertTodo(Todo('By sugar', '1 Kg, brown', '02/02/2020', 2));
    await db.insertTodo(
        Todo('Go Running', '@12.00, with neigh-bours', '02/02/2020', 3));
    todos = await db.getTodos();

    debugPrint('First insert');
    todos.forEach((Todo todo) {
      debugPrint(todo.name);
    });

    Todo todoToUpdate = todos[0];
    todoToUpdate.name = 'Call Tim';
    await db.updateTodo(todoToUpdate);

    Todo todoToDelete = todos[1];
    await db.deleteTodo(todoToDelete);

    debugPrint('After udpates');
    todos = await db.getTodos();
    todos.forEach((Todo todo) {
      debugPrint(todo.name);
    });
  }

  @override
  void dispose() {
    todoBloc.dispose();
    super.dispose();
  }
}
