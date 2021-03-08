import 'package:flowers_app/common/utils.dart';
import 'package:flowers_app/rest_api/rest_api_cart.dart';
import 'package:flowers_app/screens/account/account.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class PaymentFormationScreen extends StatefulWidget {
  @override
  _PaymentFormationScreenState createState() => _PaymentFormationScreenState();
}

class _PaymentFormationScreenState extends State<PaymentFormationScreen> {
  bool _isLoaded = false;
  dynamic _cartFullInfo;

  bool _isOnlineSelected = false;
  bool _isCashSelected = false;

  Future<dynamic> _fetchCartFullInfo() async {
    return await CartService.getCartFullInfo();
  }

  @override
  void initState() {
    super.initState();

    _fetchCartFullInfo().then((value) {
      setState(() {
        _cartFullInfo = value;
        _isLoaded = true;
      });
    });
  }

  Widget _getAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize:
          Size(double.infinity, MediaQuery.of(context).size.height / 7),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 10.0,
            ),
          ],
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 7,
        child: Container(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Color(0xFF754831),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        right: MediaQuery.of(context).size.width / 5),
                    child: Center(
                      child: Text(
                        'Оформление заказа',
                        style: TextStyle(
                          fontSize: 25,
                          color: Color(0xFFB1ADAD),
                          fontFamily: 'Book Antiqua',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 9),
                child: Divider(
                  color: Color(0xFF242424),
                  thickness: 1.0,
                ),
              ),
              Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width / 30),
                    child: Text(
                      'Получатель',
                      style: TextStyle(
                        color: Color(0xFF9E9E9E),
                        fontSize: 13,
                        fontFamily: 'Book Antiqua Bold',
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width / 4.5),
                    child: Text(
                      'Доставка',
                      style: TextStyle(
                        color: Color(0xFF9E9E9E),
                        fontSize: 13,
                        fontFamily: 'Book Antiqua Bold',
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width / 40),
                    child: Text(
                      'Оплата',
                      style: TextStyle(
                        color: Color(0xFF9E9E9E),
                        fontSize: 13,
                        fontFamily: 'Book Antiqua Bold',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getCheckableOnlineWidget(context) {
    List<Widget> children = [
      Container(
        margin: EdgeInsets.only(left: 5.0, right: 5.0),
        child: Icon(
          Icons.credit_card_rounded,
          color: Color(0xFF754831),
        ),
      ),
      Text(
        'Банковской картой',
        style: TextStyle(
          color: Color(0xFF9E9E9E),
          fontSize: 18,
          fontFamily: 'Book Antiqua Bold',
        ),
      ),
    ];

    if (_isOnlineSelected) {
      children.insert(
        0,
        Container(
          margin: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.check,
            color: Colors.blueAccent,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _isOnlineSelected = !_isOnlineSelected;
          if (_isOnlineSelected && _isCashSelected) {
            _isCashSelected = !_isCashSelected;
          }
        });
      },
      child: AnimatedContainer(
        margin: EdgeInsets.only(top: 10.0),
        height: 40.0,
        duration: Duration(milliseconds: 100),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 10.0,
            ),
          ],
        ),
        child: Row(
          children: children,
        ),
      ),
    );
  }

  Widget _getCheckableCashWidget(context) {
    List<Widget> children = [
      Container(
        margin: EdgeInsets.only(left: 5.0, right: 5.0),
        child: Icon(
          Icons.attach_money_rounded,
          color: Color(0xFF754831),
        ),
      ),
      Text(
        'Наличными курьеру',
        style: TextStyle(
          color: Color(0xFF9E9E9E),
          fontSize: 18,
          fontFamily: 'Book Antiqua Bold',
        ),
      ),
    ];

    if (_isCashSelected) {
      children.insert(
        0,
        Container(
          margin: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.check,
            color: Colors.blueAccent,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _isCashSelected = !_isCashSelected;
          if (_isCashSelected && _isOnlineSelected) {
            _isOnlineSelected = !_isOnlineSelected;
          }
        });
      },
      child: AnimatedContainer(
        margin: EdgeInsets.only(top: 10.0),
        height: 40.0,
        duration: Duration(milliseconds: 100),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 10.0,
            ),
          ],
        ),
        child: Row(
          children: children,
        ),
      ),
    );
  }

  Widget _getProductWidget(dynamic prInfo, BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      height: MediaQuery.of(context).size.height / 4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 10.0,
            color: Colors.grey,
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width / 3,
            margin: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(prInfo["info"]["pictures"][0]["url"]),
              ),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10.0, left: 5.0),
            width: MediaQuery.of(context).size.width / 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  "${prInfo["info"]["price"]} Руб.",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: 'Poor Richard',
                    color: Color(0xFF403D3D),
                  ),
                ),
                Text(
                  Utils.fromUTF8(prInfo["info"]["name"]),
                  style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: 'Poor Richard',
                    color: Color(0xFF403D3D),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 10.5),
                  child: Text(
                    'Количество: ${prInfo["amount"]}\nОбщая стоимость: ${prInfo["info"]["price"] * prInfo["amount"]}',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: 'Book Antiqua',
                      color: Color(0xFF403D3D),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getProductsListWidget(BuildContext context) {
    List<Widget> children = List<Widget>();

    children.add(
      Text(
        'Состав заказа',
        style: TextStyle(
          color: Color(0xFF9E9E9E),
          fontSize: 18,
          fontFamily: 'Book Antiqua Bold',
        ),
      ),
    );

    for (dynamic pr in _cartFullInfo["allProducts"]["products"]) {
      children.add(_getProductWidget(pr, context));
    }

    children.add(
      SizedBox(
        height: 5.0,
      ),
    );

    return Container(
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(
            color: Colors.blueGrey,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }

  Widget _getReceiverInfoWidget(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(
            color: Colors.blueGrey,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Получатель',
            style: TextStyle(
              color: Color(0xFF9E9E9E),
              fontSize: 18,
              fontFamily: 'Book Antiqua Bold',
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5.0, left: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  "Имя: ${Utils.fromUTF8(_cartFullInfo["receiverName"])}",
                  style: TextStyle(
                    color: Color(0xFF9E9E9E),
                    fontSize: 15,
                    fontFamily: 'Book Antiqua Bold',
                  ),
                ),
                Text(
                  "Телефон: ${_cartFullInfo["receiverPhone"]}",
                  style: TextStyle(
                    color: Color(0xFF9E9E9E),
                    fontSize: 15,
                    fontFamily: 'Book Antiqua Bold',
                  ),
                ),
                Text(
                  "Почта: ${_cartFullInfo["receiverEmail"]}",
                  style: TextStyle(
                    color: Color(0xFF9E9E9E),
                    fontSize: 15,
                    fontFamily: 'Book Antiqua Bold',
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getDeliveryMethodString() {
    if (_cartFullInfo["deliveryMethod"] == "COURIER") {
      return "Курьером";
    }

    return "Самовывоз";
  }

  String _getDeliveryAddressString() {
    if (_cartFullInfo["deliveryMethod"] == "COURIER") {
      return "ул. ${_cartFullInfo["receiverStreet"]}, д. ${_cartFullInfo["receiverHouseNum"]}, кв./офис ${_cartFullInfo["receiverApartmentNum"]}";
    }

    return "Варшавская улица, д. 59";
  }

  String _getDeliveryComment() {
    return _cartFullInfo["deliveryComment"] != ""
        ? _cartFullInfo["deliveryComment"]
        : "Без комментария";
  }

  Widget _getShippingInfoWidget(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(
            color: Colors.blueGrey,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Способ доставки',
            style: TextStyle(
              color: Color(0xFF9E9E9E),
              fontSize: 18,
              fontFamily: 'Book Antiqua Bold',
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5.0, left: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  "Как: ${_getDeliveryMethodString()}",
                  style: TextStyle(
                    color: Color(0xFF9E9E9E),
                    fontSize: 15,
                    fontFamily: 'Book Antiqua Bold',
                  ),
                ),
                Text(
                  "Куда/откуда: ${_getDeliveryAddressString()}",
                  style: TextStyle(
                    color: Color(0xFF9E9E9E),
                    fontSize: 15,
                    fontFamily: 'Book Antiqua Bold',
                  ),
                ),
                Text(
                  "Комментарий: ${_getDeliveryComment()}",
                  style: TextStyle(
                    color: Color(0xFF9E9E9E),
                    fontSize: 15,
                    fontFamily: 'Book Antiqua Bold',
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getOrderWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _getProductsListWidget(context),
          _getReceiverInfoWidget(context),
          _getShippingInfoWidget(context),
        ],
      ),
    );
  }

  double _getShippingPrice() {
    if (_cartFullInfo["deliveryMethod"] == "COURIER") {
      return 300.0;
    }

    return 0.0;
  }

  double _getFinalPrice() {
    double cartPrice = _cartFullInfo["price"];

    if (_cartFullInfo["deliveryMethod"] == "COURIER") {
      return cartPrice + 300.0;
    }

    return cartPrice;
  }

  Widget _getFinalPriceWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Общая стоимость:",
                style: TextStyle(
                  color: Color(0xFF9E9E9E),
                  fontSize: 15,
                  fontFamily: 'Book Antiqua Bold',
                ),
              ),
              Text(
                "${_cartFullInfo["price"]} Руб.",
                style: TextStyle(
                  color: Color(0xFF9E9E9E),
                  fontSize: 15,
                  fontFamily: 'Poor Richard',
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Доставка:",
                style: TextStyle(
                  color: Color(0xFF9E9E9E),
                  fontSize: 15,
                  fontFamily: 'Book Antiqua Bold',
                ),
              ),
              Text(
                "${_getShippingPrice()} Руб.",
                style: TextStyle(
                  color: Color(0xFF9E9E9E),
                  fontSize: 15,
                  fontFamily: 'Poor Richard',
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Итого к оплате:",
                style: TextStyle(
                  color: Color(0xFF9E9E9E),
                  fontSize: 15,
                  fontFamily: 'Book Antiqua Bold',
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "${_getFinalPrice()} Руб.",
                style: TextStyle(
                  color: Color(0xFF9E9E9E),
                  fontSize: 15,
                  fontFamily: 'Poor Richard',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _onConfirmButtonPressed(BuildContext context) async {
    if (!_isCashSelected && !_isOnlineSelected) {
      Alert(
        context: context,
        title: "Выберите один из способов оплаты",
        buttons: [
          DialogButton(
            child: Text(
              "Ок",
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFFFFFFFF),
                fontFamily: 'Book Antiqua',
              ),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ).show();
      return;
    }

    await CartService.updatePaymentInfo(
      _isCashSelected ? "cash" : "online",
    );
    await CartService.increaseCartStatus();
    await CartService.createOrder();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AccountScreen(),
      ),
    );
  }

  Widget _getBodyWidget(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(
          top: 10.0,
          left: 10.0,
          right: 10.0,
        ),
        child: Column(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Выберите способ оплаты',
                  style: TextStyle(
                    color: Color(0xFF9E9E9E),
                    fontSize: 18,
                    fontFamily: 'Book Antiqua Bold',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _getCheckableOnlineWidget(context),
                _getCheckableCashWidget(context),
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  child: Text(
                    'Проверьте заказ',
                    style: TextStyle(
                      color: Color(0xFF9E9E9E),
                      fontSize: 18,
                      fontFamily: 'Book Antiqua Bold',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _getOrderWidget(context),
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  child: Text(
                    'Финальная стоимость',
                    style: TextStyle(
                      color: Color(0xFF9E9E9E),
                      fontSize: 18,
                      fontFamily: 'Book Antiqua Bold',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _getFinalPriceWidget(context),
                SizedBox(
                  height: 20.0,
                ),
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width / 1.9,
              child: RaisedButton(
                color: Color(0xFFC9C9C9),
                onPressed: () => _onConfirmButtonPressed(context),
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.9,
                  alignment: Alignment.center,
                  child: Text(
                    'Подтвердить',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFFFFFFFF),
                      fontFamily: 'Book Antiqua Bold',
                    ),
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width / 1.2,
              child: Center(
                child: Text(
                  'при подтверждении заказы, вы соглашаетесь с \nПолитикой конфиденциальности и с условиями публичной офертой',
                  style: TextStyle(
                    fontSize: 9,
                    color: Color(0xFF111111),
                    fontFamily: 'Book Antiqua',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded || _cartFullInfo == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xFFFFFBFF),
      appBar: _getAppBar(context),
      body: _getBodyWidget(context),
    );
  }
}
