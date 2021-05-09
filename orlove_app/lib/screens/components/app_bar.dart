import 'package:flutter/material.dart';
import 'package:orlove_app/constants.dart';
import 'package:orlove_app/screens/cart/cart_card.dart';

Widget getAppBar(BuildContext context) {
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
  );
}
