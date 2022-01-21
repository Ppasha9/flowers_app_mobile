import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orlove_app/constants.dart';
import 'package:orlove_app/screens/cart/cart_card.dart';
import 'package:orlove_app/screens/products_by_category/filter_screen.dart';

Widget getAppBar(BuildContext context, {bool hasFilters: false}) {
  final mediaQuery = MediaQuery.of(context);
  return AppBar(
    backgroundColor: ProjectConstants.BACKGROUND_SCREEN_COLOR,
    title: Container(
      width: mediaQuery.size.width / 2,
      height: 60,
      child: Image.asset("assets/images/orlove_appbar_text.png"),
    ),
    actions: [
      CartIconWidget(),
    ],
    leading: hasFilters
        ? GestureDetector(
            onTap: () {},
            child: Icon(
              Icons.format_list_bulleted_sharp,
              color: ProjectConstants.APP_FONT_COLOR,
            ),
          )
        : Container(),
  );
}
