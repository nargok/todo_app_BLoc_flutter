import 'package:flutter/material.dart';
import 'bloc/todo_block.dart';
import 'data/todo.dart';
import 'bloc/shop_list_block.dart';
import 'data/shop_list.dart';
import 'main.dart';

class ShopListScreen extends StatelessWidget {
  final ShopList shopList;
  final bool isNew;
  final TextEditingController txtName = TextEditingController();
  final TextEditingController txtPrice = TextEditingController();
  final TextEditingController txtPlace = TextEditingController();
  final TextEditingController txtMemo = TextEditingController();

  final ShopListBloc bloc;

  /*
    The part after the colon in the TodoScreen constructor is an initializer list,
    a comma-separated list that you can use to initialize final fields with
    calculated expression
  */
  ShopListScreen(this.shopList, this.isNew) : bloc = ShopListBloc();

  Future save() async {
    shopList.name = txtName.text;
    shopList.place = txtPlace.text;
    shopList.memo = txtMemo.text;
    shopList.price = int.tryParse(txtPrice.text);
    if (isNew) {
      bloc.shopListInsertSink.add(shopList);
    } else {
      bloc.shopListUpdateSink.add(shopList);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double padding = 20.0;
    txtName.text = shopList.name;
    txtPlace.text = shopList.place;
    txtPrice.text = shopList.price.toString();
    txtMemo.text = shopList.memo;

    return Scaffold(
      appBar: AppBar(
        title: Text('お買い物リスト 詳細'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(padding),
              child: TextField(
                controller: txtName,
                decoration:
                InputDecoration(border: InputBorder.none, hintText: 'Name'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(padding),
              child: TextField(
                controller: txtPrice,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: 'Price'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(padding),
              child: TextField(
                controller: txtPlace,
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: 'Place'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(padding),
              child: TextField(
                controller: txtMemo,
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: 'Memo'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(padding),
              child: MaterialButton(
                color: Colors.green,
                child: Text('Save'),
                onPressed: () {
                  save().then((_) => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                        (Route<dynamic> route) => false,
                  ));
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
