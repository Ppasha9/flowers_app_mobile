import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orlove_app/constants.dart';
import 'package:orlove_app/http/order_controller.dart';
import 'package:orlove_app/screens/account/orders/order_details_screen.dart';
import 'package:orlove_app/screens/components/app_bar.dart';
import 'package:orlove_app/screens/components/bottom_navigation_bar.dart';
import 'package:orlove_app/utils/utils.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool isLoaded = false;
  List<dynamic> orders;

  @override
  void initState() {
    OrderController.getOrders().then((value) {
      setState(() {
        orders = value["orders"];
        isLoaded = true;
      });
    });
    super.initState();
  }

  int _getNumOfProductsInOrder(dynamic orderData) {
    int res = 0;

    for (dynamic prInfo in orderData["products"]) {
      res += prInfo["amount"];
    }

    return res;
  }

  Widget _getOrderWidget(MediaQueryData mediaQuery, dynamic orderData) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        CupertinoPageRoute(
          builder: (_) => OrderDetailsScreen(
            id: orderData["id"],
          ),
        ),
      ),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(
            color: ProjectConstants.DEFAULT_STROKE_COLOR,
            width: 2.0,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 10.0,
        ),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Заказ №${orderData["id"]}",
                    style: TextStyle(
                      fontSize: 15 * mediaQuery.textScaleFactor,
                      fontFamily: ProjectConstants.APP_FONT_FAMILY,
                      fontWeight: FontWeight.w600,
                      color: ProjectConstants.APP_FONT_COLOR,
                    ),
                  ),
                  Container(
                    height: 25,
                    width: mediaQuery.size.width * 0.25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                      color: Utils.getStatusColor(orderData["status"]),
                    ),
                    child: Center(
                      child: Text(
                        Utils.getStatusText(orderData["status"]),
                        style: TextStyle(
                          fontSize: 11 * mediaQuery.textScaleFactor,
                          fontFamily: ProjectConstants.APP_FONT_FAMILY,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                "Кол-во букетов в заказе: ${_getNumOfProductsInOrder(orderData)}",
                style: TextStyle(
                  fontSize: 15 * mediaQuery.textScaleFactor,
                  fontFamily: ProjectConstants.APP_FONT_FAMILY,
                  fontWeight: FontWeight.normal,
                  color: ProjectConstants.APP_FONT_COLOR,
                ),
              ),
              Text(
                "${orderData["fullPrice"]} Руб.",
                style: TextStyle(
                  fontSize: 15 * mediaQuery.textScaleFactor,
                  fontFamily: ProjectConstants.APP_FONT_FAMILY,
                  fontWeight: FontWeight.w600,
                  color: ProjectConstants.APP_FONT_COLOR,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getOrdersListWidget(MediaQueryData mediaQuery) {
    return Column(
      children: orders
          .map(
            (e) => _getOrderWidget(mediaQuery, e),
          )
          .toList(),
    );
  }

  Widget _getBodyWidget(BuildContext context) {
    if (!isLoaded) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    final mediaQuery = MediaQuery.of(context);

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 10.0,
        ),
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
                      "Список заказов",
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
              height: 20.0,
            ),
            _getOrdersListWidget(mediaQuery),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ProjectConstants.BACKGROUND_SCREEN_COLOR,
        body: _getBodyWidget(context),
        appBar: getAppBar(context),
        bottomNavigationBar: getBottomNavigationBar(
          context,
          isAccount: true,
        ),
      ),
    );
  }
}
