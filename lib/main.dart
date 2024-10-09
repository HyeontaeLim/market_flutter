
import 'package:flutter/material.dart';
import 'package:market/login/login_page.dart';
import 'package:market/login/register_page.dart';
import 'package:market/provider/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'domain/search_con.dart';
import 'widget/home.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => CartProvider())
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: MaterialApp(home: InitPage(), routes: {
        '/login': (context) => LoginPage(),
        '/main': (context) => Home(searchCon: SearchCon(null, false, null),),
        '/register': (context) => RegisterPage()
      }),
    );
  }
}

class InitPage extends StatefulWidget {
  const InitPage({super.key});

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  @override
  void initState() {
    _checkLogin().then((session){
      if (session != null) {
        Navigator.pushReplacementNamed(context, "/main");
      } else{
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  Future<String?> _checkLogin() async {
    var store = await SharedPreferences.getInstance();
    String? session = store.getString(".AspNetCore.Session");
    return session;
  }

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator();
  }
}
