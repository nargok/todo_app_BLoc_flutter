class ShopList {
  int id;
  String name;
  int price;
  String place;
  String memo;

  ShopList(this.name, this.price, this.place, this.memo);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'place': place,
      'memo': memo,
    };
  }

  static ShopList fromMap(Map<String, dynamic> map) {
    return ShopList(
        map['name'], map['price'], map['place'], map['memo']);
  }
}
