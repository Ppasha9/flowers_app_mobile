import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:orlove_app/constants.dart';
import 'package:orlove_app/http/cart_controller.dart';
import 'package:orlove_app/screens/order_formation/order_formation_shippment_screen.dart';
import 'package:orlove_app/storage/storage.dart';
import 'package:orlove_app/utils/utils.dart';

class OrderFormationReceiverContentWidget extends StatefulWidget {
  @override
  _OrderFormationReceiverContentWidgetState createState() =>
      _OrderFormationReceiverContentWidgetState();
}

class _OrderFormationReceiverContentWidgetState
    extends State<OrderFormationReceiverContentWidget> {
  final _formKey = GlobalKey<FormState>();

  final _nameTextController = TextEditingController();
  final _surnameTextController = TextEditingController();
  final _phoneTextController = TextEditingController();
  final _emailTextController = TextEditingController();

  Widget _getNameInputWidget(MediaQueryData mediaQuery) {
    return TextFormField(
      keyboardType: TextInputType.name,
      controller: _nameTextController,
      style: TextStyle(
        color: ProjectConstants.APP_FONT_COLOR,
        fontFamily: ProjectConstants.APP_FONT_FAMILY,
        fontSize: 15 * mediaQuery.textScaleFactor,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        hintText: "Имя*",
        hintStyle: TextStyle(
          color: ProjectConstants.APP_FONT_COLOR,
          fontFamily: ProjectConstants.APP_FONT_FAMILY,
          fontSize: 15 * mediaQuery.textScaleFactor,
          fontWeight: FontWeight.w600,
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: ProjectConstants.DEFAULT_STROKE_COLOR,
          ),
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
      ),
      validator: RequiredValidator(
        errorText: "Это поле обязательно к заполнению",
      ),
    );
  }

  Widget _getSurnameInputWidget(MediaQueryData mediaQuery) {
    return TextFormField(
      keyboardType: TextInputType.name,
      controller: _surnameTextController,
      style: TextStyle(
        color: ProjectConstants.APP_FONT_COLOR,
        fontFamily: ProjectConstants.APP_FONT_FAMILY,
        fontSize: 15 * mediaQuery.textScaleFactor,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        hintText: "Фамилия*",
        hintStyle: TextStyle(
          color: ProjectConstants.APP_FONT_COLOR,
          fontFamily: ProjectConstants.APP_FONT_FAMILY,
          fontSize: 15 * mediaQuery.textScaleFactor,
          fontWeight: FontWeight.w600,
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: ProjectConstants.DEFAULT_STROKE_COLOR,
          ),
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
      ),
      validator: RequiredValidator(
        errorText: "Это поле обязательно к заполнению",
      ),
    );
  }

  Widget _getPhoneInputWidget(MediaQueryData mediaQuery) {
    return TextFormField(
      keyboardType: TextInputType.phone,
      controller: _phoneTextController,
      style: TextStyle(
        color: ProjectConstants.APP_FONT_COLOR,
        fontFamily: ProjectConstants.APP_FONT_FAMILY,
        fontSize: 15 * mediaQuery.textScaleFactor,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        hintText: "Телефон*",
        hintStyle: TextStyle(
          color: ProjectConstants.APP_FONT_COLOR,
          fontFamily: ProjectConstants.APP_FONT_FAMILY,
          fontSize: 15 * mediaQuery.textScaleFactor,
          fontWeight: FontWeight.w600,
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: ProjectConstants.DEFAULT_STROKE_COLOR,
          ),
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
      ),
      validator: RequiredValidator(
        errorText: "Это поле обязательно к заполнению",
      ),
    );
  }

  Widget _getEmailInputWidget(MediaQueryData mediaQuery) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: _emailTextController,
      style: TextStyle(
        color: ProjectConstants.APP_FONT_COLOR,
        fontFamily: ProjectConstants.APP_FONT_FAMILY,
        fontSize: 15 * mediaQuery.textScaleFactor,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        hintText: "Почта*",
        hintStyle: TextStyle(
          color: ProjectConstants.APP_FONT_COLOR,
          fontFamily: ProjectConstants.APP_FONT_FAMILY,
          fontSize: 15 * mediaQuery.textScaleFactor,
          fontWeight: FontWeight.w600,
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: ProjectConstants.DEFAULT_STROKE_COLOR,
          ),
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
      ),
      validator: MultiValidator(
        [
          RequiredValidator(
            errorText: "Это поле обязательно к заполнению",
          ),
          EmailValidator(
            errorText: "Неверный адрес почты",
          ),
        ],
      ),
    );
  }

  Future _onConfirmButtonPressed(BuildContext context) async {
    final validateRes = _formKey.currentState.validate();
    if (!validateRes) {
      return;
    }

    await CartController.updateReceiverInfo(
      _nameTextController.text,
      _surnameTextController.text,
      _emailTextController.text,
      _phoneTextController.text,
    );
    await CartController.increaseCartStatus();
    await Utils.getAllCartInfo();

    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (_) => OrderFormationShippmentScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _nameTextController.text = SecureStorage.name;
    _emailTextController.text = SecureStorage.email;
    _phoneTextController.text = SecureStorage.phone;
    _surnameTextController.text = SecureStorage.surname;

    final mediaQuery = MediaQuery.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _getNameInputWidget(mediaQuery),
                SizedBox(
                  height: 5.0,
                ),
                _getSurnameInputWidget(mediaQuery),
                SizedBox(
                  height: 5.0,
                ),
                _getPhoneInputWidget(mediaQuery),
                SizedBox(
                  height: 5.0,
                ),
                _getEmailInputWidget(mediaQuery),
                SizedBox(
                  height: 5.0,
                ),
              ],
            ),
          ),
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
      ],
    );
  }
}
