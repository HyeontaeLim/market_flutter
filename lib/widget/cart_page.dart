import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:market/provider/cart_provider.dart';
import 'package:market/widget/order_page.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/member.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    var itemCart = context.watch<CartProvider>().cart;
    var totalPrice = context.watch<CartProvider>().totalPrice;
    return Scaffold(
      appBar: AppBar(
        title: Text("장바구니"),
      ),
      body: itemCart.isNotEmpty
          ? ListView.builder(
              itemBuilder: (c, i) {
                return Container(
                  padding: EdgeInsets.all(8.0),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(itemCart[i].itemName,
                            style: const TextStyle(fontSize: 18)),
                        trailing: IconButton(
                            onPressed: () {
                              context.read<CartProvider>().remove(i);
                            },
                            icon: Icon(Icons.cancel)),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            height: 100,
                            width: 100,
                            child: AspectRatio(
                              aspectRatio: 1.0,
                              child: Image.network(
                                "http://10.0.2.2:5012${itemCart[i].img}",
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${NumberFormat('#,###').format(itemCart[i].totalPrice)} 원",
                                style: const TextStyle(fontSize: 18),
                              ),
                              Row(
                                children: [
                                  OutlinedButton(
                                      onPressed: () {
                                        context
                                            .read<CartProvider>()
                                            .removeQuantity(i);
                                        print(itemCart);
                                      },
                                      child: Icon(Icons.remove),
                                      style: ButtonStyle(
                                          shape: WidgetStatePropertyAll<
                                              OutlinedBorder>(CircleBorder()))),
                                  Container(
                                    child: Center(
                                        child: Text(itemCart[i]
                                            .orderQuantity
                                            .toString())),
                                    decoration:
                                        BoxDecoration(border: Border.all()),
                                    width: 40,
                                    height: 30,
                                  ),
                                  OutlinedButton(
                                    onPressed: () {
                                      context
                                          .read<CartProvider>()
                                          .addQuantity(i);
                                      print(itemCart);
                                    },
                                    child: Icon(Icons.add),
                                    style: ButtonStyle(
                                        shape: WidgetStatePropertyAll<
                                            OutlinedBorder>(CircleBorder())),
                                  )
                                ],
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                );
              },
              itemCount: itemCart.length,
            )
          : Center(
              child: Text(
              "장바구니에 담긴 상품이 없습니다.",
              style: TextStyle(fontSize: 17),
            )),
      bottomNavigationBar: itemCart.isNotEmpty ? Container(
        decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.black12))),
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Expanded(child: Text('합계: ${NumberFormat('#,###').format(totalPrice)}', style: TextStyle(fontSize: 18),)), Expanded(
          child: ElevatedButton(
            onPressed: () async {
              var store = await SharedPreferences.getInstance();
              String? sessionId = store.getString('.AspNetCore.Session');
              var uri = Uri.http('10.0.2.2:5012', 'loginmember');
              var response = await http.get(uri, headers: {'Cookie': '.AspNetCore.Session=$sessionId'});
              Member loginMember = Member.fromJson(jsonDecode(response.body));
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OrderPage(loginMember: loginMember,),));
            },
            child: Text("구매하기",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            style: ButtonStyle(
                backgroundColor:
                WidgetStatePropertyAll<Color>(Colors.indigoAccent),
                shape: WidgetStatePropertyAll<OutlinedBorder>(
                    RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(5))))),
          ),
        )],),
      ):null
    );
  }
}
