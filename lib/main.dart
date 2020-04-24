import 'package:flutter/material.dart';
//import 'data/todo_db.dart';
import 'data/shop_list.dart';
import 'data/shop_list_db.dart';
import 'bloc/shop_list_block.dart';
//import 'todo_screen.dart';
import 'shop_list_screen.dart';

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
    _testShopListData();

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
                        child: Text("${snapshot.data[index].price}"),
                      ),
                      title: Text("${snapshot.data[index].name}"),
                      subtitle: Text("${snapshot.data[index].place}"),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ShopListScreen(
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

//  Future _testData() async {
//    TodoDb db = TodoDb();
//    await db.database;
//    List<Todo> todos = await db.getTodos();
//    await db.deleteAll();
//    todos = await db.getTodos();
//
//    await db.insertTodo(
//        Todo('Call Donald', 'And tell him about Daisy', '02/02/2020', 1));
//    await db.insertTodo(Todo('By sugar', '1 Kg, brown', '02/02/2020', 2));
//    await db.insertTodo(
//        Todo('Go Running', '@12.00, with neigh-bours', '02/02/2020', 3));
//    todos = await db.getTodos();
//
//    debugPrint('First insert');
//    todos.forEach((Todo todo) {
//      debugPrint(todo.name);
//    });
//
//    Todo todoToUpdate = todos[0];
//    todoToUpdate.name = 'Call Tim';
//    await db.updateTodo(todoToUpdate);
//
//    Todo todoToDelete = todos[1];
//    await db.deleteTodo(todoToDelete);
//
//    debugPrint('After udpates');
//    todos = await db.getTodos();
//    todos.forEach((Todo todo) {
//      debugPrint(todo.name);
//    });
//  }
//
  Future _testShopListData() async {
    ShopListDb db = ShopListDb();
    await db.database;
    List<ShopList> shopLists = await db.getShopLists();
    await db.deleteAll();
    shopLists = await db.getShopLists();

    await db.insertShopList(
        ShopList('お米', 1200, 'スーパー2', '無洗米'));
    await db.insertShopList(ShopList('お酒', 900, 'スーパー2', '土佐鶴'));
    await db.insertShopList(
        ShopList('ごま油', 200, 'スーパー1', '黒ごま油'));
    shopLists = await db.getShopLists();

    debugPrint('First insert');
    shopLists.forEach((ShopList s) {
      debugPrint(s.name);
    });

    ShopList shopListToUpdate = shopLists[0];
    shopListToUpdate.name = 'Call Tim';
    await db.updateShopList(shopListToUpdate);

    ShopList shopListToDelete = shopLists[1];
    await db.deleteShopList(shopListToDelete);

    debugPrint('After udpates');
    shopLists = await db.getShopLists();
    shopLists.forEach((ShopList s) {
      debugPrint(s.name);
    });
  }

  @override
  void dispose() {
    shopListBloc.dispose();
    super.dispose();
  }
}
