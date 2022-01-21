import 'package:flutter/material.dart';
import 'package:orlove_app/constants.dart';
import 'package:orlove_app/screens/components/app_bar.dart';
import 'package:orlove_app/screens/order_formation/order_formation_shippment_screen_components.dart';

class OrderFormationShippmentScreen extends StatelessWidget {
  Widget _getUpperContainer(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(5.0),
          bottomRight: Radius.circular(5.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.8),
            spreadRadius: 1.0,
            blurRadius: 5.0,
          ),
        ],
        color: ProjectConstants.BACKGROUND_SCREEN_COLOR,
      ),
      margin: const EdgeInsets.only(
        bottom: 10.0,
      ),
      height: 85,
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 10.0,
                ),
                width: mediaQuery.size.width,
                child: Center(
                  child: Text(
                    "Оформление заказа",
                    style: TextStyle(
                      fontSize: 18 * mediaQuery.textScaleFactor,
                      fontFamily: ProjectConstants.APP_FONT_FAMILY,
                      fontWeight: FontWeight.w600,
                      color: ProjectConstants.APP_FONT_COLOR,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  left: 10.0,
                ),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: ProjectConstants.APP_FONT_COLOR,
                    size: 35.0,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5.0,
          ),
          Stack(
            children: [
              Container(
                child: Divider(
                  color: Color(0xFFEDEDED),
                  thickness: 5.0,
                  indent: 30.0,
                  endIndent: 30.0,
                ),
              ),
              Container(
                child: Divider(
                  color: Color(0xFFFFB9C2),
                  thickness: 5.0,
                  indent: 30.0,
                  endIndent: mediaQuery.size.width / 2,
                ),
              ),
            ],
          ),
          Stack(
            children: [
              Container(
                width: mediaQuery.size.width,
                child: Center(
                  child: Text(
                    "доставка",
                    style: TextStyle(
                      fontSize: 12 * mediaQuery.textScaleFactor,
                      fontFamily: ProjectConstants.APP_FONT_FAMILY,
                      fontWeight: FontWeight.w600,
                      color: ProjectConstants.APP_FONT_COLOR,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  left: 5.0,
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  "получатель",
                  style: TextStyle(
                    fontSize: 12 * mediaQuery.textScaleFactor,
                    fontFamily: ProjectConstants.APP_FONT_FAMILY,
                    fontWeight: FontWeight.w600,
                    color: ProjectConstants.APP_FONT_COLOR,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  right: 5.0,
                ),
                alignment: Alignment.centerRight,
                child: Text(
                  "оплата",
                  style: TextStyle(
                    fontSize: 12 * mediaQuery.textScaleFactor,
                    fontFamily: ProjectConstants.APP_FONT_FAMILY,
                    fontWeight: FontWeight.w600,
                    color: ProjectConstants.APP_FONT_COLOR,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getBodyWidget(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            _getUpperContainer(context),
            OrderFormationShippmentComponentsWidget(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProjectConstants.BACKGROUND_SCREEN_COLOR,
      body: _getBodyWidget(context),
      appBar: getAppBar(context),
    );
  }
}
