class Order {
  final int _id;
  final int _memberId;
  final String _address;
  final DateTime _orderDate;
  final String _orderStatus;
  final String _orderNum;


  Order(this._id, this._memberId, this._address, this._orderDate,
      this._orderStatus, this._orderNum);

  int get id => _id;

  int get memberId => _memberId;

  String get address => _address;

  DateTime get orderDate => _orderDate;

  String get orderStatus => _orderStatus;

  String get orderNum => _orderNum;

  factory Order.fromJson(Map<String, dynamic>json) =>
      Order(json["id"], json["memberId"], json["address"], DateTime.parse(json["orderDate"]), json["orderStatus"],
          json["orderNum"]);

  Map<String, dynamic> toJson() => {"id": _id, "memberId": _memberId, "address": _address, "orderDate": _orderDate, "orderStatus": _orderStatus, "orderNum": _orderNum};
}

class OrderItemDto {
  final String _itemName;
  final int _orderItemId;
  final int _price;
  final int _orderPrice;
  final int _count;
  final String _catName;


  OrderItemDto(this._itemName, this._orderItemId, this._price, this._orderPrice,
      this._count, this._catName);

  factory OrderItemDto.fromJson(Map<String, dynamic> json) => OrderItemDto(json["itemName"], json["orderItemId"], json["price"], json["orderPrice"], json["count"], json["catName"]);

  Map<String, dynamic> toJson() => {
    "itemName": _itemName,
    "orderItemId": _orderItemId,
    "price": _price,
    "orderPrice": _orderPrice,
    "count": _count,
    "catName": _catName
  };
  String get itemName => _itemName;

  int get orderItemId => _orderItemId;

  int get price => _price;

  int get orderPrice => _orderPrice;

  int get count => _count;

  String get catName => _catName;
}
