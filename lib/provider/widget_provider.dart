import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:market/domain/search_con.dart';
import 'package:market/widget/cart_page.dart';
import 'package:market/widget/search_page.dart';

import '../widget/home.dart';

class WidgetProvider extends ChangeNotifier {
  int _selectedIndex = 2;

  int get selectedIndex => _selectedIndex;


  set selectedIndex(int value) {
    _selectedIndex = value;
    notifyListeners();
  }

  List<Widget> widgetOption(BuildContext context) {
    return <Widget>[
      Home(
        searchCon: SearchCon(null, false, null),
      ),
      SearchPage(),
      Home(
        searchCon: SearchCon(null, false, null),
      ),
      Center(child: Text('3')),
      CartPage()
    ];
  }

  void onTap(index) {
    if (index != 4) {
      _selectedIndex = index;
      notifyListeners();
    }
  }
}
