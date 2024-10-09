import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:market/domain/search_con.dart';
import 'home.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
            onFieldSubmitted: (value) {
              var searchCon = SearchCon(value, false, null);
              Navigator.push(
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
    );
  }
}
