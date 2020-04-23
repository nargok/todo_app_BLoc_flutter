import 'package:flutter/material.dart';
import 'package:todoappblocpattern/shop_list_screen.dart';
import 'data/todo.dart';
import 'data/todo_db.dart';
import 'bloc/todo_block.dart';
import 'data/shop_list.dart';
import 'data/shop_list_db.dart';
import 'bloc/shop_list_block.dart';
import 'todo_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'お買い物リスト',
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
  ShopListBloc shopListBloc;
  List<ShopList> shopLists;

  @override
  void initState() {
    shopListBloc = ShopListBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
//    _testData();

    ShopList shopList = ShopList('', 0, '', '');
    shopLists = shopListBloc.shopListBank;
    return Scaffold(
        appBar: AppBar(
          title: Text('お買い物リスト'),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ShopListScreen(shopList, true))
            );
          },
        ),
        body: Container(
          child: StreamBuilder<List<ShopList>>(
            stream: shopListBloc.shopLists,
            initialData: shopLists,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return ListView.builder(
                itemCount: (snapshot.hasData) ? snapshot.data.length : 0,
                itemBuilder: (context, index) {
                  return Dismissible( // swipe to delete
                    key: Key(snapshot.data[index].id.toString()),
                    onDismissed: (_) => shopListBloc.shopListDeleteSink.add(snapshot.data[index]),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).highlightColor,
                        child: Text("${snapshot.data[index].priority}"),
                      ),
                      title: Text("${snapshot.data[index].name}"),
                      subtitle: Text("${snapshot.data[index].place}"),
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
    shopListBloc.dispose();
    super.dispose();
  }
}
