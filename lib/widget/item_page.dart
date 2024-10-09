import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:market/domain/cart_item.dart';
import 'package:market/provider/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../domain/item_dto.dart';
import '../domain/member.dart';
import 'cart_page.dart';
import 'order_page.dart';

class ItemPage extends StatefulWidget {
  final ItemDto selectedItem;

  const ItemPage({super.key, required this.selectedItem});

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  late int purchaseQuantity;

  @override
  void initState() {
    super.initState();
    purchaseQuantity = 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, "/main", (Route<dynamic> route) => false);
              },
              icon: const Icon(Icons.home)),
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const CartPage()));
              },
              icon: context.watch<CartProvider>().cart.isEmpty
                  ? const Icon(
                      Icons.shopping_cart_rounded,
                      size: 30,
                    )
                  : Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        const Icon(Icons.shopping_cart_rounded, size: 30),
                        CircleAvatar(
                          backgroundColor: Colors.red,
                          radius: 10,
                          child: Text(
                            context
                                .watch<CartProvider>()
                                .cart
                                .length
                                .toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.0,
              child: Image.network(
                "http://10.0.2.2:5012${widget.selectedItem.img}",
                fit: BoxFit.contain,
              ),
            ),
            Text(
              "${widget.selectedItem.itemName}",
              style: const TextStyle(fontSize: 17),
            ),
            const SizedBox(height: 5),
            Wrap(
              direction: Axis.vertical,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text("${NumberFormat('#,###').format(widget.selectedItem.price)}원",
                    style:
                        const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                widget.selectedItem.status
                    ? const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.rocket_launch,
                            color: Colors.blue,
                            size: 20,
                          ),
                          Text("로켓배송",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue))
                        ],
                      )
                    : Container(),
              ],
            ),
            widget.selectedItem.quantity != 0 ? Container() : const Text("재고없음"),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text(
                  "수량 ",
                ),
                OutlinedButton(
                    onPressed: () {
                      setState(() {
                        purchaseQuantity--;
                        if (purchaseQuantity < 1) {
                          purchaseQuantity = 1;
                        }
                      });
                    },
                    style: const ButtonStyle(
                        shape: WidgetStatePropertyAll<OutlinedBorder>(
                            CircleBorder())),
                    child: const Icon(Icons.remove)),
                Container(
                  decoration: BoxDecoration(border: Border.all()),
                  width: 40,
                  height: 30,
                  child: Center(child: Text(purchaseQuantity.toString())),
                ),
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      purchaseQuantity++;
                    });
                  },
                  style: const ButtonStyle(
                      shape: WidgetStatePropertyAll<OutlinedBorder>(
                          CircleBorder())),
                  child: const Icon(Icons.add),
                )
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              child: ElevatedButton(
                onPressed: () async {
                  var store = await SharedPreferences.getInstance();
                  String? sessionId = store.getString('.AspNetCore.Session');
                  var uri = Uri.http('10.0.2.2:5012', 'loginmember');
                  var response = await http.get(uri,
                      headers: {'Cookie': '.AspNetCore.Session=$sessionId'});
                  Member loginMember =
                      Member.fromJson(jsonDecode(response.body));
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderPage(
                          loginMember: loginMember,
                          item: new CartItem(
                              widget.selectedItem.itemId,
                              widget.selectedItem.itemName,
                              widget.selectedItem.price,
                              widget.selectedItem.img,
                              purchaseQuantity,
                              widget.selectedItem.price * purchaseQuantity),
                        ),
                      ));
                },
                style: const ButtonStyle(
                    backgroundColor:
                        WidgetStatePropertyAll<Color>(Colors.indigoAccent),
                    shape: WidgetStatePropertyAll<OutlinedBorder>(
                        RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5))))),
                child: const Text(
                  "구매하기",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              child: ElevatedButton(
                onPressed: () async {
                  var cartItem = new CartItem(
                      widget.selectedItem.itemId,
                      widget.selectedItem.itemName,
                      widget.selectedItem.price,
                      widget.selectedItem.img,
                      purchaseQuantity,
                      widget.selectedItem.price * purchaseQuantity);
                  context.read<CartProvider>().addItem(cartItem);
                },
                style: const ButtonStyle(
                    backgroundColor:
                        WidgetStatePropertyAll<Color>(Colors.indigoAccent),
                    shape: WidgetStatePropertyAll<OutlinedBorder>(
                        RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5))))),
                child: const Text("장바구니",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
