import 'dart:ffi';

import 'package:flowers_app/common/utils.dart';
import 'package:flowers_app/components/navigation_bar.dart';
import 'package:flowers_app/rest_api/rest_api_cart.dart';
import 'package:flowers_app/screens/account/signin.dart';
import 'package:flowers_app/screens/cart/payment_formation.dart';
import 'package:flowers_app/screens/cart/receiver_formation.dart';
import 'package:flowers_app/screens/cart/shipping_formation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isLoaded = false;
  String _cartStatus = "";
  dynamic _products;

  Future<void> _fetchAllProducts() async {
    CartService.getAllProducts().then((value) {
      setState(() {
        _products = value;
      });
    });
  }

  Future<bool> _checkIsLogged() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isLogged");
  }

  Future<String> _getStatus() async {
    return await CartService.getCartStatus();
  }

  @override
  void initState() {
    super.initState();
    _checkIsLogged().then((value) {
      if (!value) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => SigninScreen(),
          ),
        );
        return;
      }

      _fetchAllProducts().then((value) {
        _getStatus().then((value1) {
          setState(() {
            _cartStatus = value1;
            _isLoaded = true;
          });
        });
      });
    });
  }

  int _getAllProductsAmount() {
    int res = 0;
    for (dynamic pr in _products["products"]) {
      res += pr["amount"];
    }

    return res;
  }

  double _getAllPrice() {
    double res = 0.0;

    for (dynamic pr in _products["products"]) {
      res += pr["amount"] * pr["info"]["price"];
    }

    return res;
  }

  _clearCart() async {
    await CartService.clearCart();
    await _fetchAllProducts();
  }

  Widget _getAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      primary: false,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Color(0xFF754831),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Container(
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 5.5,
        ),
        width: MediaQuery.of(context).size.width / 3.3,
        alignment: Alignment.center,
        child: Center(
          child: Text(
            'Корзина',
            style: TextStyle(
              fontSize: 25,
              color: Color(0xFFB1ADAD),
              fontFamily: 'Book Antiqua',
            ),
          ),
        ),
      ),
      bottom: PreferredSize(
        child: Container(
          margin: EdgeInsets.only(bottom: 10.0),
          child: Text(
            "Всего ${_getAllProductsAmount()} товаров на сумму ${_getAllPrice()}",
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFFB1B1B1),
              fontFamily: 'Book Antiqua',
            ),
          ),
        ),
        preferredSize: Size.fromHeight(4.0),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.delete_forever_sharp,
            color: Color(0xFF754831),
          ),
          onPressed: () => _clearCart(),
        ),
      ],
    );
  }

  _addProductToCart(productId) async {
    await CartService.addProductToCart(productId);
    await _fetchAllProducts();
  }

  _removeProductFromCart(productId) async {
    await CartService.removeProductFromCart(productId);
    await _fetchAllProducts();
  }

  Widget _getProductWidget(dynamic prInfo, BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      height: MediaQuery.of(context).size.height / 3,
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
            margin: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(prInfo["info"]["pictures"][0]["url"]),
              ),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
          ),
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10.0),
                width: MediaQuery.of(context).size.width / 3,
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
                        fontFamily: 'Book Antiqua',
                        color: Color(0xFF403D3D),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                width: MediaQuery.of(context).size.width / 5,
                height: 20.0,
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 4.6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        child: Icon(
                          Icons.remove,
                          color: Colors.black,
                        ),
                        onTap: () =>
                            _removeProductFromCart(prInfo["info"]["id"]),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      alignment: Alignment.center,
                      child: Text(
                        prInfo["amount"].toString(),
                        style: TextStyle(
                          fontSize: 19.0,
                          fontFamily: 'Poor Richard',
                          color: Color(0xFF403D3D),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        child: Icon(
                          Icons.add,
                          color: Colors.black,
                        ),
                        onTap: () => _addProductToCart(prInfo["info"]["id"]),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getOrderFormationScreen() {
    if (_cartStatus == "Default" || _cartStatus == "Receiver_Formation") {
      return ReceiverFormationScreen();
    } else if (_cartStatus == "Shipping_Formation") {
      return ShippingFormationScreen();
    } else if (_cartStatus == "Payment_Formation") {
      return PaymentFormationScreen();
    }

    return null;
  }

  _onConfirmButtonPressed(BuildContext context) async {
    if (_cartStatus == "Default") {
      await CartService.increaseCartStatus();
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _getOrderFormationScreen(),
      ),
    );
  }

  Widget _getConfirmButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      child: RaisedButton(
        color: Color(0xFFC9C9C9),
        onPressed: () => _onConfirmButtonPressed(context),
        child: Container(
          width: _cartStatus == 'Default'
              ? MediaQuery.of(context).size.width / 1.8
              : MediaQuery.of(context).size.width / 1.2,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                _cartStatus == 'Default'
                    ? 'Оформить заказ'
                    : 'Продолжить оформление заказа',
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFFFFFFFF),
                  fontFamily: 'Book Antiqua Bold',
                ),
              ),
              Icon(
                Icons.shop_rounded,
                color: Color(0xFFFFFFFF),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _getProductsListOfWidgets(BuildContext context) {
    List<Widget> res = List<Widget>();

    for (dynamic pr in _products["products"]) {
      res.add(_getProductWidget(pr, context));
    }

    res.add(_getConfirmButton(context));

    return res;
  }

  Widget _getBody(BuildContext context) {
    if (_products["products"].length == 0) {
      return SingleChildScrollView(
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Text(
              "Вы еще не добавили товаров в корзину.\n Пора это исправить!",
              style: TextStyle(
                fontSize: 25,
                color: Color(0xFFB1ADAD),
                fontFamily: 'Book Antiqua',
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: 10.0),
        child: Column(
          children: _getProductsListOfWidgets(context),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded || _products == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xFFFFFBFF),
      appBar: _getAppBar(context),
      bottomNavigationBar: getNavigationBar(context),
      body: _getBody(context),
    );
  }
}
