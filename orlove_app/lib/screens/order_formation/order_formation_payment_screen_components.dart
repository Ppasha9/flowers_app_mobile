import 'package:bottom_loader/bottom_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orlove_app/constants.dart';
import 'package:orlove_app/http/cart_controller.dart';
import 'package:orlove_app/models/cart_model.dart';
import 'package:orlove_app/screens/components/bottom_loader.dart';
import 'package:orlove_app/screens/home/home_screen.dart';
import 'package:orlove_app/screens/order_formation/thank_for_order_screen.dart';
import 'package:orlove_app/utils/utils.dart';
import 'package:time_machine/time_machine.dart';
import 'package:provider/provider.dart';

class OrderFormationPaymentComponentsWidget extends StatefulWidget {
  @override
  _OrderFormationPaymentComponentsWidgetState createState() =>
      _OrderFormationPaymentComponentsWidgetState();
}

class _OrderFormationPaymentComponentsWidgetState
    extends State<OrderFormationPaymentComponentsWidget> {
  BottomLoader bottomLoader;

  bool _isOnlineSelected = false;
  bool _isCashSelected = true;

  CartFullInfoDTO curCartFullInfo = null;

  Future _onConfirmButtonPressed(
      BuildContext context, CartModel cartModel) async {
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

    if (!bottomLoader.isShowing()) {
      bottomLoader.display();
    }

    await CartController.updatePaymentInfo(_isCashSelected ? "cash" : "online");
    await CartController.increaseCartStatus();
    await CartController.createOrder();
    await cartModel.updateCartFullInfo();

    if (bottomLoader.isShowing()) {
      bottomLoader.close();
    }

    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (_) => ThankForOrderScreen(),
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

  num _getProductPriceWithParameters(ProductInCartDTO prInfo) {
    num res = prInfo.info["price"];
    var parameters = prInfo.parameters != null ? prInfo.parameters : [];
    for (ProductParameterDTO param in parameters) {
      if (param.parameterPrice != null) {
        res += param.parameterPrice;
      }
    }

    return res.round();
  }

  Widget _getProductParametersWidget(
      MediaQueryData mediaQuery, ProductInCartDTO prInfo) {
    List<ProductParameterDTO> parameters =
        prInfo.parameters != null ? prInfo.parameters : [];
    if (parameters == []) {
      return Container();
    }

    List<Widget> children = [];
    parameters.forEach((ProductParameterDTO el) {
      children.add(
        Container(
          child: Row(
            children: [
              Text(
                "${el.parameterName}: ${el.parameterValue} (+ ${el.parameterPrice.round()} Руб.)",
                style: TextStyle(
                  fontSize: 12 * mediaQuery.textScaleFactor,
                  fontFamily: ProjectConstants.APP_FONT_FAMILY,
                  color: ProjectConstants.APP_FONT_COLOR,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    });

    return Container(
      child: Column(
        children: children,
      ),
    );
  }

  Widget _getProductCardWidget(BuildContext context, ProductInCartDTO prInfo) {
    final mediaQuery = MediaQuery.of(context);

    return Container(
      height: mediaQuery.size.height * 0.15,
      margin: const EdgeInsets.symmetric(
        vertical: 5.0,
      ),
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
                      prInfo.info["pictures"][0]["url"],
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
                      "${Utils.fromUTF8(prInfo.info["name"])}\n${Utils.getPriceCorrectString(_getProductPriceWithParameters(prInfo))} Руб.",
                      style: TextStyle(
                        fontSize: 14 * mediaQuery.textScaleFactor,
                        fontFamily: ProjectConstants.APP_FONT_FAMILY,
                        color: ProjectConstants.APP_FONT_COLOR,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    _getProductParametersWidget(mediaQuery, prInfo),
                    Text(
                      "Кол-во: ${prInfo.amount}",
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
    List<ProductInCartDTO> productsInfosList = curCartFullInfo.products;

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
            "${curCartFullInfo.receiverSurname} ${curCartFullInfo.receiverName}",
            style: TextStyle(
              fontSize: 14 * mediaQuery.textScaleFactor,
              fontFamily: ProjectConstants.APP_FONT_FAMILY,
              color: ProjectConstants.APP_FONT_COLOR,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            "${curCartFullInfo.receiverPhone}",
            style: TextStyle(
              fontSize: 14 * mediaQuery.textScaleFactor,
              fontFamily: ProjectConstants.APP_FONT_FAMILY,
              color: ProjectConstants.APP_FONT_COLOR,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            "${curCartFullInfo.receiverEmail}",
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
    var dateTime = curCartFullInfo.deliveryDate != null
        ? curCartFullInfo.deliveryDate
        : DateTime.now();
    var date = OffsetDateTime(new LocalDateTime.dateTime(dateTime), Offset(3));

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            curCartFullInfo.deliveryMethod == "courier"
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
            curCartFullInfo.deliveryMethod == "courier"
                ? "${curCartFullInfo.receiverStreet}, д. ${curCartFullInfo.receiverHouseNum}, кв. ${curCartFullInfo.receiverApartmentNum}"
                : "Варшавская улица, д. 59",
            style: TextStyle(
              fontSize: 14 * mediaQuery.textScaleFactor,
              fontFamily: ProjectConstants.APP_FONT_FAMILY,
              color: ProjectConstants.APP_FONT_COLOR,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            "Дата: ${date.dayOfMonth}.${date.monthOfYear}.${date.year}",
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
    int cartPrice = curCartFullInfo.price.round();
    int shippmentPrice = curCartFullInfo.deliveryMethod == "courier" ? 300 : 0;

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
                "${Utils.getPriceCorrectString(cartPrice)} Руб.",
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
                "${Utils.getPriceCorrectString(cartPrice + shippmentPrice)} Руб.",
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
    bottomLoader = getBottomLoader(context);
    final mediaQuery = MediaQuery.of(context);
    CartModel cartModel = context.watch<CartModel>();
    cartModel.getCartFullInfo().then((value) {
      setState(() {
        curCartFullInfo = value;
      });
    });

    if (curCartFullInfo == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

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
        ),
        SizedBox(
          height: 20.0,
        ),
        GestureDetector(
          onTap: () => _onConfirmButtonPressed(context, cartModel),
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
