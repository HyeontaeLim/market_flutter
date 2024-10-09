import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../domain/order.dart';

class OrderConfirmPage extends StatefulWidget {
  final Order order;
  final List<OrderItemDto> orderItems;
  final int totalPrice;

  const OrderConfirmPage(
      {super.key,
      required this.order,
      required this.orderItems,
      required this.totalPrice});

  @override
  State<OrderConfirmPage> createState() => _OrderConfirmPageState();
}

class _OrderConfirmPageState extends State<OrderConfirmPage> {
  bool isOpened = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('주문 완료')),
      body: Container(
        color: Colors.black12,
        child: ListView(
          children: [
            Card.outlined(
              shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(3)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    const Text(
                      "주문완료 되었습니다.",
                      style: TextStyle(fontSize: 25),
                    ),
                    const Divider(
                      height: 30,
                    ),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      titleAlignment: ListTileTitleAlignment.top,
                      leading: const SizedBox(
                        width: 80,
                        child: Text(
                          '배송지',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      title: Text(widget.order.address,
                          style: const TextStyle(fontSize: 18)),
                    ),
                    const Divider(
                      height: 30,
                    ),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      leading: const SizedBox(
                        width: 80,
                        child: Text(
                          '주문번호',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      title: Text(widget.order.orderNum,
                          style: const TextStyle(fontSize: 18)),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  isOpened = !isOpened;
                });
              },
              child: Card.outlined(
                shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(3)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ExpansionTile(
                    onExpansionChanged: (value) {
                      setState(() {
                        isOpened = value;
                      });
                    },
                    title: const Text(
                      '주문 금액',
                      style: TextStyle(fontSize: 18),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${NumberFormat('#,###').format(widget.totalPrice)}원',
                          style: const TextStyle(fontSize: 18),
                        ),
                        Icon(
                          isOpened
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          size: 30,
                        )
                      ],
                    ),
                    tilePadding: const EdgeInsets.all(8),
                        children: List.generate(
                          widget.orderItems.length,
                          (index) {
                            return ListTile(
                              title: Text(
                                  widget.orderItems[index].itemName),
                              subtitle: Text(
                                  '${widget.orderItems[index].count}개'),
                              trailing: Text(
                                '${NumberFormat('#,###').format(widget.orderItems[index].orderPrice)}원',
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal),
                              ),
                            );
                          },
                        ),
                      )
                    ,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
