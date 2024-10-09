import 'package:flutter/material.dart';
import 'package:market/provider/cart_provider.dart';
import 'package:market/provider/widget_provider.dart';
import 'package:market/widget/cart_page.dart';
import 'package:provider/provider.dart';

class MyBottomNavigationBar extends StatelessWidget {
  const MyBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
        const BottomNavigationBarItem(icon: Icon(Icons.menu, size: 30), label: 'menu'),
        const BottomNavigationBarItem(icon: Icon(Icons.search, size: 30), label: 'search'),
        const BottomNavigationBarItem(icon: Icon(Icons.home, size: 30), label: 'home'),
        const BottomNavigationBarItem(
            icon: Icon(Icons.account_box, size: 30), label: 'account'),
        BottomNavigationBarItem(
            icon: context.watch<CartProvider>().cart.isEmpty
                ? const Icon(Icons.shopping_cart_rounded, size: 30,)
                : Stack(
              alignment: Alignment.bottomRight,
                    children: [
                      const Icon(Icons.shopping_cart_rounded, size: 30),
                      CircleAvatar(
                        backgroundColor: Colors.red,
                        radius: 10,
                        child: Text(
                          context.watch<CartProvider>().cart.length.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
            label: 'cart'),
      ],
      showSelectedLabels: false,
      selectedItemColor: Colors.blue,
      currentIndex: context.watch<WidgetProvider>().selectedIndex,
      onTap: (value) {
        context.read<WidgetProvider>().onTap(value);
        if (value == 4) {
          Navigator.push(context,
              MaterialPageRoute(
                  builder: (context) => const CartPage()));
        }
      },
      showUnselectedLabels: false,
      unselectedItemColor: Colors.black,
    );
  }
}
