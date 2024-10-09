class OrderForm {
  final int _memberId;
  final List<OrderItemForm> _orderItemForms;
  final String _address;

  int get memberId => _memberId;

  OrderForm(
      this._memberId, this._orderItemForms, this._address);

  List<OrderItemForm> get orderItemForms => _orderItemForms;

  String get address => _address;


  Map<String, dynamic> toJson() => {
    'memberId': _memberId,
    'orderItemForms': _orderItemForms.map((item) => item.toJson()).toList(),
    'address': _address
  };
}

class OrderItemForm {
  final int _itemId;
  final int _orderPrice;
  final int _count;

  OrderItemForm(this._itemId, this._orderPrice, this._count);

  int get count => _count;

  int get orderPrice => _orderPrice;

  int get itemId => _itemId;

  factory OrderItemForm.fromJson(Map<String, dynamic> json) =>
      OrderItemForm(json['itemId'], json['orderPrice'], json['count']);

  Map<String, dynamic> toJson() => {
        "itemId": _itemId,
        "orderPrice": _orderPrice,
        "count": _count,
      };
}
