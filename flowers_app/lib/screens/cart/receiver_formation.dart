import 'dart:convert';

import 'package:flowers_app/common/utils.dart';
import 'package:flowers_app/rest_api/rest_api_auth.dart';
import 'package:flowers_app/rest_api/rest_api_cart.dart';
import 'package:flowers_app/screens/cart/shipping_formation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class ReceiverFormationScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ReceiverFormationState();
}

class _ReceiverFormationState extends State<ReceiverFormationScreen> {
  bool _isLoaded = false;
  dynamic _userData;

  final _formKey = GlobalKey<FormState>();

  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _phoneTextController = TextEditingController();

  Future<void> _fetchUserData() async {
    _userData = await AuthService.getUserInfo();
  }

  @override
  void initState() {
    super.initState();

    _fetchUserData().then((value) {
      setState(() {
        _nameTextController.text = Utils.fromUTF8(_userData["name"]);
        _emailTextController.text = _userData["email"];
        _phoneTextController.text = _userData["phone"];

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
                        fontWeight: FontWeight.bold,
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

  InputDecoration _getInputDecoration(labelText) {
    return InputDecoration(
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.blueAccent,
        ),
      ),
      labelText: labelText,
      labelStyle: TextStyle(
        color: Colors.blueAccent,
      ),
      errorStyle: TextStyle(
        color: Colors.redAccent,
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.redAccent,
        ),
      ),
      focusedErrorBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.redAccent,
        ),
      ),
    );
  }

  _onButtonPressed(BuildContext context) async {
    var validateRes = _formKey.currentState.validate();
    if (!validateRes) {
      return;
    }

    await CartService.updateReceiverInfo(
      _nameTextController.text,
      _emailTextController.text,
      _phoneTextController.text,
    );

    await CartService.increaseCartStatus();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ShippingFormationScreen(),
      ),
    );
  }

  Widget _getBodyWidget(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.always,
        child: Container(
          margin: EdgeInsets.only(
            top: 10.0,
            left: 10.0,
            right: 10.0,
          ),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nameTextController,
                validator: RequiredValidator(
                  errorText: "Это поле обязательно к заполнению",
                ),
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF828282),
                  fontFamily: 'Book Antiqua',
                ),
                decoration: _getInputDecoration("Имя получателя"),
              ),
              TextFormField(
                controller: _emailTextController,
                validator: MultiValidator(
                  [
                    EmailValidator(
                        errorText: "Вы ввели неверный почтовый адрес"),
                    RequiredValidator(
                        errorText: "Это поле обязательно к заполнению"),
                  ],
                ),
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF828282),
                  fontFamily: 'Book Antiqua',
                ),
                decoration: _getInputDecoration("Почта получателя"),
              ),
              TextFormField(
                controller: _phoneTextController,
                validator: MultiValidator(
                  [
                    RequiredValidator(
                      errorText: "Это поле обязательно к заполнению",
                    ),
                  ],
                ),
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF828282),
                  fontFamily: 'Book Antiqua',
                ),
                decoration: _getInputDecoration("Телефон получателя"),
              ),
              Container(
                margin: EdgeInsets.only(top: 20.0),
                child: RaisedButton(
                  color: Color(0xFFC9C9C9),
                  onPressed: () => _onButtonPressed(context),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.6,
                    alignment: Alignment.center,
                    child: Text(
                      'Выбрать способ доставки',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFFFFFFFF),
                        fontFamily: 'Book Antiqua Bold',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded) {
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
