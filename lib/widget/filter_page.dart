import 'package:flutter/material.dart';

import '../domain/search_con.dart';
import 'home.dart';

class FilterPage extends StatefulWidget {
  SearchCon searchCon;

  FilterPage({super.key, required this.searchCon});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  Map<int, String> category = {1: '식품', 2: '의류', 3: '가전제품', 4: '아동', 5: '도서'};
  late Map<int, bool> categoryBool;

  @override
  void initState() {
    super.initState();
    categoryBool = widget.searchCon.categoryId == null
        ? category.map((key, value) => MapEntry(key, false))
        : category.map(
            (key, value) => MapEntry(key, widget.searchCon.categoryId!.contains(key)),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
            onFieldSubmitted: (value) {
              widget.searchCon.categoryId = categoryBool.entries.where((element) => element.value).map((entry)=>entry.key).toSet();
              print(widget.searchCon.categoryId);
              var searchCon = SearchCon(value, widget.searchCon.status, widget.searchCon.categoryId);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Home(
                      searchCon: searchCon,
                    ),
                  ));
            },
            textInputAction: TextInputAction.search,
            decoration: const InputDecoration(
                isDense: true,
                hintText: '검색어 입력',
                border: OutlineInputBorder())),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 8.0,
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              '로켓',
              style: TextStyle(fontSize: 20),
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
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
                Transform.scale(
                  scale: 1.2,
                  child: Checkbox(
                    value: widget.searchCon.status,
                    onChanged: (value) {
                      setState(() {
                        widget.searchCon.status = value!;
                      });
                    },
                  ),
                )
              ],
            ),
          ),
          Divider(
            height: 8.0,
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              '카테고리',
              style: TextStyle(fontSize: 20),
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          Wrap(
            children: List.generate(categoryBool.length, (index) {
              return Container(
                margin: EdgeInsetsDirectional.symmetric(horizontal: 3.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: categoryBool[index + 1]!
                          ? WidgetStatePropertyAll(Colors.blue)
                          : WidgetStatePropertyAll(Colors.white)),
                  onPressed: () {
                    setState(() {
                      categoryBool[index + 1] = !categoryBool[index + 1]!;
                      print(categoryBool);
                    });
                  },
                  child: Text(
                    category[index + 1]!,
                    style: TextStyle(
                        color: categoryBool[index + 1]!
                            ? Colors.white
                            : Colors.black),
                  ), // 상태에 따른 텍스트 변경
                ),
              );
            }),
          )
        ],
      ),
    );
  }
}
