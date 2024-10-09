import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:market/domain/search_con.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/item_dto.dart';
import 'package:http/http.dart' as http;

class ItemProvider extends ChangeNotifier {
  List<ItemDto> _itemList = [];
  List<ItemDto> _filteredList = [];
  SearchCon? _searchCon;
  int page = 1;
  int filteredPage = 1;
  int pageSize = 10;

  getItems(BuildContext context) async {
    var store = await SharedPreferences.getInstance();
    String? sessionId = store.getString('.AspNetCore.Session');
    var url = Uri.http("10.0.2.2:5012", "/items",
        {'page': '${page}', 'pageSize': '${pageSize}'});
    var response = await http
        .get(url, headers: {'Cookie': '.AspNetCore.Session=$sessionId'});
    if (response.statusCode == HttpStatus.ok) {
      List<dynamic> parsedBody = jsonDecode(response.body);
      if (page == 1) {
        _itemList =
            parsedBody.map((itemJson) => ItemDto.fromJson(itemJson)).toList();
      } else {
        if (parsedBody.length < 10) {
          for (int i = _itemList.length - (page - 1) * 10;
              i < parsedBody.length;
              i++) {
            _itemList.add(ItemDto.fromJson(parsedBody[i]));
          }
          page--;
        } else {
          for (int i = _itemList.length - (page - 1) * 10;
              i < parsedBody.length;
              i++) {
            _itemList.add(ItemDto.fromJson(parsedBody[i]));
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
    notifyListeners();
  }

  getFilteredItems(BuildContext context) async {
    var store = await SharedPreferences.getInstance();
    String? sessionId = store.getString('.AspNetCore.Session');
    var url = Uri.http("10.0.2.2:5012", "/items", {
      'page': '${filteredPage}',
      'pageSize': '${pageSize}',
      if(_searchCon!.keyword != null) 'keyword': '${_searchCon!.keyword}',
      'status': '${_searchCon!.status}',
      if(_searchCon!.categoryId != null)'categoryId': '${_searchCon!.categoryId}'
    });
    var response = await http
        .get(url, headers: {'Cookie': '.AspNetCore.Session=$sessionId'});
    if (response.statusCode == HttpStatus.ok) {
      List<dynamic> parsedBody = jsonDecode(response.body);
      if (filteredPage == 1) {
        _filteredList =
            parsedBody.map((itemJson) => ItemDto.fromJson(itemJson)).toList();
        if(parsedBody.length < 10) {
          filteredPage--;
        }
      } else {
        if (parsedBody.length < 10) {
          for (int i = _filteredList.length - (filteredPage - 1) * 10;
              i < parsedBody.length;
              i++) {
            _filteredList.add(ItemDto.fromJson(parsedBody[i]));
          }
          filteredPage--;
        } else {
          for (int i = _filteredList.length - (filteredPage - 1) * 10;
              i < parsedBody.length;
              i++) {
            _filteredList.add(ItemDto.fromJson(parsedBody[i]));
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
    notifyListeners();
  }

  deleteItem(int id, BuildContext context) async {
    var store = await SharedPreferences.getInstance();
    String? sessionId = store.getString('.AspNetCore.Session');
    var url = Uri.http("10.0.2.2:5012", "/item/$id");
    var res = await http
        .delete(url, headers: {'Cookie': '.AspNetCore.Session=$sessionId'});
    if (res.statusCode == HttpStatus.ok) {
      _itemList.removeWhere((element) => element.itemId == id);
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
    notifyListeners();
  }

  void setSearchCon(SearchCon searchCon) {
    _searchCon = searchCon;
    notifyListeners();
  }

  void resetFilteredPage() {
    filteredPage = 1;
    notifyListeners();
  }

  void resetPage() {
    page = 1;
    notifyListeners();
  }

  void addPage() {
    page++;
    notifyListeners();
  }

  void addFilteredPage() {
    filteredPage++;
    notifyListeners();
  }

  void clearList() {
    _itemList.clear();
    notifyListeners();
  }

  void clearFilteredList() {
    _filteredList.clear();
    notifyListeners();
  }

  List<ItemDto> get itemList => _itemList;

  List<ItemDto> get filteredList => _filteredList;
}
