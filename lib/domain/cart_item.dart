import 'package:market/domain/member_form.dart';

class CartItem {
  final int _itemId;
  final String _itemName;
  final int _price;
  final String _img;
  final int _orderQuantity;
  final int _totalPrice;

  CartItem(this._itemId, this._itemName, this._price, this._img,
      this._orderQuantity, this._totalPrice);

  int get itemId => _itemId;

  String get itemName => _itemName;

  int get price => _price;

  String get img => _img;

  int get orderQuantity => _orderQuantity;

  int get totalPrice => _totalPrice;

  CartItem modifyQuantity(int orderQuantity, int totalPrice) {
    return CartItem(_itemId, _itemName, _price, _img, orderQuantity, totalPrice);
  }

  @override
  String toString() {
    return 'CartItem{_itemId: $_itemId, _itemName: $_itemName, _price: $_price, _img: $_img, _orderQuantity: $_orderQuantity, _totalPrice: $_totalPrice}';
  }
}
