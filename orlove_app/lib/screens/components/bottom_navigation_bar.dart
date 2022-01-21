import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orlove_app/screens/account/account_screen.dart';
import 'package:orlove_app/screens/catalog/calatog_screen.dart';
import 'package:orlove_app/screens/favourite/favourite_screen.dart';
import 'package:orlove_app/screens/home/home_screen.dart';
import 'package:orlove_app/screens/signin/signin_screen.dart';
import 'package:orlove_app/storage/storage.dart';

Widget getBottomNavigationBar(
  BuildContext context, {
  bool isHome = false,
  bool isMenu = false,
  bool isFavourite = false,
  bool isAccount = false,
}) {
  return BottomNavigationBar(
    onTap: (index) {
      if (index == 0 && isHome) {
        return;
      } else if (index == 1 && isMenu) {
        return;
      } else if (index == 2 && isFavourite) {
        return;
      } else if (index == 3 && isAccount) {
        return;
      }

      switch (index) {
        case 0:
          Navigator.of(context).pushAndRemoveUntil(
            CupertinoPageRoute(
              builder: (_) => HomeScreen(),
            ),
            (route) => false,
          );
          break;

        case 1:
          Navigator.of(context).pushAndRemoveUntil(
            CupertinoPageRoute(
              builder: (_) => CatalogScreen(),
            ),
            (route) => false,
          );
          break;

        case 2:
          Navigator.of(context).pushAndRemoveUntil(
              CupertinoPageRoute(
                builder: (_) => FavouriteScreen(),
              ),
              (route) => false);
          break;

        case 3:
          Navigator.of(context).pushAndRemoveUntil(
            CupertinoPageRoute(
              builder: (_) => AccountScreen(),
            ),
            (route) => false,
          );
          break;
      }
    },
    backgroundColor: Colors.white,
    type: BottomNavigationBarType.fixed,
    iconSize: 28.0,
    showSelectedLabels: false,
    showUnselectedLabels: false,
    selectedFontSize: 14.0,
    unselectedFontSize: 14.0,
    items: [
      BottomNavigationBarItem(
        icon: Icon(
          Icons.home_outlined,
          color: Color(0xFF989797),
        ),
        label: "Главная",
      ),
      BottomNavigationBarItem(
        icon: Icon(
          Icons.category_outlined,
          color: Color(0xFF989797),
        ),
        label: "Каталог",
      ),
      BottomNavigationBarItem(
        icon: Icon(
          Icons.favorite,
          color: Color(0xFFFFB9C2),
        ),
        label: "Избранные",
      ),
      BottomNavigationBarItem(
        icon: Icon(
          Icons.account_circle_outlined,
          color: Color(0xFF989797),
        ),
        label: "Профиль",
      ),
    ],
  );
}
