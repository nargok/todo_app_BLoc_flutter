import 'dart:async';
import '../data/shop_list.dart';
import '../data/shop_list_db.dart';

class ShopListBloc {
  ShopListDb db;
  List<ShopList> shopListBank;

  final _shopListsStreamController = StreamController<List<ShopList>>.broadcast();
  // for update
  final _shopListInsertController = StreamController<ShopList>();
  final _shopListUpdateController = StreamController<ShopList>();
  final _shopListDeleteController = StreamController<ShopList>();

  // constructor
  ShopListBloc() {
    db = ShopListDb();
    getShopLists();

    // listen to changes
    _shopListsStreamController.stream.listen(returnShopLists);
    _shopListInsertController.stream.listen(_addShopList);
    _shopListUpdateController.stream.listen(_updateShopList);
    _shopListDeleteController.stream.listen(_deleteShopList);
  }

  Stream<List<ShopList>> get shopLists => _shopListsStreamController.stream;
  StreamSink<List<ShopList>> get shopListsSink => _shopListsStreamController.sink;
  StreamSink<ShopList> get shopListInsertSink => _shopListInsertController.sink;
  StreamSink<ShopList> get shopListUpdateSink => _shopListUpdateController.sink;
  StreamSink<ShopList> get shopListDeleteSink => _shopListDeleteController.sink;

  Future getShopLists() async {
    List<ShopList> shopLists = await db.getShopLists();
    shopListBank = shopLists;
    shopListsSink.add(shopLists);
  }

  List<ShopList> returnShopLists (shopLists) {
    return shopLists;
  }

  void _deleteShopList(ShopList shopList) {
    db.deleteShopList(shopList).then((result) {
      getShopLists();
    });
  }

  void _updateShopList(ShopList shopList) {
    db.updateShopList(shopList).then((result) {
      getShopLists();
    });
  }

  void _addShopList(ShopList shopList) {
    db.insertShopList(shopList).then((result) {
      getShopLists();
    });
  }

  void dispose() {
    _shopListsStreamController.close();
    _shopListInsertController.close();
    _shopListUpdateController.close();
    _shopListDeleteController.close();
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
