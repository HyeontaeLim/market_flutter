import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:market/domain/cart_item.dart';
import 'package:market/domain/order_form.dart';
import 'package:market/provider/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/member.dart';
import '../domain/order.dart';
import 'order_confirm_page.dart';

class OrderPage extends StatefulWidget {
  final Member loginMember;
  final CartItem? item;

  const OrderPage({super.key, required this.loginMember, this.item});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    var cart = context.watch<CartProvider>().cart;
    return Scaffold(
      appBar: AppBar(
        title: const Text('주문/결제'),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        child: ListView(
          children: [
            const SizedBox(
              height: 12,
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), side: BorderSide()),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('배송지',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const Divider(
                      color: Colors.black45,
                      thickness: 1,
                      height: 20,
                    ),
                    Text(
                      widget.loginMember.address,
                      style: const TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), side: BorderSide()),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8.0),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('배송 요청 사항',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    Divider(
                      color: Colors.black45,
                      thickness: 1,
                      height: 20,
                    ),
                    TextField(
                      decoration: InputDecoration(border: OutlineInputBorder()),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), side: BorderSide()),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8.0),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('결제 수단',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    Divider(
                      color: Colors.black45,
                      thickness: 1,
                      height: 20,
                    ),
                    Text(
                      '신한카드',
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), side: BorderSide()),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('상품',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const Divider(
                      color: Colors.black45,
                      thickness: 1,
                      height: 20,
                    ),
                    widget.item == null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                              cart.length, // 동적으로 항목 개수 지정
                              (index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cart[index].itemName,
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    Text(
                                      '수량: ${cart[index].orderQuantity}',
                                      style: const TextStyle(
                                          fontSize: 15, color: Colors.black54),
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    )
                                  ],
                                );
                              },
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.item!.itemName,
                                style: const TextStyle(fontSize: 18),
                              ),
                              Text(
                                '수량: ${widget.item!.orderQuantity}',
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.black54),
                              ),
                              const SizedBox(
                                height: 12,
                              )
                            ],
                          )
                  ],
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), side: BorderSide()),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('최종 결제 금액',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const Divider(
                      color: Colors.black45,
                      thickness: 1,
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                '총 상품 가격',
                                style: TextStyle(fontSize: 18),
                              ),
                              widget.item == null
                                  ? Text(
                                      '${NumberFormat('#,###').format(context.watch<CartProvider>().totalPrice)}원',
                                      style: const TextStyle(fontSize: 18),
                                    )
                                  : Text(
                                      '${NumberFormat('#,###').format(widget.item!.totalPrice)}원',
                                      style: const TextStyle(fontSize: 18),
                                    )
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '배송비',
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                '0원',
                                style: TextStyle(fontSize: 18),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      color: Colors.black45,
                      thickness: 1,
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '총 결제 금액',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        widget.item == null
                            ? Text(
                                '${NumberFormat('#,###').format(context.watch<CartProvider>().totalPrice)}원',
                                style: const TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              )
                            : Text(
                                '${NumberFormat('#,###').format(widget.item!.totalPrice)}원',
                                style: const TextStyle(fontSize: 18),
                              )
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            FilledButton(
                onPressed: () async {
                  var store = await SharedPreferences.getInstance();
                  var sessionId = store.getString('.AspNetCore.Session');
                  var uri = Uri.http("10.0.2.2:5012", "/order");
                  if (widget.item == null) {
                    var orderItemForms = cart
                        .map(
                          (e) => OrderItemForm(
                              e.itemId, e.totalPrice, e.orderQuantity),
                        )
                        .toList();
                    var response = await http.post(uri,
                        headers: {
                          'Cookie': '.AspNetCore.Session=$sessionId',
                          'Content-Type': 'application/json; charset=UTF-8',
                        },
                        body: jsonEncode(OrderForm(widget.loginMember.memberId,
                                orderItemForms, widget.loginMember.address)
                            .toJson()));
                    if (response.statusCode == HttpStatus.ok) {
                      var order =
                          Order.fromJson(jsonDecode(response.body)["order"]);
                      var orderItemJson =
                          jsonDecode(response.body)["orderItemDtos"] as List;
                      var totalPrice = jsonDecode(response.body)["totalPrice"];
                      var orderItems = orderItemJson
                          .map((e) => OrderItemDto.fromJson(e))
                          .toList();
                      context.read<CartProvider>().clearCart();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderConfirmPage(
                              order: order,
                              orderItems: orderItems,
                              totalPrice: totalPrice,
                            ),
                          ));
                    } else if (response.statusCode == HttpStatus.unauthorized) {
                      await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                                content: const Text('로그인이 만료 되었습니다.'),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        "확인",
                                        textAlign: TextAlign.right,
                                      ))
                                ]);
                          });
                      Navigator.pushReplacementNamed(context, '/login');
                      store.remove('.AspNetCore.Session');
                    }
                  } else {
                    var orderItemForms = [
                      OrderItemForm(widget.item!.itemId,
                          widget.item!.totalPrice, widget.item!.orderQuantity)
                    ];
                    var response = await http.post(uri,
                        headers: {
                          'Cookie': '.AspNetCore.Session=$sessionId',
                          'Content-Type': 'application/json; charset=UTF-8',
                        },
                        body: jsonEncode(OrderForm(widget.loginMember.memberId,
                                orderItemForms, widget.loginMember.address)
                            .toJson()));
                    if (response.statusCode == HttpStatus.ok) {
                      var order =
                          Order.fromJson(jsonDecode(response.body)["order"]);
                      var orderItemJson =
                          jsonDecode(response.body)["orderItemDtos"] as List;
                      var totalPrice = jsonDecode(response.body)["totalPrice"];
                      var orderItems = orderItemJson
                          .map((e) => OrderItemDto.fromJson(e))
                          .toList();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderConfirmPage(
                              order: order,
                              orderItems: orderItems,
                              totalPrice: totalPrice,
                            ),
                          ));
                    } else if (response.statusCode == HttpStatus.unauthorized) {
                      await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                                content: const Text('로그인이 만료 되었습니다.'),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        "확인",
                                        textAlign: TextAlign.right,
                                      ))
                                ]);
                          });
                      Navigator.pushReplacementNamed(context, '/login');
                      store.remove('.AspNetCore.Session');
                    }
                  }
                },
                style: const ButtonStyle(
                    backgroundColor:
                        WidgetStatePropertyAll<Color>(Colors.indigoAccent),
                    shape:
                        WidgetStatePropertyAll<OutlinedBorder>(LinearBorder())),
                child: const SizedBox(
                    height: 50,
                    child: Center(
                        child: Text(
                      '결제하기',
                      style: TextStyle(fontSize: 18),
                    )))),
            const SizedBox(
              height: 12,
            )
          ],
        ),
      ),
    );
  }
}
