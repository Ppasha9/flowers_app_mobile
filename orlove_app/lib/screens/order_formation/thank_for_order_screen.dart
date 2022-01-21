import 'package:flutter/material.dart';
import 'package:orlove_app/constants.dart';
import 'package:orlove_app/screens/components/app_bar.dart';
import 'package:orlove_app/screens/components/bottom_navigation_bar.dart';

class ThankForOrderScreen extends StatelessWidget {
  Widget _getBodyWidget(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            "Спасибо!",
            style: TextStyle(
              fontSize: 18 * mediaQuery.textScaleFactor,
              fontFamily: ProjectConstants.APP_FONT_FAMILY,
              fontWeight: FontWeight.bold,
              color: ProjectConstants.APP_FONT_COLOR,
            ),
          ),
          Text(
            "Ваш заказа передан на обработку.",
            style: TextStyle(
              fontSize: 15 * mediaQuery.textScaleFactor,
              fontFamily: ProjectConstants.APP_FONT_FAMILY,
              fontWeight: FontWeight.w600,
              color: ProjectConstants.APP_FONT_COLOR,
            ),
          ),
          Text(
            "Статус заказов можете посмотреть в личном кабинете",
            style: TextStyle(
              fontSize: 15 * mediaQuery.textScaleFactor,
              fontFamily: ProjectConstants.APP_FONT_FAMILY,
              fontWeight: FontWeight.w600,
              color: ProjectConstants.APP_FONT_COLOR,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProjectConstants.BACKGROUND_SCREEN_COLOR,
      body: _getBodyWidget(context),
      appBar: getAppBar(context),
      bottomNavigationBar: getBottomNavigationBar(context),
    );
  }
}
