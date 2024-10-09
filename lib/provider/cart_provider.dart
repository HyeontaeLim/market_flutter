import 'package:flutter/cupertino.dart';
import 'package:market/domain/cart_item.dart';

class CartProvider extends ChangeNotifier{
  List<CartItem> cart = [];
  int totalPrice = 0;

  void addItem(CartItem cartItem) {
    if(cart.any((item)=>item.itemId==cartItem.itemId)) {
      var index = cart.indexWhere((item)=>item.itemId==cartItem.itemId);
      cart[index] = cart[index].modifyQuantity(cart[index].orderQuantity+cartItem.orderQuantity, (cart[index].orderQuantity+cartItem.orderQuantity)*cart[index].price);
    } else{
      cart.add(cartItem);
    }
    setTotalPrice();
    notifyListeners();
  }

  void remove(int index) {
    cart.removeAt(index);
    setTotalPrice();
    notifyListeners();
  }

  void addQuantity(int index)
  {
    cart[index] = cart[index].modifyQuantity(cart[index].orderQuantity+1, (cart[index].orderQuantity+1)*cart[index].price);
    setTotalPrice();
    notifyListeners();
  }

  void removeQuantity(int index)
  {
    if(cart[index].orderQuantity-1>=1) {
      cart[index] = cart[index].modifyQuantity(cart[index].orderQuantity-1, (cart[index].orderQuantity-1)*cart[index].price);
      setTotalPrice();
      notifyListeners();
    }
  }
  void clearCart() {
    cart.clear();
    setTotalPrice();
    notifyListeners();
  }
  void setTotalPrice()
  {
    var totalPrice=0;
    for (var cartItem in cart) {
      totalPrice+=cartItem.totalPrice;
    }
    this.totalPrice = totalPrice;
  }
}