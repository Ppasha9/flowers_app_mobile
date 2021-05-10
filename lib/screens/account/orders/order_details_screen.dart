import 'package:flutter/material.dart';
import 'package:orlove_app/constants.dart';
import 'package:orlove_app/http/order_controller.dart';
import 'package:orlove_app/screens/components/app_bar.dart';
import 'package:orlove_app/screens/components/bottom_navigation_bar.dart';
import 'package:orlove_app/utils/utils.dart';

class OrderDetailsScreen extends StatefulWidget {
  final int id;

  const OrderDetailsScreen({this.id});

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  bool isLoaded = false;
  dynamic orderFullInfo;

  @override
  void initState() {
    OrderController.getOrderDetails(widget.id).then((value) {
      setState(() {
        orderFullInfo = value;
        isLoaded = true;
      });
    });
    super.initState();
  }

  Widget _getProductCardWidget(BuildContext context, dynamic prInfo) {
    final mediaQuery = MediaQuery.of(context);

    return Container(
      height: mediaQuery.size.height * 0.15,
      child: LayoutBuilder(
        builder: (ctx, constraints) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: constraints.maxWidth * 0.30,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      prInfo["info"]["pictures"][0]["url"],
                    ),
                    fit: BoxFit.fill,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 5.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${Utils.fromUTF8(prInfo["info"]["name"])}\n${prInfo["info"]["price"]} Руб.",
                      style: TextStyle(
                        fontSize: 14 * mediaQuery.textScaleFactor,
                        fontFamily: ProjectConstants.APP_FONT_FAMILY,
                        color: ProjectConstants.APP_FONT_COLOR,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "Кол-во: ${prInfo["amount"]}",
                      style: TextStyle(
                        fontSize: 14 * mediaQuery.textScaleFactor,
                        fontFamily: ProjectConstants.APP_FONT_FAMILY,
                        color: ProjectConstants.APP_FONT_COLOR,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _getProductsListWidget(BuildContext context, List<dynamic> products) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20.0,
      ),
      child: Column(
        children: products
            .map(
              (e) => _getProductCardWidget(context, e),
            )
            .toList(),
      ),
    );
  }

  Widget _getReceiverInfoWidget(MediaQueryData mediaQuery) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${Utils.fromUTF8(orderFullInfo["receiverSurname"])} ${Utils.fromUTF8(orderFullInfo["receiverName"])}",
            style: TextStyle(
              fontSize: 14 * mediaQuery.textScaleFactor,
              fontFamily: ProjectConstants.APP_FONT_FAMILY,
              color: ProjectConstants.APP_FONT_COLOR,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            "${orderFullInfo["receiverPhone"]}",
            style: TextStyle(
              fontSize: 14 * mediaQuery.textScaleFactor,
              fontFamily: ProjectConstants.APP_FONT_FAMILY,
              color: ProjectConstants.APP_FONT_COLOR,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            "${orderFullInfo["receiverEmail"]}",
            style: TextStyle(
              fontSize: 14 * mediaQuery.textScaleFactor,
              fontFamily: ProjectConstants.APP_FONT_FAMILY,
              color: ProjectConstants.APP_FONT_COLOR,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getDeliveryInfoWidget(MediaQueryData mediaQuery) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            orderFullInfo["deliveryMethod"] == "courier"
                ? "Курьером"
                : "Самовывоз",
            style: TextStyle(
              fontSize: 14 * mediaQuery.textScaleFactor,
              fontFamily: ProjectConstants.APP_FONT_FAMILY,
              color: ProjectConstants.APP_FONT_COLOR,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            orderFullInfo["deliveryMethod"] == "courier"
                ? "${Utils.fromUTF8(orderFullInfo["receiverStreet"])}, д. ${orderFullInfo["receiverHouseNum"]}, кв. ${orderFullInfo["receiverApartmentNum"]}"
                : "Варшавская улица, д. 59",
            style: TextStyle(
              fontSize: 14 * mediaQuery.textScaleFactor,
              fontFamily: ProjectConstants.APP_FONT_FAMILY,
              color: ProjectConstants.APP_FONT_COLOR,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getFinalPriceWidget(MediaQueryData mediaQuery) {
    double cartPrice = orderFullInfo["price"];
    double shippmentPrice =
        orderFullInfo["deliveryMethod"] == "courier" ? 300 : 0;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Общая стоимость",
                style: TextStyle(
                  fontSize: 14 * mediaQuery.textScaleFactor,
                  fontFamily: ProjectConstants.APP_FONT_FAMILY,
                  color: ProjectConstants.APP_FONT_COLOR,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "$cartPrice Руб.",
                style: TextStyle(
                  fontSize: 14 * mediaQuery.textScaleFactor,
                  fontFamily: ProjectConstants.APP_FONT_FAMILY,
                  color: ProjectConstants.APP_FONT_COLOR,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Доставка",
                style: TextStyle(
                  fontSize: 14 * mediaQuery.textScaleFactor,
                  fontFamily: ProjectConstants.APP_FONT_FAMILY,
                  color: ProjectConstants.APP_FONT_COLOR,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "$shippmentPrice Руб.",
                style: TextStyle(
                  fontSize: 14 * mediaQuery.textScaleFactor,
                  fontFamily: ProjectConstants.APP_FONT_FAMILY,
                  color: ProjectConstants.APP_FONT_COLOR,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Итого к оплате",
                style: TextStyle(
                  fontSize: 14 * mediaQuery.textScaleFactor,
                  fontFamily: ProjectConstants.APP_FONT_FAMILY,
                  color: ProjectConstants.APP_FONT_COLOR,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "${cartPrice + shippmentPrice} Руб.",
                style: TextStyle(
                  fontSize: 14 * mediaQuery.textScaleFactor,
                  fontFamily: ProjectConstants.APP_FONT_FAMILY,
                  color: ProjectConstants.APP_FONT_COLOR,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10.0,
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 10.0,
            ),
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    top: 10.0,
                  ),
                  width: mediaQuery.size.width,
                  child: Center(
                    child: Text(
                      "Заказ №${widget.id}",
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
          ),
          Center(
            child: Container(
              height: 25,
              width: mediaQuery.size.width * 0.25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
                color: Utils.getStatusColor(orderFullInfo["status"]),
              ),
              child: Center(
                child: Text(
                  Utils.getStatusText(orderFullInfo["status"]),
                  style: TextStyle(
                    fontSize: 11 * mediaQuery.textScaleFactor,
                    fontFamily: ProjectConstants.APP_FONT_FAMILY,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Divider(
            thickness: 2.0,
            color: ProjectConstants.DEFAULT_STROKE_COLOR,
          ),
          SizedBox(
            height: 5.0,
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 10.0,
            ),
            child: Text(
              "Состав заказа",
              style: TextStyle(
                fontSize: 18 * mediaQuery.textScaleFactor,
                fontFamily: ProjectConstants.APP_FONT_FAMILY,
                color: ProjectConstants.APP_FONT_COLOR,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          _getProductsListWidget(
            context,
            orderFullInfo["products"],
          ),
          SizedBox(
            height: 5.0,
          ),
          Divider(
            thickness: 2.0,
            color: ProjectConstants.DEFAULT_STROKE_COLOR,
          ),
          SizedBox(
            height: 5.0,
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 10.0,
            ),
            child: Text(
              "Получатель",
              style: TextStyle(
                fontSize: 18 * mediaQuery.textScaleFactor,
                fontFamily: ProjectConstants.APP_FONT_FAMILY,
                color: ProjectConstants.APP_FONT_COLOR,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          _getReceiverInfoWidget(mediaQuery),
          SizedBox(
            height: 5.0,
          ),
          Divider(
            thickness: 2.0,
            color: ProjectConstants.DEFAULT_STROKE_COLOR,
          ),
          SizedBox(
            height: 5.0,
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 10.0,
            ),
            child: Text(
              "Способ доставки",
              style: TextStyle(
                fontSize: 18 * mediaQuery.textScaleFactor,
                fontFamily: ProjectConstants.APP_FONT_FAMILY,
                color: ProjectConstants.APP_FONT_COLOR,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          _getDeliveryInfoWidget(mediaQuery),
          SizedBox(
            height: 5.0,
          ),
          Divider(
            thickness: 2.0,
            color: ProjectConstants.DEFAULT_STROKE_COLOR,
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 10.0,
            ),
            child: Text(
              "Способ оплаты",
              style: TextStyle(
                fontSize: 18 * mediaQuery.textScaleFactor,
                fontFamily: ProjectConstants.APP_FONT_FAMILY,
                color: ProjectConstants.APP_FONT_COLOR,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 20.0,
            ),
            child: Text(
              orderFullInfo["paymenyMethod"] == "online"
                  ? "Картой онлайн"
                  : "Наличными курьеру",
              style: TextStyle(
                fontSize: 14 * mediaQuery.textScaleFactor,
                fontFamily: ProjectConstants.APP_FONT_FAMILY,
                color: ProjectConstants.APP_FONT_COLOR,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Divider(
            thickness: 2.0,
            color: ProjectConstants.DEFAULT_STROKE_COLOR,
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 10.0,
            ),
            child: Text(
              "Финальная стоимость",
              style: TextStyle(
                fontSize: 18 * mediaQuery.textScaleFactor,
                fontFamily: ProjectConstants.APP_FONT_FAMILY,
                color: ProjectConstants.APP_FONT_COLOR,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Divider(
            thickness: 2.0,
            color: ProjectConstants.DEFAULT_STROKE_COLOR,
          ),
          SizedBox(
            height: 5.0,
          ),
          _getFinalPriceWidget(mediaQuery),
          SizedBox(
            height: 5.0,
          ),
          Divider(
            thickness: 2.0,
            color: ProjectConstants.DEFAULT_STROKE_COLOR,
          ),
          SizedBox(
            height: 20.0,
          ),
        ],
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
