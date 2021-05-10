import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orlove_app/constants.dart';
import 'package:orlove_app/http/cart_controller.dart';
import 'package:orlove_app/screens/home/home_screen.dart';
import 'package:orlove_app/storage/storage.dart';
import 'package:orlove_app/utils/utils.dart';

class OrderFormationPaymentComponentsWidget extends StatefulWidget {
  @override
  _OrderFormationPaymentComponentsWidgetState createState() =>
      _OrderFormationPaymentComponentsWidgetState();
}

class _OrderFormationPaymentComponentsWidgetState
    extends State<OrderFormationPaymentComponentsWidget> {
  bool _isOnlineSelected = false;
  bool _isCashSelected = true;

  Future _onConfirmButtonPressed(BuildContext context) async {
    if (!_isOnlineSelected && !_isCashSelected) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Внимание!"),
          content: Text("Нужно обязательно выбрать способ оплаты!"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Окей"),
            ),
          ],
        ),
      );
      return;
    }

    await CartController.updatePaymentInfo(_isCashSelected ? "cash" : "online");
    await CartController.increaseCartStatus();
    await CartController.createOrder();
    await Utils.getAllCartInfo();

    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (_) => HomeScreen(),
      ),
    );
  }

  Widget _getOnlinePaymentWidget(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return GestureDetector(
      onTap: () {
        setState(
          () {
            _isOnlineSelected = !_isOnlineSelected;
            if (_isOnlineSelected && _isCashSelected) {
              _isCashSelected = !_isCashSelected;
            }
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 20.0,
        ),
        child: Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _isOnlineSelected
                      ? ProjectConstants.BUTTON_BACKGROUND_COLOR
                      : ProjectConstants.APP_FONT_COLOR,
                  width: 2.0,
                ),
                color: _isOnlineSelected
                    ? ProjectConstants.BUTTON_BACKGROUND_COLOR
                    : ProjectConstants.BACKGROUND_SCREEN_COLOR,
              ),
            ),
            SizedBox(
              width: 5.0,
            ),
            Text(
              "Банковской картой / Apple Pay",
              style: TextStyle(
                fontSize: 15 * mediaQuery.textScaleFactor,
                fontFamily: ProjectConstants.APP_FONT_FAMILY,
                color: ProjectConstants.APP_FONT_COLOR,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getCashPaymentWidget(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return GestureDetector(
      onTap: () {
        setState(
          () {
            _isCashSelected = !_isCashSelected;
            if (_isCashSelected && _isOnlineSelected) {
              _isOnlineSelected = !_isOnlineSelected;
            }
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 20.0,
        ),
        child: Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _isCashSelected
                      ? ProjectConstants.BUTTON_BACKGROUND_COLOR
                      : ProjectConstants.APP_FONT_COLOR,
                  width: 2.0,
                ),
                color: _isCashSelected
                    ? ProjectConstants.BUTTON_BACKGROUND_COLOR
                    : ProjectConstants.BACKGROUND_SCREEN_COLOR,
              ),
            ),
            SizedBox(
              width: 5.0,
            ),
            Text(
              "Наличными курьеру",
              style: TextStyle(
                fontSize: 15 * mediaQuery.textScaleFactor,
                fontFamily: ProjectConstants.APP_FONT_FAMILY,
                color: ProjectConstants.APP_FONT_COLOR,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
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

  Widget _getProductsListWidget(BuildContext context) {
    List<dynamic> productsInfosList =
        SecureStorage.cartFullInfo["allProducts"]["products"];

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20.0,
      ),
      child: Column(
        children: productsInfosList
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
            "${Utils.fromUTF8(SecureStorage.cartFullInfo["receiverSurname"])} ${Utils.fromUTF8(SecureStorage.cartFullInfo["receiverName"])}",
            style: TextStyle(
              fontSize: 14 * mediaQuery.textScaleFactor,
              fontFamily: ProjectConstants.APP_FONT_FAMILY,
              color: ProjectConstants.APP_FONT_COLOR,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            "${SecureStorage.cartFullInfo["receiverPhone"]}",
            style: TextStyle(
              fontSize: 14 * mediaQuery.textScaleFactor,
              fontFamily: ProjectConstants.APP_FONT_FAMILY,
              color: ProjectConstants.APP_FONT_COLOR,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            "${SecureStorage.cartFullInfo["receiverEmail"]}",
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
            SecureStorage.cartFullInfo["deliveryMethod"] == "courier"
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
            SecureStorage.cartFullInfo["deliveryMethod"] == "courier"
                ? "${Utils.fromUTF8(SecureStorage.cartFullInfo["receiverStreet"])}, д. ${SecureStorage.cartFullInfo["receiverHouseNum"]}, кв. ${SecureStorage.cartFullInfo["receiverApartmentNum"]}"
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
    double cartPrice = SecureStorage.cartFullInfo["price"];
    double shippmentPrice =
        SecureStorage.cartFullInfo["deliveryMethod"] == "courier" ? 300 : 0;

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

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10.0,
        ),
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          child: Text(
            "Выберите способ оплаты",
            style: TextStyle(
              fontSize: 18 * mediaQuery.textScaleFactor,
              fontFamily: ProjectConstants.APP_FONT_FAMILY,
              color: ProjectConstants.APP_FONT_COLOR,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        _getOnlinePaymentWidget(context),
        Divider(
          color: ProjectConstants.DEFAULT_STROKE_COLOR,
          thickness: 1.0,
          indent: 20.0,
          endIndent: 20.0,
        ),
        SizedBox(
          height: 5.0,
        ),
        _getCashPaymentWidget(context),
        SizedBox(
          height: 20.0,
        ),
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          child: Text(
            "Проверьте заказ",
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
        _getProductsListWidget(context),
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
        GestureDetector(
          onTap: () => _onConfirmButtonPressed(context),
          child: Center(
            child: Container(
              height: 50,
              width: mediaQuery.size.width / 1.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(1.0)),
                color: ProjectConstants.BUTTON_BACKGROUND_COLOR,
              ),
              child: Center(
                child: Text(
                  "Продолжить",
                  style: TextStyle(
                    fontSize: 18 * mediaQuery.textScaleFactor,
                    fontFamily: ProjectConstants.APP_FONT_FAMILY,
                    color: ProjectConstants.BUTTON_TEXT_COLOR,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
        Center(
          child: Text(
            "при подтверждении заказы, вы соглашаетесь с\nПолитикой конфиденциальности и с условиями публичной офертой",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: ProjectConstants.APP_FONT_FAMILY,
              fontSize: 10 * mediaQuery.textScaleFactor,
              color: ProjectConstants.APP_FONT_COLOR,
            ),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
      ],
    );
  }
}
