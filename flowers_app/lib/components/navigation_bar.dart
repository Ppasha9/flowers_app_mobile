import 'package:flowers_app/screens/account/signin.dart';
import 'package:flowers_app/screens/cart/cart.dart';
import 'package:flowers_app/screens/catalog/catalog.dart';
import 'package:flowers_app/screens/home/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

List<BottomNavigationBarItem> getNavBarItems(BuildContext context) {
  return <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.home_filled),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.category_sharp),
      label: 'Catalog',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.add_shopping_cart),
      label: 'Cart',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.favorite),
      label: 'Liked',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.account_box),
      label: 'Account',
    ),
  ];
}

Widget getNavigationBar(BuildContext context) {
  return Container(
    height: MediaQuery.of(context).size.height / 12,
    child: BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      unselectedItemColor: Color(0xFF754831),
      selectedItemColor: Color(0xFF754831),
      backgroundColor: Color(0xFFFFFFFF),
      items: getNavBarItems(context),
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => HomeScreen(),
              ),
            );
            break;
          case 1:
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => CatalogScreen(),
              ),
            );
            break;
          case 2:
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => CartScreen(),
              ),
            );
            break;
          case 4:
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => SigninScreen(),
              ),
            );
            break;
        }
      },
    ),
  );
}
