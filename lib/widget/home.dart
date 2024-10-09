import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:market/domain/item_dto.dart';
import 'package:market/domain/search_con.dart';
import 'package:market/widget/item_page.dart';
import 'package:http/http.dart' as http;
import 'package:market/widget/filter_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/cart_provider.dart';
import 'cart_page.dart';

class Home extends StatefulWidget {
  final SearchCon searchCon;
  List<ItemDto> _itemList = [];
  var _page = 1;
  final int _pageSize = 10;

  Home({super.key, required this.searchCon});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    if (widget.searchCon!.keyword != null &&
        widget.searchCon!.keyword!.isNotEmpty) {
      getFilteredItems();
      _scroll.addListener(
        () {
          if (_scroll.position.pixels == _scroll.position.maxScrollExtent) {
            print("추가");
            setState(() {
              widget._page++;
            });
            getFilteredItems();
          }
          ;
        },
      );
    } else if (widget.searchCon.status! ||
        (widget.searchCon!.categoryId != null &&
            widget.searchCon!.categoryId!.isNotEmpty)) {
      getFilteredItems();
      _scroll.addListener(
        () {
          if (_scroll.position.pixels == _scroll.position.maxScrollExtent) {
            print("추가");
            setState(() {
              widget._page++;
            });
            getFilteredItems();
          }
          ;
        },
      );
    } else {
      getItems();
      _scroll.addListener(
        () {
          if (_scroll.position.pixels == _scroll.position.maxScrollExtent) {
            print("추가");
            setState(() {
              widget._page++;
            });
            getItems();
          }
          ;
        },
      );
    }
  }
  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Market"),
        actions: [          IconButton(
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Transform.scale(
                      scale: 1.2,
                      child: Checkbox(
                        value: widget.searchCon.status,
                        onChanged: (value) {
                          var searchCon =
                              SearchCon(widget.searchCon.keyword, value, widget.searchCon.categoryId);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Home(
                                  searchCon: searchCon,
                                ),
                              ));
                        },
                      ),
                    ),
                    const Icon(Icons.rocket),
                    const Text(
                      '로켓',
                      style: TextStyle(
                          color: Colors.blue,
                          fontStyle: FontStyle.italic,
                          fontSize: Checkbox.width,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                FilledButton(
                    onPressed: () {
                      var searchCon = SearchCon(null, widget.searchCon.status, widget.searchCon.categoryId);
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return FilterPage(searchCon: searchCon,);
                        },
                      ));
                    },
                    style: const ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll<Color>(Colors.indigoAccent),
                        shape: WidgetStatePropertyAll<OutlinedBorder>(
                            RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))))),
                    child: Container(
                      height: 37,
                      width: 70,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Icon(Icons.filter_list_alt), Text('필터')],
                      ),
                    ))
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () {},
                  child: const Row(
                    children: [Text('쿠팡 랭킹순'), Icon(Icons.arrow_drop_down)],
                  )),
              IconButton(onPressed: () {}, icon: const Icon(Icons.list))
            ],
          ),
          Flexible(
              child: AlignedGridView.count(
            controller: _scroll,
            itemBuilder: (c, i) {
              return GestureDetector(
                onLongPress: () async {
                  await deleteItem(widget._itemList[i].itemId, context);
                },
                onTap: widget._itemList[i].quantity != 0
                    ? () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ItemPage(
                                      selectedItem: widget._itemList[i],
                                    )));
                      }
                    : null,
                child: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AspectRatio(
                            aspectRatio: 1.0,
                            child: Image.network(
                              "http://10.0.2.2:5012${widget._itemList[i].img}",
                              fit: BoxFit.contain,
                            ),
                          ),
                          Text(
                            widget._itemList[i].itemName,
                            style: const TextStyle(fontSize: 18),
                          ),
                          Wrap(
                            spacing: 8,
                            runSpacing: 3,
                            direction: Axis.horizontal,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                  "${NumberFormat('#,###').format(widget._itemList[i].price)}원",
                                  style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold)),
                              widget._itemList[i].status
                                  ? const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.rocket_launch,
                                          color: Colors.blue,
                                          size: 18,
                                        ),
                                        Text("로켓배송",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue))
                                      ],
                                    )
                                  : Container(),
                            ],
                          ),
                          widget._itemList[i].quantity != 0
                              ? Container()
                              : const Text("재고없음"),
                        ],
                      ),
                    ),
                    if (widget._itemList[i].quantity == 0)
                      Positioned.fill(
                          child: Container(color: Colors.grey.withOpacity(0.4)))
                  ],
                ),
              );
            },
            itemCount: widget._itemList.length,
            crossAxisCount: 2,
          ))
        ],
      ),
    );
  }

  getItems() async {
    var store = await SharedPreferences.getInstance();
    String? sessionId = store.getString('.AspNetCore.Session');
    var url = Uri.http("10.0.2.2:5012", "/items",
        {'page': '${widget._page}', 'pageSize': '${widget._pageSize}'});
    var response = await http
        .get(url, headers: {'Cookie': '.AspNetCore.Session=$sessionId'});
    if (response.statusCode == HttpStatus.ok) {
      List<dynamic> parsedBody = jsonDecode(response.body);
      if (widget._page == 1) {
        setState(() {
          widget._itemList =
              parsedBody.map((itemJson) => ItemDto.fromJson(itemJson)).toList();
          if (parsedBody.length < 10) {
            setState(() {
              widget._page--;
            });
          }
        });
      } else {
        if (parsedBody.length < 10) {
          for (int i = widget._itemList.length - (widget._page - 1) * 10;
              i < parsedBody.length;
              i++) {
            setState(() {
              widget._itemList.add(ItemDto.fromJson(parsedBody[i]));
            });
          }
          widget._page--;
        } else {
          for (int i = widget._itemList.length - (widget._page - 1) * 10;
              i < parsedBody.length;
              i++) {
            setState(() {
              widget._itemList.add(ItemDto.fromJson(parsedBody[i]));
            });
          }
        }
      }
    } else if (response.statusCode == HttpStatus.unauthorized) {
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(content: const Text('로그인이 만료 되었습니다.'), actions: [
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

  getFilteredItems() async {
    var store = await SharedPreferences.getInstance();
    String? sessionId = store.getString('.AspNetCore.Session');
    var url = Uri.http("10.0.2.2:5012", "/items", {
      'page': '${widget._page}',
      'pageSize': '${widget._pageSize}',
      if (widget.searchCon!.keyword != null)
        'keyword': '${widget.searchCon!.keyword}',
      'status': '${widget.searchCon!.status}',
      if (widget.searchCon!.categoryId != null)
        'categoryId': widget.searchCon.categoryId!.map((e) => '$e',)
    });
    var response = await http
        .get(url, headers: {'Cookie': '.AspNetCore.Session=$sessionId'});
    if (response.statusCode == HttpStatus.ok) {
      List<dynamic> parsedBody = jsonDecode(response.body);
      if (widget._page == 1) {
        setState(() {
          widget._itemList =
              parsedBody.map((itemJson) => ItemDto.fromJson(itemJson)).toList();
        });
        if (parsedBody.length < 10) {
          setState(() {
            widget._page--;
          });
        }
      } else {
        if (parsedBody.length < 10) {
          for (int i = widget._itemList.length - (widget._page - 1) * 10;
              i < parsedBody.length;
              i++) {
            setState(() {
              widget._itemList.add(ItemDto.fromJson(parsedBody[i]));
            });
          }
          setState(() {
            widget._page--;
          });
        } else {
          for (int i = widget._itemList.length - (widget._page - 1) * 10;
              i < parsedBody.length;
              i++) {
            setState(() {
              widget._itemList.add(ItemDto.fromJson(parsedBody[i]));
            });
          }
        }
      }
    } else if (response.statusCode == HttpStatus.unauthorized) {
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(content: const Text('로그인이 만료 되었습니다.'), actions: [
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

  deleteItem(int id, BuildContext context) async {
    var store = await SharedPreferences.getInstance();
    String? sessionId = store.getString('.AspNetCore.Session');
    var url = Uri.http("10.0.2.2:5012", "/item/$id");
    var res = await http
        .delete(url, headers: {'Cookie': '.AspNetCore.Session=$sessionId'});
    if (res.statusCode == HttpStatus.ok) {
      setState(() {
        widget._itemList.removeWhere((element) => element.itemId == id);
      });
    } else if (res.statusCode == HttpStatus.unauthorized) {
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(content: const Text('로그인이 만료 되었습니다.'), actions: [
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
}
