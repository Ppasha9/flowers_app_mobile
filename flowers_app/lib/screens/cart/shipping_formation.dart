import 'package:flowers_app/rest_api/rest_api_cart.dart';
import 'package:flowers_app/screens/cart/payment_formation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ShippingFormationScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ShippingFormationState();
}

class _ShippingFormationState extends State<ShippingFormationScreen> {
  bool _isCourierSelected = false;
  bool _isPickupSelected = false;

  final _formKey = GlobalKey<FormState>();

  final _streetTextController = TextEditingController();
  final _houseNumTextController = TextEditingController();
  final _apartmentNumTextController = TextEditingController();
  final _commentTextController = TextEditingController();

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
                        fontWeight: FontWeight.bold,
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

  Widget _getCheckableCourierWidget(context) {
    List<Widget> children = [
      Container(
        margin: EdgeInsets.only(left: 5.0, right: 5.0),
        child: Icon(
          Icons.directions_car_rounded,
          color: Color(0xFF754831),
        ),
      ),
      Text(
        'Курьером',
        style: TextStyle(
          color: Color(0xFF9E9E9E),
          fontSize: 18,
          fontFamily: 'Book Antiqua Bold',
        ),
      ),
      Container(
        margin: EdgeInsets.only(
            left: _isCourierSelected
                ? MediaQuery.of(context).size.width / 2.6
                : MediaQuery.of(context).size.width / 2.2),
        child: Text(
          '300 Руб.',
          style: TextStyle(
            color: Color(0xFF9E9E9E),
            fontSize: 16,
            fontFamily: 'Poor Richard',
          ),
        ),
      ),
    ];

    if (_isCourierSelected) {
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
          _isCourierSelected = !_isCourierSelected;
          if (_isCourierSelected && _isPickupSelected) {
            _isPickupSelected = !_isPickupSelected;
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

  Widget _getCheckablePickupWidget(context) {
    List<Widget> children = [
      Container(
        margin: EdgeInsets.only(left: 5.0, right: 5.0),
        child: Icon(
          Icons.gps_fixed_rounded,
          color: Color(0xFF754831),
        ),
      ),
      Text(
        'Самовывоз',
        style: TextStyle(
          color: Color(0xFF9E9E9E),
          fontSize: 18,
          fontFamily: 'Book Antiqua Bold',
        ),
      ),
      Container(
        margin: EdgeInsets.only(
            left: _isPickupSelected
                ? MediaQuery.of(context).size.width / 2.6
                : MediaQuery.of(context).size.width / 2.2),
        child: Text(
          '0 Руб.',
          style: TextStyle(
            color: Color(0xFF9E9E9E),
            fontSize: 16,
            fontFamily: 'Poor Richard',
          ),
        ),
      ),
    ];

    if (_isPickupSelected) {
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
          _isPickupSelected = !_isPickupSelected;
          if (_isPickupSelected && _isCourierSelected) {
            _isCourierSelected = !_isCourierSelected;
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

  _onButtonPressed(context) async {
    if (_isCourierSelected) {
      var validateRes = _formKey.currentState.validate();
      if (!validateRes) {
        return;
      }
    }

    if (!_isCourierSelected && !_isPickupSelected) {
      Alert(
        context: context,
        title: "Выберите один из способов доставки",
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

    await CartService.updateShippingInfo(
      _streetTextController.text,
      _houseNumTextController.text,
      _apartmentNumTextController.text,
      _commentTextController.text,
      _isCourierSelected ? "courier" : "pickup",
    );
    await CartService.increaseCartStatus();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PaymentFormationScreen(),
      ),
    );
  }

  Widget _getBody(BuildContext context) {
    List<Widget> children = [
      Container(
        margin: EdgeInsets.only(top: 10.0),
        child: Text(
          'Выберите способ доставки',
          style: TextStyle(
            color: Color(0xFF9E9E9E),
            fontSize: 18,
            fontFamily: 'Book Antiqua Bold',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      _getCheckableCourierWidget(context),
      _getCheckablePickupWidget(context),
    ];

    if (!_isPickupSelected) {
      children.insertAll(
        0,
        <Widget>[
          Text(
            'Введите адрес доставки',
            style: TextStyle(
              color: Color(0xFF9E9E9E),
              fontSize: 18,
              fontFamily: 'Book Antiqua Bold',
              fontWeight: FontWeight.bold,
            ),
          ),
          TextFormField(
            controller: _streetTextController,
            validator: RequiredValidator(
              errorText: "Это поле обязательно к заполнению",
            ),
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF828282),
              fontFamily: 'Book Antiqua',
            ),
            decoration: _getInputDecoration("Улица*"),
          ),
          TextFormField(
            controller: _houseNumTextController,
            validator: RequiredValidator(
              errorText: "Это поле обязательно к заполнению",
            ),
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF828282),
              fontFamily: 'Book Antiqua',
            ),
            decoration: _getInputDecoration("Дом*"),
          ),
          TextFormField(
            controller: _apartmentNumTextController,
            validator: RequiredValidator(
              errorText: "Это поле обязательно к заполнению",
            ),
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF828282),
              fontFamily: 'Book Antiqua',
            ),
            decoration: _getInputDecoration("Квартира/офис*"),
          ),
          TextFormField(
            controller: _commentTextController,
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF828282),
              fontFamily: 'Book Antiqua',
            ),
            decoration: _getInputDecoration("Комментарий"),
          ),
        ],
      );
    } else {
      children.add(
        Container(
          margin: EdgeInsets.only(top: 10.0),
          alignment: Alignment.center,
          child: Text(
            'Пункт самовывоза находится здесь:\nВаршавская улица, д. 59',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF9E9E9E),
              fontSize: 15,
              fontFamily: 'Book Antiqua Bold',
            ),
          ),
        ),
      );
    }

    children.add(
      Container(
        margin: EdgeInsets.only(top: 20.0),
        child: RaisedButton(
          color: Color(0xFFC9C9C9),
          onPressed: () => _onButtonPressed(context),
          child: Container(
            width: MediaQuery.of(context).size.width / 1.6,
            alignment: Alignment.center,
            child: Text(
              'Выбрать способ оплаты',
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFFFFFFFF),
                fontFamily: 'Book Antiqua Bold',
              ),
            ),
          ),
        ),
      ),
    );

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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFBFF),
      appBar: _getAppBar(context),
      body: _getBody(context),
    );
  }
}
